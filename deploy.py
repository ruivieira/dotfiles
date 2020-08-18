from pyinfra import host
from pathlib import Path
from pyinfra.operations import files, dnf, brew, server

HOME = str(Path.home())


class BashProfile:
    def __init__(self):
        self.PATH = []


bashProfile = BashProfile()

# Install vim

if host.fact.linux_name == "Fedora":
    dnf.packages(
        name="Install latest Vim", packages=["vim"], latest=True,
    )

if host.fact.os == "Darwin":
    brew.packages(name="Install Vim", packages=["vim"], update=True, upgrade=True)

    # Install GraalVM
    GRAALVM_VERSION = "20.1.0"
    GRAALVM_FILE = f"graalvm-ce-java11-darwin-amd64-{GRAALVM_VERSION}.tar.gz"
    files.download(
        name=f"graalvm: Downloading GraalVM {GRAALVM_VERSION}",
        src=f"https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{GRAALVM_VERSION}/{GRAALVM_FILE}",
        dest=f"{HOME}/tmp/{GRAALVM_FILE}",
    )

    server.shell(
        name="graalvm: Untar GraalvM tar.gz file",
        commands=[
            f"/usr/bin/tar -zxvf /{HOME}/tmp/{GRAALVM_FILE} -C /Library/Java/JavaVirtualMachines/"
        ],
    )

    bashProfile.PATH.append(
        f"/Library/Java/JavaVirtualMachines/graalvm-ce-java11-{GRAALVM_VERSION}/Contents/Home/bin"
    )

# export .bash_profile
files.template(
    name="Create a templated file",
    src="templates/.bash_profile.j2",
    dest=f"{HOME}/.bash_profile",
    PATH=":".join(bashProfile.PATH),
)
