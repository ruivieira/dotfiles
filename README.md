# dotfiles

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

**WARNING** running this playbook locally *will delete* some of you current configurations, if they exit (`./config/nvim`, `.bashrc`, `.zshrc`, `.emacs.d/`, etc.)

To run locally (please read the above **WARNING**), issue:

```shell
ansible-playbook install.yml -K
```

Alternatively, run each tag separately, *e.g.*

```shell
ansible-playbook install.yml --tags "core,editors" -K
```

### tags

The `ansible` playbook includes the following tags:

* `core`, essential CLI tools
* `editors`, a collection of text editors (spacemacs, NeoVim, micro, etc.)
* `jupyter` install jupyter notebooks along with a Java and R kernels
* `vscode`, setup for VSCode (config, extensions)

### Shell functions

The following shell functions are provided:

* `.functions.zsh`, general environment management (Docker, pyenv, *etc*)
* `.builders.zsh`, general project template builders (Quarkus, *etc*)

### Editor

Theia is provided as an editor. The `Dockerfile`s are available under `/theia`.
To build an image (say, `theia-java`), run:

```shell
$ cd theia/java
$ docker build -t ruivieira/theia-java:latest .
```

To run it, go to the folder you want to use as the workplace and run:

```shell
$ cd $PROJECT
$ docker run -it --init -p 3000:3000 -p 8080:8080 -v "$(pwd):/home/project:cached" ruivieira/theia-java:latest
```

Here, Theia will be available on port `3000`. Port `8080` is reserved in case you want to test some service on that port.

## troubleshooting

### `libreadline`

On macOS the installation of R might fail with the message `dyld: Library not loaded: /usr/local/opt/readline/lib/libreadline.7.dylib`. If this is the case, just symlink the `readline` version you have to v7. _e.g._, if have v8:

```shell
ln -s /usr/local/opt/readline/lib/libreadline.8.0.dylib /usr/local/opt/readline/lib/libreadline.7.dylib
```

## Acknowledgements

* The `Spleen` font is available [here](https://github.com/fcambus/spleen).
