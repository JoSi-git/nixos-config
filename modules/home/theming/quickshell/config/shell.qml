//@ pragma UseQApplication
import QtQuick
import Quickshell

ShellRoot {
    id: root
    Loader {
        active: true
        source: "./modules/bar/Bar.qml"
    }
}
