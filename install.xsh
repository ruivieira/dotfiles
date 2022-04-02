#!/usr/bin/env xonsh
from abc import ABC, abstractmethod

# Install robby xontrib
xpip install ~/Sync/code/robby/robby -U --force

OS=$(uname -s).strip()

class Item(ABC):
    def install(self):
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
    @abstractmethod
    def installed() -> bool:
        pass


# todoist CLI
class Todoist(Item):
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
    def installed(self):
        return False

items = [XonshRc(), Todoist()]

for item in items:
    
    if not item.installed():
        print_color("[🐚] {GREEN}Installing " + item._info() + "{RESET}")
        item.install()
    else:
        print_color("[🐚] {YELLOW}" + item._info() + " already installed{RESET}")