//@ pragma UseQApplication
import QtQuick
import Quickshell

ShellRoot {
    id: root

    Instantiator {
        model: Quickshell.screens
        
        delegate: Loader {
            active: true
            source: "./bar/bar.qml"
            onLoaded: item.screen = modelData
        }
    }
}
