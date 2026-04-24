import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../components"
import "../.."

HexPanel {
    visible: trayRepeater.count > 0
    Row {
        id: trayModule
        spacing: 8
        Repeater {
            id: trayRepeater
            model: SystemTray.items
            delegate: MouseArea {
                width: 20
                height: 20
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                
                Image {
                    anchors.fill: parent
                    source: modelData.icon
                    fillMode: Image.PreserveAspectFit
                }

                onClicked: (mouse) => {
                    if (mouse.button === Qt.RightButton) {
                        if (modelData.hasMenu || modelData.onlyMenu) {
                            var globalPos = parent.mapToItem(qsbar.contentItem, 0, 0)
                            modelData.display(
                                qsbar,
                                globalPos.x,
                                globalPos.y + parent.height + 4
                            )
                        }
                    }
                }
            }
        }
    }
}
