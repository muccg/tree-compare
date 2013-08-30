#!/usr/bin/env python2.6

import sys, os, stat, json
from pprint import pprint
from hashlib import sha1

class FileInformationKey(object):
    def __init__(self, info):
        self.basename = info.get_basename()
        self.sha_hash = info.get_sha_hash()
        self.key = (
            self.basename,
            info.get_size(),
            self.sha_hash
        )

    def __eq__(self, k):
        return k == self.key

    def __hash__(self):
        return hash(self.key)

    def __repr__(self):
        return self.get_basename() + ' @' + self.sha_hash[:8] + ''

    def get_basename(self):
        return self.basename

class FileInformation(object):
    """
    describes a file within the inventory
    """
    hash_size = 1<<20
    def __init__(self, base_path, path, stat_info, sha_hash):
        self.base_path, self.path, self.stat_info, self.sha_hash = base_path, path, stat_info, sha_hash
        self.key = FileInformationKey(self)
        # print >>sys.stderr, "scan: %s" % self.key

    def get_basename(self):
        return os.path.basename(self.path)

    def get_dirname(self):
        return os.path.dirname(self.path)

    def get_path(self):
        return self.path

    def get_abspath(self):
        return os.path.join(self.base_path, self.path)

    def get_key(self):
        return self.key

    def get_size(self):
        return self.stat_info.st_size

    def get_sha_hash(self):
        return self.sha_hash

    @classmethod
    def directory_iter(cls, hasher, base_path, subdir=''):
        """
        yields a FileInformation instance for each regular file under subdir, 
        recursing into directories. `fname` is relative to base_path, 
        and `st` is the stat information for the file
        """
        dirname = os.path.join(base_path, subdir)
        for fname in os.listdir(dirname):
            st = os.stat(os.path.join(dirname, fname))
            # recurse into directories and yield back out
            if stat.S_ISDIR(st.st_mode):
                for file_info in cls.directory_iter(hasher, base_path, os.path.join(subdir, fname)):
                    yield file_info
            elif stat.S_ISREG(st.st_mode):
                size = st.st_size
                sha_hash = hasher.get_hash(os.path.join(base_path, subdir, fname), size)
                yield cls(base_path, os.path.join(subdir, fname), st, sha_hash)

class Inventory(object):
    """
    inventory of files under a subdirectory
    """
    def __init__(self, hasher, dir):
        self.hasher = hasher
        self.dir = dir
        self.index = self.build_index()
        self.key_lookup = self.build_key_lookup()

    def get_dir(self):
        return self.dir

    def build_index(self):
        idx = []
        for info in FileInformation.directory_iter(self.hasher, self.dir):
            idx.append(info)
        return idx

    def build_key_lookup(self):
        """
        builds a dictionary (key) -> [ FileInformation, ... ]
        """
        lookup = {}
        for info in self.index:
            key = info.get_key()
            if key not in lookup:
                lookup[key] = []
            lookup[key].append(info)
        return lookup

    def key_set(self):
        """
        build a set of all keys in the inventory
        """
        return set(t.get_key() for t in self.index)

    def lookup_key(self, key):
        """
        returns the path(s) for the key within the inventory
        """
        return self.key_lookup[key]

class Hasher(object):
    def __init__(self, fpath):
        self.fpath = fpath
        try:
            with open(self.fpath) as fd:
                self.cache = json.load(fd)
        except IOError:
            self.cache = {}
        self.dirty = False

    def set(self, k, v):
        self.dirty = True
        print("SHA: %s %s" % (k, v))
        self.cache[k] = v

    def get_hash(self, fname, size):
        if fname not in self.cache:
            h = sha1()
            with open(fname, 'rb') as fd:
                data = fd.read(FileInformation.hash_size)
                h.update(data)
                if size > FileInformation.hash_size:
                    fd.seek(-FileInformation.hash_size, 2)
                    data = fd.read(FileInformation.hash_size)
                    h.update(data)
            self.set(fname, h.hexdigest())
        return self.cache[fname]

    def save(self):
        if not self.dirty:
            pass
        tmp = self.fpath + '.tmp'
        with open(tmp, 'w') as fd:
            json.dump(self.cache, fd)
        os.rename(tmp, self.fpath)

if __name__ == '__main__':
    hasher = Hasher(sys.argv[1])
    from_inventory, to_inventory = [Inventory(hasher, t) for t in sys.argv[2:]]

    def build_copy_actions(inv_a, inv_b):
        inv_a_set = inv_a.key_set()
        inv_b_set = inv_b.key_set()

        to_copy = []

        for key in sorted(inv_a_set - inv_b_set, key=lambda k: k.get_basename()):
            infos = inv_a.lookup_key(key)
            if len(infos) > 1:
                raise Exception("true (identical) file duplicate. abort.")
            to_copy.append(infos[0])

        for info in sorted(to_copy, key=lambda i: i.get_abspath()):
            print (info.get_abspath())

    hasher.save()

    actions = build_copy_actions(from_inventory, to_inventory)

