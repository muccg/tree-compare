#!/usr/bin/env python2.6

"""
Usage: 
  tree-compare.py [options] MASTER_DIRECTORY SCAN_DIRECTORY

Options:
  -c --cache=NAME  Cache file for SHA1 sums
  -t --target=NAME  Target directory 
  -x --output-shellscript=NAME  Write shell script to filename which executes required cp/mkdir (requires -t)
  -l --log=NAME  Write log to file (CSV format)

"""

__version__ = '0.0.1'

from docopt import docopt
import sys, os, stat, json, csv, time, pipes
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

    def get_mtime(self):
        return self.stat_info.st_mtime

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
        self.cache = self.load()
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

    def load(self):
        if self.fpath is None:
            return {}
        try:
            with open(self.fpath) as fd:
                return json.load(fd)
        except IOError:
            return {}

    def save(self):
        if not self.dirty:
            return
        if self.fpath is None:
            return
        tmp = self.fpath + '.tmp'
        with open(tmp, 'w') as fd:
            json.dump(self.cache, fd)
        os.rename(tmp, self.fpath)

if __name__ == '__main__':
    def run():
        hasher = Hasher(args['--cache'])
        master_inventory = Inventory(hasher, args['MASTER_DIRECTORY'])
        scan_inventory = Inventory(hasher, args['SCAN_DIRECTORY'])

        def build_copy_list(inv_a, inv_b):
            inv_a_set = inv_a.key_set()
            inv_b_set = inv_b.key_set()

            to_copy = []
            total_size = 0

            abort = False

            for key in sorted(inv_a_set - inv_b_set, key=lambda k: k.get_basename()):
                infos = inv_a.lookup_key(key)
                if len(infos) > 1:
                    print >>sys.stderr, "** Identical files in master **"
                    for info in sorted(infos, key=lambda k: k.get_abspath()):
                        print >>sys.stderr, "    %s" % (info.get_abspath())
                to_copy.append(infos[0])
                total_size += infos[0].get_size()

            print >>sys.stderr, "%s: total size of copy: %gGB" % (master_inventory.get_dir(), total_size/(1<<30)) 
            return to_copy

        def write_debug_log(to_copy):
            outf = args['--log']
            if outf is None:
                return
            with open(outf, 'w') as fd:
                writer = csv.writer(fd)
                writer.writerow([ 'Timestamp', 'Filename' ])
                for info in sorted(to_copy, key=lambda i: i.get_abspath()):
                    writer.writerow( [ time.strftime("%Y-%m-%d", time.localtime(info.get_mtime())), info.get_abspath() ])

        def write_shell_script(to_copy):
            outf = args['--output-shellscript']
            if outf is None:
                return
            target = args['--target']

            made_dirs = set()
            with open(outf, 'w') as fd:
                for info in sorted(to_copy, key=lambda i: i.get_abspath()):
                    target_path = os.path.join(target, info.get_path())
                    target_dir = os.path.dirname(target_path)
                    if target_dir not in made_dirs:
                        print >>fd, "\n# %s" % (pipes.quote(os.path.dirname(os.path.join(info.get_path()))))
                        print >>fd, "mkdir -p %s" % pipes.quote(target_dir)
                        made_dirs.add(target_dir)
                    print >>fd, "rsync -a %s %s" % (pipes.quote(info.get_abspath()), pipes.quote(target_path))

        hasher.save()
        to_copy = build_copy_list(master_inventory, scan_inventory)
        write_debug_log(to_copy)
        write_shell_script(to_copy)

    def validate():
        if args['--output-shellscript'] is not None and args['--target'] is None:
            print >>sys.stderr, "--target required with --output-shellscript"
            sys.exit(1)

    args = docopt(__doc__, version=__version__)
    validate()
    run()
