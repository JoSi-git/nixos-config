import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."

PanelWindow {
    id: root
    visible: false
    anchors { top: true; right: true }
    implicitWidth: 420
    implicitHeight: col.implicitHeight + 32
    color: "transparent"
    margins { top: 8; right: 8 }

    property string title: ""
    property string body: ""
    property string appName: ""
    property string appId: ""

    function notify(summary, body, app, id) {
        root.title = summary
        root.body = body
        root.appName = app || "Notification"
        root.appId = id || ""
        root.visible = true
        timer.restart()
    }

    Timer {
        id: timer
        interval: 3000
        onTriggered: root.visible = false
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Style.colBg
        border.color: Style.colBorder
        border.width: 1

        MouseArea {
            anchors.fill: parent
            onClicked: {
                timer.stop()
                root.visible = false
            }
        }

        ColumnLayout {
            id: col
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 16
            }
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Item {
                    width: 20
                    height: 20

                    Image {
                        id: appIcon
                        anchors.fill: parent
                        source: Quickshell.iconPath(root.appId || root.appName.toLowerCase(), "")
                        sourceSize: Qt.size(20, 20)
                        visible: status === Image.Ready
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: appIcon.status !== Image.Ready
                        text: "\uf49a"
                        font.family: "Symbols Nerd Font Mono"
                        font.pixelSize: 18
                        color: Style.colAqua
                    }
                }

                Text {
                    text: root.appName.toUpperCase()
                    font { pixelSize: 16; bold: true }
                    color: Style.colYellow
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Style.colBorder02
            }

            Text {
                text: root.title
                font { bold: true; pixelSize: 16 }
                color: Style.colWhite
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: root.body
                color: Style.colBorder
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                bottomPadding: 4
            }
        }
    }
}
