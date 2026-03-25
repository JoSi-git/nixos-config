import QtQuick
import ".."
import "../.."

Item {
    id: headerRoot
    height: 45
    width: parent.width
    
    property string activeTab: ""
    signal tabClicked(string name)

    Row {
        anchors.centerIn: parent
        spacing: 20

        Repeater {
            model: [
                { name: "Dashboard", icon: "\uf0e4" },
                { name: "Sound", icon: "\uf028" },
                { name: "Network", icon: "\uf1eb" },
                { name: "Performance", icon: "\uf2db" }
            ]
            
            HexPanel {
                id: badge
                height: 36
                
                bgColor: activeTab === modelData.name ? Style.colHighlight : Style.colBg02
                borderColor: activeTab === modelData.name ? Style.colHighlight : Style.colBorder02
                
                onClicked: headerRoot.tabClicked(modelData.name)

                Row {
                    anchors.centerIn: parent
                    spacing: 5
                    leftPadding: 10
                    rightPadding: 10

                    Text {
                        text: modelData.icon
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 18
                        color: activeTab === modelData.name ? Style.colWhite : Style.colWhite
                        opacity: activeTab === modelData.name ? 1.0 : 0.6
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: modelData.name
                        color: Style.colWhite
                        font.pixelSize: 16
                        font.bold: true
                        opacity: activeTab === modelData.name ? 1.0 : 0.6
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
