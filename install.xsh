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

class DevTools(Item):
    def _darwin(self):
        pass

    def _ubuntu(self):
        sudo apt install -y cmake

    def _linux(self):
        if "Ubuntu" in RELEASE:
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

    def _linux(self):
        if "Ubuntu" in RELEASE:
            self._ubuntu()
        self._common()

    def _common(self):
        if Path(self.config).exists():
            l.info("(NeoVim) deleting previous configuration")
            rm -Rf @(self.config)
        l.info("(NeoVim) copying configuration")
        cp -R rc/.config/nvim/ ~/.config

    def _info(self):
        return "NeoVim"

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

class Zsh(Item):
    def _darwin(self):
        pass

    def _linux(self):
        l.info("Installing .zshrc")
        cp ./rc/.zshrc ~/.zshrc

    def _info(self):
        return "zsh"

@install.command("zsh")
def install_zsh():
    """Install zsh and configuration"""
    Zsh().install()

# items = [XonshRc(), 
#          Todoist(), 
#          Fonts(), 
#          Kitty(), 
#          DevTools(), 
#          NeoVim(),
#          KeepassXC(), 
#          EnvFile(), 
#          EmacsSecrets(), 
#          Mu(), 
#          Rust(), 
#          Nim(),
#          Zsh()]

# for item in items:
    
#     if not item.installed():
#         print_color("[🐚] {GREEN}Installing " + item._info() + "{RESET}")
#         item.install()
#     else:
#         print_color("[🐚] {YELLOW}" + item._info() + " already installed{RESET}")
if __name__ == "__main__":
    setup()