import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../.."

PanelWindow {
    id: root
    visible: false
    anchors { top: true; right: true }
    implicitWidth: 515
    readonly property int overlap: 34
    implicitHeight: fanfareClip.height + cardRect.height - overlap
    color: "transparent"
    margins { top: 8; right: -112 }

    property string title: ""
    property string body: ""
    property string appName: ""
    property string appId: ""

    property real contentSlideX: 120
    property real contentRotation: 10
    property real contentOpacity: 0

    function notify(summary, body, app, id) {
        root.title   = summary
        root.body    = body
        root.appName = app || "Notification"
        root.appId   = id  || ""
        root.contentSlideX   = 120
        root.contentRotation = 10
        root.visible = true
        hideAnim.stop()
        showAnim.restart()
        timer.restart()
        fanfareSound.running = false
        fanfareSound.running = true
    }

    Timer {
        id: timer
        interval: 5000
        onTriggered: hideAnim.start()
    }

    Process {
        id: fanfareSound
        command: ["pw-play", "--volume=0.1", Qt.resolvedUrl("../assets/fanfare.wav").toString().replace("file://", "")]
    }

    ParallelAnimation {
        id: showAnim
        NumberAnimation {
            target: root; property: "contentSlideX"
            from: 120; to: 0
            duration: 580
            easing.type: Easing.OutBack; easing.overshoot: 1.3
        }
        NumberAnimation {
            target: root; property: "contentRotation"
            from: 10; to: 0
            duration: 580
            easing.type: Easing.OutBack; easing.overshoot: 0.9
        }
        NumberAnimation {
            target: root; property: "contentOpacity"
            from: 0; to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    SequentialAnimation {
        id: hideAnim
        ParallelAnimation {
            NumberAnimation {
                target: root; property: "contentOpacity"
                to: 0; duration: 240
                easing.type: Easing.InQuart
            }
            NumberAnimation {
                target: root; property: "contentSlideX"
                to: 100; duration: 240
                easing.type: Easing.InBack; easing.overshoot: 1.5
            }
            NumberAnimation {
                target: root; property: "contentRotation"
                to: 6; duration: 240
                easing.type: Easing.InCubic
            }
        }
        ScriptAction { script: root.visible = false }
    }

    Item {
        id: content
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        width: 395
        opacity: root.contentOpacity
        transform: [
            Translate { x: root.contentSlideX },
            Rotation { angle: root.contentRotation; origin.x: 197 }
        ]

        Item {
            id: fanfareClip
            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
            width: 360
            height: Math.round(width * 208 / 680)
            clip: true
            z: 1

            Image {
                width:  parent.width
                height: Math.round(parent.width * 300 / 680)
                source: "../assets/fanfare.svg"
                mirror: true
                sourceSize: Qt.size(width, height)
            }
        }

        component BandPair: Item {
            property bool mirrored: false
            width: 18; height: 50
            z: 2
            Rectangle {
                width: 9; height: 50
                topLeftRadius: 3
                color: mirrored ? "#1b4fa0" : "#f4f4f4"
            }
            Rectangle {
                x: 9; width: 9; height: 50
                topRightRadius: 3
                color: mirrored ? "#f4f4f4" : "#1b4fa0"
            }
            Canvas {
                property string cL: mirrored ? "#1b4fa0" : "#f4f4f4"
                property string cR: mirrored ? "#f4f4f4" : "#1b4fa0"
                anchors.top: parent.bottom
                width: parent.width
                height: 14
                Component.onCompleted: requestPaint()
                onCLChanged: requestPaint()
                onPaint: {
                    var ctx = getContext("2d")
                    var w = width, h = height
                    ctx.clearRect(0, 0, w, h)
                    ctx.beginPath()
                    ctx.moveTo(0, 0); ctx.lineTo(w / 2, h); ctx.lineTo(w / 2, 0)
                    ctx.closePath(); ctx.fillStyle = cL; ctx.fill()
                    ctx.beginPath()
                    ctx.moveTo(w / 2, 0); ctx.lineTo(w / 2, h); ctx.lineTo(w, 0)
                    ctx.closePath(); ctx.fillStyle = cR; ctx.fill()
                }
            }
        }

        BandPair {             x: 75;            y: fanfareClip.height - overlap - 46 }
        BandPair { mirrored: true; x: 395 - 60 - 18; y: fanfareClip.height - overlap - 46 }

        Rectangle {
            id: cardRect
            anchors { top: fanfareClip.bottom; topMargin: -overlap; left: parent.left; right: parent.right }
            height: col.implicitHeight + 44
            radius: 8
            color: Style.colBg
            border.color: Style.colWhite
            border.width: 1

            TapHandler {
                onTapped: { timer.stop(); hideAnim.start() }
            }

            ColumnLayout {
                id: col
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Item {
                        width: 20; height: 20

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
                            text: ""
                            font { family: "Symbols Nerd Font Mono"; pixelSize: 18 }
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
}
