import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "."

Variants {
    model: Quickshell.screens

    PanelWindow {
        property var modelData
        screen: modelData
        anchors {
            right: true
            bottom: true
        }

        margins {
            right: 50
            bottom: 50
        }

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        color: "transparent"

        mask: Region {}

        WlrLayershell.layer: WlrLayer.Overlay

        ColumnLayout {
            id: content
            opacity: EasterEggState.activateLinux ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }

            Text {
                text: "Activate Linux"
                color: "#50ffffff"
                font.pointSize: 21
                font.weight: Font.Light
                font.letterSpacing: 0.3
            }

            Text {
                text: "Go to Settings to activate Linux"
                color: "#50ffffff"
                font.pointSize: 11
            }
        }
    }
}
