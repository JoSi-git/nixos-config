import QtQuick
import "../components"
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
                { name: "Dashboard",   icon: "\uf0e4" },
                { name: "Sound",       icon: "\uf028" },
                { name: "Network",     icon: "\uf1eb" },
                { name: "Performance", icon: "\uf2db" }
            ]
            Item {
                width: 200
                height: 36
                readonly property bool isActive: activeTab === modelData.name
                HexPanel {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 36
                    bgColor:     isActive ? Style.colHighlight : Style.colBg02
                    borderColor: isActive ? Style.colHighlight : Style.colBorder02
                    onClicked: headerRoot.tabClicked(modelData.name)
                    Row {
                        spacing: 5
                        Text {
                            text: modelData.icon
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 18
                            color: Style.colWhite
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

                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: isActive ? Qt.darker(Style.colHighlight, 1.8) : Style.colRivetShadow
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 1
                    x: 16
                }
                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: isActive ? Qt.lighter(Style.colHighlight, 1.1) : Style.colRivet
                    anchors.verticalCenter: parent.verticalCenter
                    x: 14
                }
                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: isActive ? Qt.darker(Style.colHighlight, 1.8) : Style.colRivetShadow
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 1
                    x: parent.width - 22
                }
                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: isActive ? Qt.lighter(Style.colHighlight, 1.1) : Style.colRivet
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width - 24
                }
            }
        }
    }
}
