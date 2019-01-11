dotfiles
========

A collection of configuration and setup files I am currently using across several machines. This will also install software I frequently use on macOS and Linux.

## Setup

To prepare a macOS machine, make sure you have `brew` and `make` installed.
Then run:

```
make -f Makefile.mac all
```

On a Linux (currently only Fedora supported) machine simply run:

```
make -f Makefile.linux all
``` 

on macOS, to find out which packages/apps you're missing, run:

```
make -f Makefile.mac check
```

## Acknowledgements

* The `Spleen` font is available [here](https://github.com/fcambus/spleen).
