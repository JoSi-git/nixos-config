import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../../.."

Item {
    anchors.fill: parent

    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: sink ? [sink] : [] }

    property string rate:     "—"
    property string depth:    "—"
    property string channels: "—"
    property string latency:  "—"
    property string driver:   "—"

    property int _hz: 0

    onSinkChanged: if (!infoProc.running) infoProc.running = true

    Process {
        id: infoProc
        running: true
        command: ["bash", "-c",
            "wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -E 'audio\\.channels|node\\.max-latency|alsa\\.resolution_bits|alsa\\.driver_name'"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                _hz = 0
                for (var line of text.trim().split("\n")) {
                    var m = line.match(/"([^"]+)"/)
                    if (!m) continue
                    var val = m[1]
                    if      (line.includes("audio.channels"))      { var n = parseInt(val); channels = n === 1 ? "Mono" : n === 2 ? "Stereo" : n + "ch" }
                    else if (line.includes("node.max-latency"))    { _hz = parseInt(val.split("/")[1]); rate = Math.round(_hz / 1000) + " kHz" }
                    else if (line.includes("alsa.resolution_bits")){ depth  = val + " Bit" }
                    else if (line.includes("alsa.driver_name"))    { driver = val.replace(/^snd_/, "").replace(/_/g, " ").toUpperCase() }
                }
                if (!latencyProc.running) latencyProc.running = true
            }
        }
    }

    Process {
        id: latencyProc
        command: ["bash", "-c",
            "wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep 'api\\.alsa\\.period-size'"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                var m = text.match(/"([^"]+)"/)
                if (m && _hz > 0)
                    latency = (parseInt(m[1]) / _hz * 1000).toFixed(1) + " ms"
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!latencyProc.running) latencyProc.running = true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "DEVICE INFO"
                color: Style.colYellow
                font { pixelSize: 13; family: "Courier New"; bold: true; letterSpacing: 2 }
                Layout.alignment: Qt.AlignVCenter
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 5
            columnSpacing: 5

            Repeater {
                model: [
                    { icon: "", label: "RATE",   value: rate     },
                    { icon: "", label: "DEPTH",  value: depth    },
                    { icon: "", label: "CHANNELS", value: channels },
                    { icon: "", label: "LATENCY", value: latency  },
                ]
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Style.colBg03
                    radius: 7
                    border.color: Style.colHighlight
                    border.width: 1

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 3

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 4
                            Text {
                                text: modelData.icon
                                font { family: "Hack Nerd Font"; pixelSize: 12 }
                                color: Style.colBorder
                            }
                            Text {
                                text: modelData.label
                                color: Style.colBorder
                                opacity: 0.55
                                font { pixelSize: 8; letterSpacing: 1.3; weight: Font.Light }
                            }
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.value
                            color: Style.colWhite
                            opacity: 0.85
                            font { pixelSize: 13; weight: Font.Medium; letterSpacing: 0.5 }
                        }
                    }
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.colBg03
                radius: 7
                border.color: Style.colHighlight
                border.width: 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 3

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 4
                        Text {
                            text: "\uf013"
                            font { family: "Hack Nerd Font"; pixelSize: 12 }
                            color: Style.colBorder
                        }
                        Text {
                            text: "DRIVER"
                            color: Style.colBorder
                            opacity: 0.55
                            font { pixelSize: 8; letterSpacing: 1.3; weight: Font.Light }
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: driver
                        color: Style.colWhite
                        opacity: 0.85
                        font { pixelSize: 13; weight: Font.Medium; letterSpacing: 0.5 }
                    }
                }
            }
        }
    }
}
