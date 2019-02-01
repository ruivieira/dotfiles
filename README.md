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

## Testing

On macOS to test the installation you first have to, at least, install the `zsh` target:

```
make -f Mafefile.mac zsh
```

then run the `zunit` test suite by simply calling:

```
zunit
```

## Acknowledgements

* The `Spleen` font is available [here](https://github.com/fcambus/spleen).
