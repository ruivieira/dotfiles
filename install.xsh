#!/usr/bin/env xonsh
from abc import ABC, abstractmethod

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
    


# todoist CLI
class Todoist(Item):
    def _darwin(self):
        brew tap sachaos/todoist
        brew install todoist
    def _linux(self):
        pass


items = [Todoist()]

for item in items:
    item.install()