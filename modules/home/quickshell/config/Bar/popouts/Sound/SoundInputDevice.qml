import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../../components"
import "../../.."

Item {
    id: root
    anchors.fill: parent

    readonly property var defaultSource: Pipewire.defaultAudioSource
    property int selectedIndex: 0

    readonly property var sourceList: {
        var result = []
        for (var node of (Pipewire.nodes.values ?? [])) {
            if (!node.isSink && !node.isStream &&
                (node.name.startsWith("alsa_input.") || node.name.startsWith("bluez_input.")))
                result.push(node)
        }
        return result
    }

    readonly property var sel: sourceList.length > 0 ? sourceList[selectedIndex] : null
    property bool isActive: false

    readonly property string micIcon: {
        if (!sel) return ""
        var n = (sel.name + " " + sel.description).toLowerCase()
        if (n.includes("headset") || n.includes("headphone")) return ""
        return ""
    }

    PwObjectTracker { id: nodeTracker; objects: [] }

    onSelChanged: {
        nodeTracker.objects = root.sel ? [root.sel] : []
        isActive = sel !== null && defaultSource !== null && sel.id === defaultSource.id
    }
    onDefaultSourceChanged: {
        var idx = sourceList.findIndex(function(s) { return s.id === (defaultSource ? defaultSource.id : 0) })
        if (idx >= 0) selectedIndex = idx
        isActive = sel !== null && defaultSource !== null && sel.id === defaultSource.id
    }

    function cycleSource(dir) {
        if (sourceList.length <= 1) return
        selectedIndex = ((selectedIndex + dir) + sourceList.length) % sourceList.length
    }

    component HexNavBtn: Item {
        id: btn
        property string label: "›"
        signal clicked()
        width: 30; height: 26
        HoverHandler { id: btnHover }
        TapHandler   { onTapped: btn.clicked() }
        HexShape {
            anchors.fill: parent
            filled:      true
            fillColor:   btnHover.hovered ? Qt.darker(Style.colYellow, 1.4) : "transparent"
            strokeColor: Style.colYellow
            strokeWidth: 1.5
            padding:     2
            Behavior on fillColor { ColorAnimation { duration: 120 } }
        }
        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            text: btn.label
            color: btnHover.hovered ? Style.colWhite : Style.colYellow
            font { pixelSize: 20; family: "Courier New"; bold: true }
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            HexNavBtn { label: "‹"; onClicked: root.cycleSource(-1) }
            Item { Layout.fillWidth: true }
            Text {
                text: "INPUT"
                color: Style.colYellow
                font { pixelSize: 13; family: "Courier New"; bold: true; letterSpacing: 2 }
            }
            Item { Layout.fillWidth: true }
            HexNavBtn { label: "›"; onClicked: root.cycleSource(1) }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            ColumnLayout {
                Layout.fillHeight: true
                spacing: 4
                opacity: root.isActive ? 1.0 : 0.35
                Behavior on opacity { NumberAnimation { duration: 150 } }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 38
                    horizontalAlignment: Text.AlignHCenter
                    text: sel ? Math.round(sel.audio.volume * 100) + "%" : "—"
                    color: Style.colWhite
                    opacity: 0.85
                    font { pixelSize: 11; weight: Font.Medium; family: "Courier New" }
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    width: 22
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: Style.colBg03
                        border.color: Style.colHighlight
                        border.width: 1
                    }
                    Rectangle {
                        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
                        height: sel ? Math.max(0, Math.min(1, sel.audio.volume)) * parent.height : 0
                        radius: 6
                        color: Style.colYellow
                        opacity: 0.85
                        Behavior on height { NumberAnimation { duration: 80 } }
                    }
                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                        onPositionChanged: function(mouse) {
                            if (!pressed || !sel) return
                            sel.audio.volume = Math.max(0, Math.min(1, 1.0 - mouse.y / height))
                        }
                        onWheel: function(wheel) {
                            if (!sel) return
                            sel.audio.volume = Math.max(0, Math.min(1, sel.audio.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)))
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "GAIN"
                    color: Style.colBorder
                    opacity: 0.55
                    font { pixelSize: 8; letterSpacing: 1.3; weight: Font.Light }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6

                Item { Layout.fillHeight: true }

                Item {
                    width: 58; height: 58
                    Layout.alignment: Qt.AlignHCenter
                    HexShape {
                        anchors.fill: parent
                        filled:      true
                        fillColor:   Style.colBg03
                        strokeColor: root.isActive ? Style.colYellow : Style.colBorder
                        strokeWidth: 1.8
                        padding:     2
                        Behavior on strokeColor { ColorAnimation { duration: 150 } }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: root.micIcon
                        font { family: "Symbols Nerd Font Mono"; pixelSize: 22 }
                        color: root.isActive ? Style.colYellow : Style.colBorder
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    text: sel && sel.description ? sel.description : "—"
                    color: root.isActive ? Style.colWhite : Style.colBorder
                    opacity: root.isActive ? 0.9 : 0.55
                    font { pixelSize: 13; weight: Font.Medium }
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Behavior on color   { ColorAnimation  { duration: 150 } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "PipeWire"
                    color: Style.colBlue
                    opacity: root.isActive ? 0.7 : 0.3
                    font { pixelSize: 10; letterSpacing: 1.2 }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 72; height: 22
                    radius: 4
                    color: "transparent"
                    border.color: root.isActive ? Style.colGreen : Style.colYellow
                    border.width: 1

                    HoverHandler { id: activateHover }
                    TapHandler {
                        enabled: !root.isActive
                        onTapped: Pipewire.preferredDefaultAudioSource = root.sel
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: activateHover.hovered && !root.isActive
                               ? Qt.rgba(Style.colYellow.r, Style.colYellow.g, Style.colYellow.b, 0.15)
                               : "transparent"
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.isActive ? "ACTIVE" : "ACTIVATE"
                        color: root.isActive ? Style.colGreen : Style.colYellow
                        font { pixelSize: 8; letterSpacing: 1.5; weight: Font.Bold }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                Item { Layout.fillHeight: true }
            }

            Item {
                Layout.preferredWidth: 38
                Layout.fillHeight: true
            }
        }
    }
}
