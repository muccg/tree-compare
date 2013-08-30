Tree Compare
============

Compares two trees of regular files and prints the files only present in 
one directory.

Files are considered to be the same if the base name, size, and the hash
of the first and last megabyte of data match.

Usage:
    ./treecompare.py <cache_file> <master_dir> <check_against_dir>

cache_file: file in which to store the SHA1 hash cache. This is used to avoid the need 
to repeatedly hash files if the tool is run more than once.

master_dir: the directory which we wish to check for files not in 'check_against_dir'

check_against_dir: directory we are considering copying files into. Note that files in this 
directory that are not in 'master_dir' will not be detected - this is a one direction scan.
