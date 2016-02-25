#!env python
import os
from colors import red, green, blue
import glob
import shutil

CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))

def is_sudo():
    return os.getuid() == 0

def copy(pattern, destination, message):
    print green(message)
    for file in glob.glob(pattern):
        print file
        shutil.copy(file, destination)

def copy_scripts():
    copy(pattern = CURRENT_DIR + r'\*',
        destination = '/usr/local/bin',
        message = 'Copying scripts to /usr/local/bin')

def symlink(src, dst):
    os.symlink(src, dst)
    print "[" + green("symlink") + "] creating symlink from " + src + " to " + dst

if __name__ == "__main__":
    if not is_sudo():
        print red('This script needs sudo.')
    else:
        copy_scripts()
        # symlink emacs
        symlink(os.path.join(CURRENT_DIR, ".emacs.d"), os.path.join(os.path.expanduser('~'), ".emacs.d"))
