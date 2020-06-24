from pyinfra.modules import dnf, brew, server
from pyinfra import host

# Install vim

if host.fact.linux_name == "Fedora":
    dnf.packages(
        {"Install latest Vim"}, ["vim"], latest=True,
    )

if host.fact.os == "Darwin":
    brew.packages(
        {"Install Vim"}, ["vim"], update=True,
    )
    # Install Syncthing
    brew.packages(
        {"Install Syncthing"}, ["syncthing"], update=True,
    )
    server.shell({"Start Syncthing service"}, "brew services start syncthing")
