#!/usr/bin/env xonsh
from abc import ABC, abstractmethod
from pathlib import Path
import os
import click

@click.group()
def setup():
    """
    Manage setup
    """
    pass

@setup.group()
def install():
    """
    Install software
    """
    pass


@install.command("robby")
def install_robby():
    """Install robby xontrib"""
    xpip install ~/Sync/code/robby/robby -U --force

import xontrib.xlog as l

OS=$(uname -s).strip()
RELEASE=$(uname -v).strip()
FEDORA=p"/etc/fedora-release".exists()
UBUNTU=p"/etc/lsb-release".exists()
EMAIL="rui@fastmail.org"

# General macOS behaviour
if OS=="Darwin":
    $HOMEBREW_NO_INSTALL_CLEANUP=1 
    $HOMEBREW_NO_ENV_HINTS=1

class Item(ABC):
    def install(self):
        if not self.installed():
            print_color("[🐚] {GREEN}Installing " + self._info() + "{RESET}")
        else:
            print_color("[🐚] {YELLOW}" + self._info() + " already installed{RESET}")

        if OS=="Darwin":
            self._darwin()
        else:
            self._linux()
    @abstractmethod
    def _darwin(self):
        pass
    @abstractmethod
    def _linux(self):
        pass
    @abstractmethod
    def _info(self) -> str:
        pass
    def installed(self) -> bool:
        """Return False by default"""
        return False

# todoist CLI
class Todoist(Item) :
    def _darwin(self):
        brew tap sachaos/todoist
        brew install todoist
    def _linux(self):
        cd /tmp
        git clone https://github.com/sachaos/todoist.git
        cd todoist
        go build
        sudo mv todoist /usr/local/bin
        rm -Rf todoist
    def _info(self):
        return "todoist CLI"
    def installed(self):
        return !(which todoist).returncode==0

# xonsh configuration
class XonshRc(Item):
    def _darwin(self):
        cp rc/.xonshrc ~/.xonshrc
    def _linux(self):
        self._darwin()
    def _info(self):
        return ".xonshrc"

# todoist CLI
class Fonts(Item):
    def _darwin(self):
        pass
    def _linux(self):
        fc=".config/fontconfig/conf.d"
        mkdir -p ~/@(fc)
        cp @(fc)/99-fira-code-color-emoji.conf ~/@(fc)
        fc-cache
    def _info(self):
        return "fonts"

class Kitty(Item):
    def _darwin(self):
        self._linux()

    def _linux(self):
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        cp -R ./rc/kitty ~/.config/
        # TODO: Add symlink to /usr/local/bin?

    def _info(self):
        return "Kitty"

@install.command("kitty")
def install_kitty():
    """Install the Kitty terminal emulator"""
    Kitty().install()

class DevTools(Item):
    def _darwin(self):
        pass

    def _ubuntu(self):
        sudo apt install -y cmake

    def _linux(self):
        if UBUNTU:
            self._ubuntu()        

    def _info(self):
        return "common development tools"

class NeoVim(Item):
    def __init__(self):
        self.root = "~/.local/share/nvim/site/pack/packer/start/"
        self.config = os.path.expanduser("~/.config/nvim")

    def _darwin(self):
        pass

    def _ubuntu(self):
        if !(which nvim).returncode==0:
          sudo snap refresh nvim
        else:
          sudo snap install --beta nvim --classic

    def _fedora(self):
        sudo dnf -y install neovim

    def _linux(self):
        if UBUNTU:
            self._ubuntu()
        elif FEDORA:
            self._fedora()
        self._common()

    def _common(self):
        if Path(self.config).exists():
            l.info("(NeoVim) deleting previous configuration")
            rm -Rf @(self.config)
        l.info("(NeoVim) copying configuration")
        cp -R rc/.config/nvim/ ~/.config
        l.info("Install Vim-Plug")
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


    def _info(self):
        return "NeoVim"

@install.command("neovim")
def install_neovim():
    """Install NeoVim"""
    NeoVim().install()

class Nim(Item):
    def _darwin(self):
        self._common()
    def _linux(self):
        self._common()
    def _common(self):
        if !(which choosenim).returncode==0:
            choosenim update self
            choosenim update stable
        else:
            curl https://nim-lang.org/choosenim/init.sh -sSf | sh
    def _info(self):
        return "Nim"

@install.command("nim")
def install_nim():
    """Install the Nim toolchain"""
    Nim().install()

class KeepassXC(Item):
    def _darwin(self):
        brew install --cask keepassxc

    def _linux(self):
        pass

    def _info(self):
        return "KeepassXC"

    def installed(self):
        cli = !(which keepassxc-cli).returncode==0
        return cli

