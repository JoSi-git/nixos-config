import QtQuick
import "modules"
import "components"
import ".."

Rectangle {
    id: barContentRoot
    color: "transparent"
    anchors.fill: parent

    Row {
        id: leftSide
        spacing: 5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10

        HexPanel {
            Text {
                text: "\uf313"
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 20
                color: Style.colWhite
            }
        }
    
        Workspaces {}
        Tray {}
    }

    Clock {
        anchors.centerIn: parent
    }

    Row {
        id: rightSide
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10
        spacing: 5

        Privacy {}
        Battery {}
        Volume {}
        Connectivity {}
        Power {}
    }
}
