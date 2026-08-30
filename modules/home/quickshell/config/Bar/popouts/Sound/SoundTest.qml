import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../components"
import "../../.."

Item {
    id: root
    anchors.fill: parent

    property int  batteryLevel: -1
    property bool hasLights:   false
    property bool hasBattery:  false
    property bool lightsOn:    false
    property bool refreshing:  false

    Process {
        id: infoProc
        running: true
        command: ["headsetcontrol", "-o", "json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(text)
                    var dev = data.devices ? data.devices[0] : null
                    if (dev && dev.status === "success") {
                        var caps = dev.capabilities_str ?? []
                        root.hasLights   = caps.includes("lights")
                        root.hasBattery  = caps.includes("battery")
                        if (root.hasBattery && dev.battery && typeof dev.battery.level === "number")
                            root.batteryLevel = dev.battery.level
                        else
                            root.batteryLevel = -1
                    } else {
                        root.deviceName = "No device"
                    }
                } catch(e) {
                    root.deviceName = "No device"
                }
                root.refreshing = false
            }
        }
    }

    Process {
        id: lightsProc
        command: ["headsetcontrol", "-l", root.lightsOn ? "0" : "1"]
        onRunningChanged: if (!running) root.lightsOn = !root.lightsOn
    }

    Timer {
        id: retryTimer
        interval: 30000
        running: root.batteryLevel < 0 && !root.refreshing
        repeat: true
        onTriggered: root.refresh()
    }

    function refresh() {
        if (root.refreshing) return
        root.refreshing = true
        infoProc.running = false
        infoProc.running = true
    }

    function toggleLights() {
        if (lightsProc.running || !root.hasLights) return
        lightsProc.running = true
    }

    function batteryIcon(level) {
        if (level < 0)  return ""
        if (level < 10) return ""
        if (level < 25) return ""
        if (level < 50) return ""
        if (level < 75) return ""
        if (level < 90) return ""
        return ""
    }

    function batteryColor(level) {
        if (level < 0)  return Style.colBorder
        if (level < 20) return Style.colRed
        if (level < 40) return Style.colOrange
        return Style.colGreen
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 0

        Text {
            text: "HEADSET"
            color: Style.colYellow
            font { pixelSize: 13; family: "Courier New"; bold: true; letterSpacing: 2 }
        }

        Item { Layout.preferredHeight: 18 }

        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 14

            HexActionBtn {
                icon:        root.batteryIcon(root.batteryLevel)
                label:       root.hasBattery && root.batteryLevel >= 0 ? root.batteryLevel + "%" : "—"
                accentColor: root.batteryColor(root.batteryLevel)
                interactive: root.batteryLevel < 0
                onClicked:   root.refresh()
            }

            HexActionBtn {
                icon:        ""
                label:       root.lightsOn ? "ON" : "OFF"
                accentColor: root.lightsOn ? Style.colYellow : Style.colBorder
                active:      root.lightsOn
                enabled:     root.hasLights
                onClicked:   root.toggleLights()
            }
        }

        Item { Layout.fillHeight: true }
    }

    component HexActionBtn: Item {
        id: btn
        property string icon:        ""
        property string label:       ""
        property color  accentColor: Style.colYellow
        property bool   active:      false
        property bool   interactive: true
        signal clicked()

        width: 72; height: 62

        HoverHandler { id: btnHover; enabled: btn.interactive }
        TapHandler   { enabled: btn.interactive; onTapped: if (btn.enabled) btn.clicked() }

        HexShape {
            anchors.fill: parent
            filled:      true
            fillColor:   (btn.interactive && btnHover.hovered)
                         ? Qt.darker(btn.accentColor, 1.6)
                         : (btn.active ? Qt.darker(btn.accentColor, 2.2) : "transparent")
            strokeColor: btn.accentColor
            strokeWidth: 1.5
            padding:     2
            opacity:     btn.enabled ? 1.0 : 0.3
            Behavior on fillColor   { ColorAnimation { duration: 120 } }
            Behavior on strokeColor { ColorAnimation { duration: 150 } }
        }

        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: btn.icon
                font { family: "Hack Nerd Font"; pixelSize: 18 }
                color: btnHover.hovered ? Style.colWhite : btn.accentColor
                opacity: btn.enabled ? 1.0 : 0.3
                Behavior on color { ColorAnimation { duration: 120 } }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: btn.label
                font { pixelSize: 9; family: "Courier New"; letterSpacing: 1 }
                color: btnHover.hovered ? Style.colWhite : btn.accentColor
                opacity: btn.enabled ? 0.85 : 0.3
                Behavior on color { ColorAnimation { duration: 120 } }
            }
        }
    }
}
