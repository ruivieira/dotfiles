# dotfiles

A collection of configuration and setup files I am currently using across several machines. This will also install software I frequently use on macOS and Linux.

## setup

There are two approaches to install these configurations, with [Ansible](https://www.ansible.com/) or [pyinfra](https://pyinfra.com/).

**WARNING** running either of these methods locally _will delete_ some of you current configurations,
if they exist, (`./config/nvim`, `.bashrc`, `.zshrc`, `.emacs.d/`, _etc._)

### pyinfra

You can test the setup inside a container if you have [podman](https://podman.io/)/Docker installed.

```shell
pyinfra @docker/fedora:32 deploy.py
```

If you want to try it locally, first read the **WARNING** above.
Install `pyinfra` with `pip install pyinfra` and then run the deploy script locally:

```shell
pyinfra -vvv @local deploy.py
```

### Ansible

Read the **WARNING** above.
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
If you have podman/docker installed build the image with:

```shell
docker build -t dotfiles:latest .
docker run -i -t dotfiles:latest /bin/zsh
```

To run locally (did I mention you should read the **WARNING** above?), issue:

```shell
ansible-playbook install.yml -K
```

Alternatively, run each tag separately, _e.g._

```shell
ansible-playbook install.yml --tags "core,editors" -K
```

### tags

The `ansible` playbook includes the following tags:

- `core`, essential CLI tools
- `editors`, a collection of text editors (spacemacs, NeoVim, micro, etc.)
- `jupyter` install jupyter notebooks along with a Java and R kernels
- `vscode`, setup for VSCode (config, extensions)

### Shell functions

The following shell functions are provided:

- `.functions.zsh`, general environment management (Docker, pyenv, _etc_)
- `.builders.zsh`, general project template builders (Quarkus, _etc_)

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

- The `Spleen` font is available [here](https://github.com/fcambus/spleen)
- Remarkable 2 splash screens from `sblumentritt` (available [here](https://github.com/sblumentritt/remarkable_splashscreens))