def get_b2_attribute(db, key_file, entry, attribute):    
    return $(keepassxc-cli show --no-password -k @(key_file) -sa @(attribute) @(db) @(entry)).strip()

class EnvFile(Item):
    def _darwin(self):
        self._linux()

    def _linux(self):
        data = f"""
# B2
export B2_ACCOUNT_ID='{get_b2_attribute($ARG1, $ARG2, "B2", "account_id")}'
export B2_ACCOUNT_KEY='{get_b2_attribute($ARG1, $ARG2, "B2", "account_key")}'
export RESTIC_PASSWORD='{get_b2_attribute($ARG1, $ARG2, "Restic", "Password")}'
export KOPIA_PASSWORD='{get_b2_attribute($ARG1, $ARG2, "Kopia", "Password")}'

# AWS/Wasabi
export AWS_ACCESS_KEY_ID='{get_b2_attribute($ARG1, $ARG2, "Wasabi", "backup_user_key_id")}'
export AWS_SECRET_ACCESS_KEY='{get_b2_attribute($ARG1, $ARG2, "Wasabi", "backup_user_secret_key")}'

export WASABI_KOPIA_BUCKET='{get_b2_attribute($ARG1, $ARG2, "Wasabi", "kopia_bucket")}'
export WASABI_KOPIA_ACCESS_KEY='{get_b2_attribute($ARG1, $ARG2, "Wasabi", "access_key")}'
export WASABI_KOPIA_SECRET_KEY='{get_b2_attribute($ARG1, $ARG2, "Wasabi", "secret_key")}'
export WASABI_KOPIA_ENDPOINT='{get_b2_attribute($ARG1, $ARG2, "Wasabi", "endpoint")}'

# B2
export B2_KOPIA_BUCKET='{get_b2_attribute($ARG1, $ARG2, "B2", "kopia_bucket")}'
export B2_KOPIA_ACCESS_KEY='{get_b2_attribute($ARG1, $ARG2, "B2", "kopia_key_id")}'
export B2_KOPIA_SECRET_KEY='{get_b2_attribute($ARG1, $ARG2, "B2", "account_key")}'
export WASABI_KOPIA_ENDPOINT='{get_b2_attribute($ARG1, $ARG2, "Wasabi", "endpoint")}'
export WASABI_KOPIA_PASSWORD='{get_b2_attribute($ARG1, $ARG2, "Kopia", "Password")}'

# Kopia
export KOPIA_PASSWORD='{get_b2_attribute($ARG1, $ARG2, "Kopia", "Password")}'

# sourcehut OAuth token
export SOURCEHUT_PAGES_OAUTH="{get_b2_attribute($ARG1, $ARG2, "Sourcehut", "oauth")}"

# Todoist token
export TODOIST_TOKEN="{get_b2_attribute($ARG1, $ARG2, "Todoist", "token")}"

# IRC
export IRC_NICK="{get_b2_attribute($ARG1, $ARG2, "IRC", "sasl_username")}"
export IRC_HOST="{get_b2_attribute($ARG1, $ARG2, "IRC", "host")}"
export IRC_PORT="{get_b2_attribute($ARG1, $ARG2, "IRC", "port")}"
export IRC_SASL_USERNAME="{get_b2_attribute($ARG1, $ARG2, "IRC", "sasl_username")}"
export IRC_SASL_PASSWORD="{get_b2_attribute($ARG1, $ARG2, "IRC", "sasl_password")}"
""" 
        echo @(data) > ~/.bash_profile

    def _info(self):
        return "environment variables"

class EmacsSecrets(Item):
    def _darwin(self):
        self._linux()

    def _linux(self):
        data = f"""
(use-package! circe
  :config
  (setq circe-network-options
        '(("Libera"
           :tls t
           :nick "{get_b2_attribute($ARG1, $ARG2, "IRC", "sasl_username")}"
           :host "{get_b2_attribute($ARG1, $ARG2, "IRC", "host")}"
           :port "{get_b2_attribute($ARG1, $ARG2, "IRC", "port")}"
           :sasl-username "{get_b2_attribute($ARG1, $ARG2, "IRC", "sasl_username")}"
           :sasl-password "{get_b2_attribute($ARG1, $ARG2, "IRC", "sasl_password")}"))
        circe-reduce-lurker-spam t))
""" 
        echo @(data) > ~/.emacs-secrets.el

    def _info(self):
        return "Emacs secrets"

