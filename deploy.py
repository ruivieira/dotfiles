from pyinfra import host
from pathlib import Path
import os
from pyinfra.operations import files, dnf, brew, server
from abc import ABC, abstractmethod

HOME = str(Path.home())


class Action(ABC):
    def __init__(self):
        if host.fact.linux_name == "Fedora":
            self.action_fedora()
        if host.fact.os == "Darwin":
            self.action_darwin()

        self.post_action()

    @abstractmethod
    def action_fedora(self) -> None:
        pass

    @abstractmethod
    def action_darwin(self) -> None:
        pass

    @abstractmethod
    def post_action(self) -> None:
        pass


class BashProfile:
    def __init__(self):
        self.PATH = []
        self.ENVS = []


class Env:
    def __init__(self, comment: str):
        self.comment = comment
        self.ENV = {}


bashProfile = BashProfile()
ALIASES = dict()


class JavaAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self):
        pass

    def action_fedora(self):
        dnf.packages(
            name="Install OpenJDK11",
            packages=["java-11-openjdk-devel.x86_64"],
            latest=True,
            sudo=True,
            use_sudo_password=True,
        )

    def post_action(self):
        javaHomeEnv = Env("Set Java home to OpenJDK11")
        javaHomeEnv.ENV["JAVA_HOME"] = "/usr/lib/jvm/java-11/"
        bashProfile.ENVS.append(javaHomeEnv)

        bashProfile.PATH.append("$JAVA_HOME/bin")


class GraalVMAction(Action):
    """Install GraalVM on the host machine"""

    def __init__(self):
        self.GRAALVM = {}
        self.GRAALVM["VERSION"] = "20.2.0"
        super().__init__()

    def action_darwin(self):
        self.GRAALVM[
            "FILE"
        ] = f"graalvm-ce-java11-darwin-amd64-{self.GRAALVM['VERSION']}.tar.gz"
        self.GRAALVM["DEST"] = "/Library/Java/JavaVirtualMachines/"
        self.GRAALVM[
            "HOME"
        ] = f"/Library/Java/JavaVirtualMachines/graalvm-ce-java11-{self.GRAALVM['VERSION']}/Contents/Home"
        self.GRAALVM["BIN"] = f"{self.GRAALVM['HOME']}/bin"

    def action_fedora(self):
        self.GRAALVM[
            "FILE"
        ] = f"graalvm-ce-java11-linux-amd64-{self.GRAALVM['VERSION']}.tar.gz"
        self.GRAALVM["DEST"] = "/opt/"
        self.GRAALVM["HOME"] = f"/opt/graalvm-ce-java11-{self.GRAALVM['VERSION']}"
        self.GRAALVM["BIN"] = f"{self.GRAALVM['HOME']}/bin"

    def post_action(self):
        files.download(
            name=f"graalvm: Downloading GraalVM {self.GRAALVM['VERSION']}",
            src=f"https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{self.GRAALVM['VERSION']}/{self.GRAALVM['FILE']}",
            dest=f"{HOME}/tmp/{self.GRAALVM['FILE']}",
        )

        server.shell(
            name="graalvm: Untar GraalvM tar.gz file",
            commands=[
                f"/usr/bin/tar -zxvf /{HOME}/tmp/{self.GRAALVM['FILE']} -C {self.GRAALVM['DEST']}"
            ],
            sudo=True,
            use_sudo_password=True,
        )

        bashProfile.PATH.append(self.GRAALVM["BIN"])

        server.shell(
            name="graalvm: Install native image add-on",
            commands=[f"{self.GRAALVM['BIN']}/gu install native-image"],
            sudo=True,
            use_sudo_password=True,
        )


class VSCodeSettings(Action):
    def __init__(self):
        super().__init__()
        self._setting_location = ""

    def action_darwin(self):
        self._setting_location = (
            f"{HOME}/Library/Application Support/Code/User/settings.json"
        )

    def action_fedora(self):
        self._setting_location = f"{HOME}/.config/Code/User/settings.json"

    def post_action(self):
        # copy VSCode user settings
        files.template(
            name="Create VSCode settings",
            src="templates/vscode_settings.j2",
            dest=self._setting_location,
        )


