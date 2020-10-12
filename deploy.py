from pyinfra import host
from pathlib import Path
import os
import glob
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
    def __init__(self, comment):
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
        pass

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


java = JavaAction()
graalvm = GraalVMAction()
poetry = PoetryAction(bash_profile=bashProfile)
fonts = Fonts()
vscodeSettings = VSCodeSettings()

# Install vim
if host.fact.linux_name == "Fedora":
    dnf.packages(
        name="Install Vim",
        packages=["vim"],
        latest=True,
        sudo=True,
        use_sudo_password=True,
    )
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
    brew.packages(name="Install Vim", packages=["vim"], update=False, upgrade=False)

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

    rEnv = Env("This hack is a work around a R/Java bug in macOS")
    rEnv.ENV["LD_LIBRARY_PATH"] = "$(/usr/libexec/java_home -v 1.8)/jre/lib/server"

    bashProfile.ENVS.append(rEnv)

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