class Mu(Item):
    def _darwin(self):
        brew install isync mu
        self._common()

    def _linux(self):
        if UBUNTU:
            sudo apt-get install -y isync maildir-utils mu4e
        elif FEDORA:
            sudo dnf install -y isync maildir-utils mu4e
        self._common()

    def _info(self):
        return "maildir-utils"

    def _common(self):
        if not p"~/Maildir".exists():
            mkdir -p ~/Maildir/INBOX
        mu init
        mbsync -a
        mu index
        MBSYNC_PWD = get_b2_attribute($ARG1, $ARG2, "Fastmail", "emacs")
        echo @(MBSYNC_PWD) > ~/.mbsync-fastmail
        AUTH_INFO = f"machine smtp.fastmail.com login {EMAIL} password {MBSYNC_PWD} port 465"
        echo @(AUTH_INFO) > ~/.authinfo


class Emacs(Item):
    pass

@install.command("emacs")
def install_emacs():
    """Install Emacs and config"""
    pass

class Rust(Item):
    def _darwin(self):
        self._common()

    def _linux(self):
        self._common()

    def _common(self):
        if !(which rustup).returncode!=0:
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        else:
            l.info("Rustup already installed. Updating.")
            rustup update stable
        if !(which rust-analyzer).returncode!=0:
            # Rust analyzer (LSP)
            l.info("Installing rust-analyzer (LSP)")
            cd /tmp
            if p"rust-analyzer".exists():
                rm -Rf rust-analyzer
            git clone https://github.com/rust-analyzer/rust-analyzer.git
            cd rust-analyzer
            cargo xtask install
        else:
            l.info("Rust Analyzer already installed")

    def _info(self):
        return "Rust"

@install.command("rust")
def install_rust():
    """Install the Rust toolchain"""
    Rust().install()

class Zsh(Item):
    def _darwin(self):
        self._common()
        echo "export LIB_PYTHON=/usr/local/Cellar/python@3.9/3.9.13_2/Frameworks/Python.framework/Versions/3.9/Python" >> ~/.zshrc

    def _linux(self):
        sudo apt -y install cargo
        self._common()

    def _common(self):
        l.info("Installing .zshrc")
        cp ./rc/.zshrc ~/.zshrc
        if not p'~/.oh-my-zsh/custom/plugins/zsh-z'.exists():
            l.info("Installing Z")
            git clone https://github.com/agkozak/zsh-z ~/.oh-my-zsh/custom/plugins/zsh-z
        if not p'~/.oh-my-zsh/custom/plugins/zsh-autosuggestions'.exists():
            l.info("Installing zsh-autosuggestions")
            git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        if not p'~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting'.exists():
            l.info("Installing zsh-syntax-highlighting")
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        l.info("Installing zsh Gruvbox theme")
        curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme

    def _info(self):
        return "zsh"

@install.command("zsh")
def install_zsh():
    """Install zsh and configuration"""
    Zsh().install()

class Zellij(Item):
    def _darwin(self):
        self._common("apple-darwin")

    def _linux(self):
        self._common("unknown-linux-musl")

    def _common(self, prefix : str):
        VERSION="0.31.1"
        FILENAME=f"zellij-x86_64-{prefix}.tar.gz"
        cd /tmp
        wget https://github.com/zellij-org/zellij/releases/download/v@(VERSION)/@(FILENAME)
        tar -xvf @(FILENAME)
        chmod +x zellij
        sudo mv zellij /usr/local/bin
        rm @(FILENAME)
        l.info("Copying Zellij config")
        ZELLIJ_CONFIG="~/.config/zellij"
        mkdir -p @(ZELLIJ_CONFIG)
        cp ~/Sync/code/dotfiles/rc/zellij/config.yaml @(ZELLIJ_CONFIG)

    def _info(self):
        return "Zellij"

@install.command("zellij")
def install_zellij():
    """Install Zellij"""
    Zellij().install()

class Hugo(Item):
    def __init__(self):
        self.VERSION = "0.101.0"
    def _darwin(self):
        pass
    def _linux(self):
        FILENAME=f"hugo_extended_{self.VERSION}_Linux-64bit.tar.gz"
        cd /tmp
        wget https://github.com/gohugoio/hugo/releases/download/v@(VERSION)/@(FILENAME)
        tar zxvf @(FILENAME)
        sudo mv hugo /usr/local/bin
        rm @(FILENAME)

    def _info(self):
        return "Hugo"

@install.command("hugo")
def install_hugo():
    """Install Hugo"""
    Hugo().install()


class SublimeMerge(Item):
    def _linux(self):
        if FEDORA:
            l.info("Add repositories")
            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            l.info("Installing")
            sudo dnf install -y sublime-merge
        elif UBUNTU:
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
            sudo apt-get install apt-transport-https
            l.info("Add repositories")
            echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            sudo apt-get install sublime-merge
            l.info("Installing")
    def _darwin(self):
        pass
    def _info(self):
        return "Sublime Merge"

@install.command("sublime-merge")
def install_sublime_merge():
    """Install Sublime Merge"""
    SublimeMerge().install()

if __name__ == "__main__":
    setup()