class PoetryAction(Action):
    def __init__(self, bash_profile: BashProfile):
        self.bash_profile = bash_profile
        super().__init__()

    def action_darwin(self):
        pass

    def action_fedora(self):
        pass

    def post_action(self):
        server.shell(
            name="Download poetry",
            commands=[
                f"curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -"
            ],
            sudo=True,
            use_sudo_password=True,
        )

        bashProfile.PATH.append("~/.poetry/bin")


class JuliaAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self):
        brew.packages(
            name="Install Julia", packages=["julia"], update=False, upgrade=False
        )

    def action_fedora(self):
        server.shell(
            name="Enable Julia COPR",
            commands=["dnf copr enable nalimilan/julia -y"],
            sudo=True,
            use_sudo_password=True,
        )
        dnf.packages(
            name="Install Julia",
            packages=["julia"],
            latest=True,
            sudo=True,
            use_sudo_password=True,
        )

    def post_action(self):
        # TODO: Install base packages
        pass


class NaviAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self):
        # TODO: Install navi on Darwin
        pass

    def action_fedora(self):
        # TODO: Install navi on Fedora
        pass

    def post_action(self):
        sheets = ["openshift", "zsh", "k8s"]
        # for sheet in sheets:
        #     files.download(
        #         name=f"Install Navi {sheet} repo",
        #         src=f"https://raw.githubusercontent.com/geometricfirs/{sheet}.cheat/master/{sheet}.cheat",
        #         dest=f"{HOME}/.config/navi/{sheet}.cheat",
        #         force=True,
        #     )


class KittyAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self) -> None:
        brew.packages(
            name="Install Kitty", packages=["kitty"], update=False, upgrade=False
        )

    def action_fedora(self) -> None:
        dnf.packages(
            name="Install Kitty",
            packages=["kitty"],
            latest=True,
            sudo=True,
            use_sudo_password=True,
        )

    def post_action(self) -> None:
        files.directory(f"{HOME}/.config/kitty", present=True, assume_present=False)
        # export kitty.conf
        filename = ".config/kitty/kitty.conf"
        files.template(
            name=f"Create {filename}",
            src="templates/kitty.j2",
            dest=f"{HOME}/{filename}",
        )


class Fonts(Action):
    def __init__(self):
        self.source = "fonts/juliamono/*.ttf"
        super().__init__()

    def action_darwin(self):
        server.shell(
            name="Install Julia Mono fonts",
            commands=[f"cp {self.source} ~/Library/Fonts/"],
        )

    def action_fedora(self):
        files.directory(f"{HOME}/.local/share/fonts", present=True)
        server.shell(
            name="Install Julia Mono fonts",
            commands=[f"cp {self.source} ~/.local/share/fonts/"],
        )
        server.shell(
            name="Update font cache",
            commands=[f"fc-cache -v"],
        )

    def post_action(self):
        pass


class SyncthingAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self) -> None:
        brew.packages(
            name="Install Syncthing",
            packages=["syncthing"],
            update=False,
            upgrade=False,
        )
        server.shell(
            name="Start Syncthing service",
            commands=["brew services start syncthing"],
        )

    def action_fedora(self) -> None:
        pass

    def post_action(self) -> None:
        server.shell(
            name="Install Syncthing global ignore patterns",
            commands=[f"cp templates/.stignore.j2 ~/Sync/.stignore"],
        )


class ZshAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self) -> None:
        pass

    def action_fedora(self) -> None:
        pass

    def post_action(self) -> None:
        server.shell(
            name="Copy Zsh functions",
            commands=[f"cp .functions.zsh ~/"],
        )


class VimAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self) -> None:
        brew.packages(name="Install Vim", packages=["vim"], update=False, upgrade=False)

    def action_fedora(self) -> None:
        dnf.packages(
            name="Install Vim",
            packages=["vim"],
            latest=True,
            sudo=True,
            use_sudo_password=True,
        )

    def post_action(self) -> None:
        # install Pathogen
        files.directory(f"{HOME}/.vim/autoload", present=True)
        files.directory(f"{HOME}/.vim/bundle", present=True)

        files.template(
            name=f"[Vim] Install .vimrc",
            src="templates/.vimrc",
            dest=f"{HOME}/.vim/.vimrc",
        )
        server.shell(
            name="[Vim] Download Pathogen",
            commands=[
                f"curl -LSso {HOME}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
            ],
        )
        server.shell(
            name="[Vim] Install vim-plug",
            commands=[
                f"curl -fLo {HOME}/.vim/autoload/plug.vim --create-dirs "
                + "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
            ],
        )


class PyenvAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self) -> None:
        brew.packages(
            name="Install pyenv", packages=["pyenv"], update=False, upgrade=False
        )

    def action_fedora(self) -> None:
        dnf.packages(
            name="Install pyenv",
            packages=["pyenv"],
            latest=True,
            sudo=True,
            use_sudo_password=True,
        )

    def post_action(self) -> None:
        pass

class ResticAction(Action):
    def __init__(self):
        super().__init__()

    def action_darwin(self) -> None:
        brew.packages(
            name="Install restic", packages=["restic"], update=False, upgrade=False
        )
    def action_fedora(self) -> None:
        pass

    def post_action(self) -> None:
        pass

java = JavaAction()
graalvm = GraalVMAction()
poetry = PoetryAction(bash_profile=bashProfile)
fonts = Fonts()
vscodeSettings = VSCodeSettings()
# julia = JuliaAction()
navi = NaviAction()
# kitty = KittyAction()
syncthing = SyncthingAction()
zsh = ZshAction()
vim = VimAction()
pyenv = PyenvAction()
restic = ResticAction()

# Install vim
if host.fact.linux_name == "Fedora":
    dnf.packages(
        name="Install cURL",
        packages=["curl"],
        latest=True,
        sudo=True,
        use_sudo_password=True,
    )

    # Default Fedora path
    bashProfile.PATH.append("/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin")


if host.fact.os == "Darwin":

    brew.packages(name="Install cURL", packages=["curl"])

    # Default macOS path
    bashProfile.PATH.append("/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin")

    javaEnv = Env("macOS specific java environment")

    # Java paths
    javaEnv.ENV["JAVA_8_HOME"] = "$(/usr/libexec/java_home -v1.8)"
    javaEnv.ENV["JAVA_11_HOME"] = "$(/usr/libexec/java_home -v11)"
    javaEnv.ENV["GRAALVM_HOME"] = graalvm.GRAALVM["HOME"]

    bashProfile.ENVS.append(javaEnv)

    texEnv = Env("TeXLive for macOS")
    texEnv.ENV["TEX"] = "/usr/local/texlive/2016/bin/x86_64-darwin"

    bashProfile.ENVS.append(texEnv)
    bashProfile.PATH.append("$TEX")

    # add C/clang build environment
    buildEnv = Env("Build environment")
    buildEnv.ENV["ARCHFLAGS"] = '"-arch x86_64"'

    bashProfile.ENVS.append(buildEnv)

    rEnv = Env("This hack is a work around a R/Java bug in macOS")
    rEnv.ENV["LD_LIBRARY_PATH"] = "$(/usr/libexec/java_home -v 1.8)/jre/lib/server"

    bashProfile.ENVS.append(rEnv)

    # Copy macOS hosts file
    files.template(
        name=f"Create /etc/hosts",
        src="templates/hosts.j2",
        dest=f"/etc/hosts",
        CRC_HOST=os.getenv("CRC_HOST", "127.0.0.1"),
        HOST=host.fact.os,
        sudo=True,
        use_sudo_password=True,
    )

    # restart/flush DNS cache
    server.shell(
        name="Restart/flush DNS cache",
        commands=["killall -HUP mDNSResponder"],
        sudo=True,
        use_sudo_password=True,
    )


ALIASES = {
    "ls": r"ls -a -1 -o -F -h -l",
    "cd..": "cd ..",
    "dir": "ls",
    "eprofile": "$EDITOR ~/.bash_profile",
    "rprofile": "source ~/.bash_profile",
    "tree": "find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'",
    "..": "cd ..",
    "bu": "brew update && brew upgrade && brew cleanup",
    "java8": "export JAVA_HOME=$JAVA_8_HOME",
    "java11": "export JAVA_HOME=$JAVA_11_HOME",
    "javagraal": "export JAVA_HOME=$GRAALVM_HOME",
}
# export .bash_profile
files.template(
    name="Create .bash_profile",
    src="templates/.bash_profile.j2",
    dest=f"{HOME}/.bash_profile",
    PATH=":".join(bashProfile.PATH),
    ENVS=bashProfile.ENVS,
    ALIASES=ALIASES,
)
# .zshrc
files.template(
    name="Create .zshrc",
    src="templates/.zshrc.j2",
    dest=f"{HOME}/.zshrc",
)
