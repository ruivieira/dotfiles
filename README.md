dotfiles
========

A collection of configuration and setup files I am currently using across several machines. This will also install software I frequently use on macOS and Linux.

## setup

To prepare a macOS machine, make sure you have `brew` and `ansible` installed.
After installing `brew`, you can install `ansible` with:

```shell
brew install ansible
```

On Fedora just run

```shell
dnf install ansible
```

To try it without installing locally using the container.
If you have docker installed build the image with:

```shell
docker build -t dotfiles:latest .
docker run -i -t dotfiles:latest /bin/zsh
```

*WARNING* running this playbook locally *will delete* some of you current configurations, if they exit (`./config/nvim`, `.bashrc`, `.zshrc`, `.emacs.d/`, etc.)

### tags

The `ansible` playbook includes the following tags:

* `core`, essential CLI tools
* `editors`, a collection of text editors (spacemacs, NeoVim, micro, etc.)

## Acknowledgements

* The `Spleen` font is available [here](https://github.com/fcambus/spleen).
