import QtQuick
import Quickshell
import ".."
import "../.."

HexPanel {
    Row {
        id: statusIcons
        spacing: 10

        Text {
            id: wifiIcon
            text: "󰤨"
            font.family: "Symbols Nerd Font Mono"
            font.pixelSize: 17
            color: Style.colBlue

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onPressed: {
                    if (mouse.button === Qt.RightButton) {
                        Quickshell.execDetached("iwgtk");
                    }
                }
            }
        }

        Text {
            id: bluetoothIcon
            text: "󰂯"
            font.family: "Symbols Nerd Font Mono"
            font.pixelSize: 17
            color: Style.colBlue
                            
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onPressed: {
                    if (mouse.button === Qt.RightButton) {
                        Quickshell.execDetached("blueman-manager");
                    }
                }
            }
        }
    }
}
