import QtQuick
import Quickshell
import ".."
import "../.."

HexPanel {
    Text {
        id: powerIcon
        text: "\uf011"
        font.family: "Symbols Nerd Font Mono"
        font.pixelSize: 17
        color: Style.colWhite
    
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onPressed: {
                if (mouse.button === Qt.LeftButton) {
                    Quickshell.execDetached(["wlogout", "-b", "4"]);
                }
            }
        }
    }
}
