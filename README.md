# dotfiles

A collection of configuration and setup files I am currently using across several machines. This will also install software I frequently use on macOS and Linux (mainly Ubuntu and Fedora).

## Setup

There are two approaches to install these configurations, with [xonsh](https://xon.sh/) or [Ansible](https://www.ansible.com/).

> **⚠️ WARNING ⚠️** running either of these methods locally _will delete_ some of you current configurations,
if they exist, (`./config/nvim`, `.bashrc`, `.zshrc`, `.emacs.d/`, _etc._)

To prepare a macOS machine, make sure you have either `brew` and `ansible` installed.
After installing `brew`, you can install `ansible` with:

```shell
brew install ansible
```

On Fedora just run

```shell
dnf install ansible
```

Alternatively install `xonsh` using

```shell
python -m pip install 'xonsh[full]'
```

`xonsh` is [also available](https://xon.sh/) for other package manager such as `apt` or `dnf`.

### Vagrant

The best option is to use `Vagrant`. If `Vagrant` is already
installed simply run

```shell
vagrant up --provision
```

and then 

```shell
vagrant ssh
```

to inspect the installation.

### Container

To try it without installing locally using the container.
If you have `podman`/`docker` installed build the image with:

```shell
docker build -t dotfiles:latest .
docker run -i -t dotfiles:latest /bin/zsh
```

### Locally (here be 🐉)

To run locally (did I mention you should read the **⚠️ WARNING ⚠️** above?), issue:

```shell
ansible-playbook --connection=local --inventory 127.0.0.1, playbook.yml -K
```

Alternatively, run each tag separately, _e.g._ running the tasks tagged `core` 

```shell
ansible-playbook --connection=local --inventory 127.0.0.1, playbook.yml --tags "core" -K
```

Using it with `xonsh` is simply a case of running 

```shell
./install.xsh install <component>
```

Where component can be `zsh`, `nim`, etc...

## Tags

The `ansible` playbook includes the following tags:

- `core`, essential CLI tools
- `editors`, a collection of text editors (spacemacs, NeoVim, micro, etc.)
- `jupyter` install jupyter notebooks along with a Java and R kernels
- `vscode`, setup for VSCode (config, extensions)
- `doomemacs`, my doom emacs personal configuration

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
