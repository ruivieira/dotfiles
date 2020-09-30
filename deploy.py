from pyinfra import host
from pathlib import Path
from pyinfra.operations import files, dnf, brew, server

HOME = str(Path.home())


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

GRAALVM = {}


def installJava(deployment):
    if deployment == "Darwin":
        pass
    elif deployment == "Fedora":
        dnf.packages(
            name="Install OpenJDK11",
            packages=["java-11-openjdk-devel.x86_64"],
            latest=True,
            sudo=True,
            use_sudo_password=True,
        )

    javaHomeEnv = Env("Set Java home to OpenJDK11")
    javaHomeEnv.ENV["JAVA_HOME"] = "/usr/lib/jvm/java-11/"
    bashProfile.ENVS.append(javaHomeEnv)

    bashProfile.PATH.append("$JAVA_HOME/bin")


def installGraalVM(deployment):
    """Install GraalVM on the host machine

    Args:
        deployment ([str]): Fedora or Darwin
    """
    GRAALVM["VERSION"] = "20.2.0"
    if deployment == "Darwin":
        GRAALVM["FILE"] = f"graalvm-ce-java11-darwin-amd64-{GRAALVM['VERSION']}.tar.gz"
        GRAALVM["DEST"] = "/Library/Java/JavaVirtualMachines/"
        GRAALVM[
            "HOME"
        ] = f"/Library/Java/JavaVirtualMachines/graalvm-ce-java11-{GRAALVM['VERSION']}/Contents/Home"
        GRAALVM["BIN"] = f"{GRAALVM['HOME']}/bin"
    elif deployment == "Fedora":
        GRAALVM["FILE"] = f"graalvm-ce-java11-linux-amd64-{GRAALVM['VERSION']}.tar.gz"
        GRAALVM["DEST"] = "/opt/"
        GRAALVM["HOME"] = f"/opt/graalvm-ce-java11-{GRAALVM['VERSION']}"
        GRAALVM["BIN"] = f"{GRAALVM['HOME']}/bin"

    files.download(
        name=f"graalvm: Downloading GraalVM {GRAALVM['VERSION']}",
        src=f"https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{GRAALVM['VERSION']}/{GRAALVM['FILE']}",
        dest=f"{HOME}/tmp/{GRAALVM['FILE']}",
    )

    server.shell(
        name="graalvm: Untar GraalvM tar.gz file",
        commands=[
            f"/usr/bin/tar -zxvf /{HOME}/tmp/{GRAALVM['FILE']} -C {GRAALVM['DEST']}"
        ],
        sudo=True,
        use_sudo_password=True,
    )

    bashProfile.PATH.append(GRAALVM["BIN"])

    server.shell(
        name="graalvm: Install native image add-on",
        commands=[f"{GRAALVM['BIN']}/gu install native-image"],
        sudo=True,
        use_sudo_password=True,
    )


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

    installGraalVM("Fedora")

    installJava("Fedora")

if host.fact.os == "Darwin":
    brew.packages(name="Install Vim", packages=["vim"], update=True, upgrade=True)

    brew.packages(name="Install cURL", packages=["curl"])

    # Default macOS path
    bashProfile.PATH.append("/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin")

    installGraalVM("Darwin")

    javaEnv = Env("macOS specific java environment")

    # Java paths
    javaEnv.ENV["JAVA_8_HOME"] = "$(/usr/libexec/java_home -v1.8)"
    javaEnv.ENV["JAVA_11_HOME"] = "$(/usr/libexec/java_home -v11)"
    javaEnv.ENV["GRAALVM_HOME"] = GRAALVM["HOME"]

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
