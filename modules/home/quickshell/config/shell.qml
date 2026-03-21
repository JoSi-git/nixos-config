//@ pragma UseQApplication
import QtQuick
import Quickshell

ShellRoot {
    id: rootqs

    Instantiator {
        model: Quickshell.screens
        
        delegate: Loader {
            active: true
            source: "./Bar/Bar.qml"
            onLoaded: item.targetScreen = modelData
        }
    }
}
