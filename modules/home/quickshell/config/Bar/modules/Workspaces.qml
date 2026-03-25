import QtQuick
import Quickshell.Hyprland
import ".."
import "../.."

HexPanel {
    function toRoman(num) {
        const roman = ["", "I", "II", "III", "IV", "V"];
        return roman[num] || "";
    }

    Row {
        id: workspacesRow
        spacing: 15
        Repeater {
            model: 5
            delegate: Text {
                property int workspaceId: index + 1
                property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceId)
                property bool isActive: Hyprland.focusedWorkspace?.id === workspaceId
                
                text: toRoman(workspaceId)
                font.pixelSize: 18
                font.bold: true
                color: isActive ? Style.colOrange : (workspace ? Style.colYellow : Style.colWhite)

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + workspaceId)
                }
            }
        }
    }
}
