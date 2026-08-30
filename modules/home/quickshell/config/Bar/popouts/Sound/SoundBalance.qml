import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../../.."

Item {
    id: root
    anchors.fill: parent

    function friendlyName(node) {
        var n = node.description || node.name || ""
        if (n.includes("WEBRTC")) return "Discord"
        return n || "Unknown"
    }

    function appIconName(node) {
        var hint = node.properties ? node.properties["application.icon-name"] : ""
        if (hint) return hint
        var n = (node.description || node.name || "").toLowerCase()
        if (n.includes("firefox"))                         return "firefox"
        if (n.includes("webrtc") || n.includes("discord")) return "discord"
        if (n.includes("spotify"))                         return "spotify-client"
        if (n.includes("chromium"))                        return "chromium"
        if (n.includes("chrome"))                          return "google-chrome"
        if (n.includes("vlc"))                             return "vlc"
        if (n.includes("steam"))                           return "steam"
        return ""
    }

    readonly property var streamList: {
        var r = []
        for (var node of (Pipewire.nodes.values ?? []))
            if (node.isStream && node.isSink && node.audio !== null)
                r.push(node)
        return r
    }

    readonly property var streamGroups: {
        var groups = {}, order = []
        for (var node of root.streamList) {
            var key = root.friendlyName(node)
            if (!groups[key]) {
                groups[key] = { name: key, iconName: root.appIconName(node), nodes: [] }
                order.push(key)
            }
            groups[key].nodes.push(node)
        }
        return order.map(function(k) { return groups[k] })
    }

    PwObjectTracker { objects: root.streamList }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        Text {
            text: "MIXER"
            color: Style.colYellow
            font { pixelSize: 13; family: "Courier New"; bold: true; letterSpacing: 2 }
        }

        Repeater {
            model: 4

            delegate: Item {
                id: slot
                Layout.fillWidth: true
                Layout.fillHeight: true

                required property int index

                readonly property var  group:       index < root.streamGroups.length ? root.streamGroups[index] : null
                readonly property bool active:      group !== null
                readonly property real groupVolume: {
                    if (!active) return 0
                    var total = 0
                    for (var n of group.nodes) total += n.audio.volume
                    return total / group.nodes.length
                }

                function setVolume(vol) {
                    if (!active) return
                    for (var n of group.nodes) n.audio.volume = Math.max(0, Math.min(1, vol))
                }

                opacity: active ? 1 : 0.35
                Behavior on opacity { NumberAnimation { duration: 200 } }

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    Item {
                        width: 16; height: 16
                        Layout.alignment: Qt.AlignVCenter

                        Image {
                            id: appIcon
                            anchors.fill: parent
                            source: (slot.active && slot.group.iconName) ? "image://icon/" + slot.group.iconName : ""
                            sourceSize: Qt.size(16, 16)
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            visible: status === Image.Ready
                        }

                        Text {
                            anchors.centerIn: parent
                            visible: !appIcon.visible
                            text: slot.active ? "" : "󰝟"
                            font { family: "Symbols Nerd Font Mono"; pixelSize: 13 }
                            color: Style.colBorder
                        }
                    }

                    Text {
                        Layout.preferredWidth: 95
                        text: slot.active ? slot.group.name : "Not Active"
                        color: Style.colWhite
                        opacity: slot.active ? 0.85 : 0.5
                        font { pixelSize: 11; weight: Font.Medium }
                        elide: Text.ElideRight
                    }

                    Item {
                        Layout.fillWidth: true
                        height: 14

                        Rectangle {
                            anchors.fill: parent
                            radius: 4
                            color: Style.colBg03
                            border.color: Style.colHighlight
                            border.width: 1
                        }

                        Rectangle {
                            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                            width: Math.max(0, Math.min(1, slot.groupVolume)) * parent.width
                            radius: 4
                            color: Style.colYellow
                            opacity: 0.85
                            Behavior on width { NumberAnimation { duration: 80 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: slot.active
                            preventStealing: true
                            onPositionChanged: function(mouse) {
                                if (pressed) slot.setVolume(mouse.x / width)
                            }
                            onWheel: function(wheel) {
                                slot.setVolume(slot.groupVolume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
                            }
                        }
                    }

                    Text {
                        Layout.preferredWidth: 34
                        text: slot.active ? Math.round(slot.groupVolume * 100) + "%" : "0%"
                        color: Style.colWhite
                        opacity: 0.7
                        font { pixelSize: 11; family: "Courier New" }
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }
}
