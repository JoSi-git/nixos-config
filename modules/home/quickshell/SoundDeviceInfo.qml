import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../../.."

Item {
    id: root
    anchors.fill: parent

    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: sink ? [sink] : [] }

    property string rate:     "—"
    property string depth:    "—"
    property string channels: "—"
    property string latency:  "—"
    property string driver:   "—"

    onSinkChanged: {
        rate = "—"; depth = "—"; channels = "—"; latency = "—"; driver = "—"
        infoProc.running = false
        infoProc.running = true
    }

    Process {
        id: infoProc
        running: true
        command: ["bash", "-c",
            "wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -E 'audio\\.channels|node\\.max-latency|alsa\\.resolution_bits|alsa\\.driver_name|api\\.alsa\\.period-size'"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                var hz = 0, period = 0
                root.rate = "—"; root.depth = "—"; root.channels = "—"; root.latency = "—"; root.driver = "—"
                for (var line of text.trim().split("\n")) {
                    var m = line.match(/"([^"]+)"/)
                    if (!m) continue
                    var val = m[1]
                    if      (line.includes("audio.channels"))       { var n = parseInt(val); root.channels = n === 1 ? "Mono" : n === 2 ? "Stereo" : n + "ch" }
                    else if (line.includes("node.max-latency"))     { hz = parseInt(val.split("/")[1]); root.rate = Math.round(hz / 1000) + " kHz" }
                    else if (line.includes("alsa.resolution_bits")) { root.depth  = val + " Bit" }
                    else if (line.includes("alsa.driver_name"))     { root.driver = val.replace(/^snd_/, "").replace(/_/g, " ").toUpperCase() }
                    else if (line.includes("api.alsa.period-size")) { period = parseInt(val) }
                }
                if (hz > 0 && period > 0)
                    root.latency = (period / hz * 1000).toFixed(1) + " ms"
            }
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: { infoProc.running = false; infoProc.running = true }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Text {
            text: "DEVICE INFO"
            color: Style.colYellow
            font { pixelSize: 13; family: "Courier New"; bold: true; letterSpacing: 2 }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 5
            columnSpacing: 5

            Repeater {
                model: [
                    { label: "RATE",     value: rate     },
                    { label: "DEPTH",    value: depth    },
                    { label: "CHANNELS", value: channels },
                    { label: "DRIVER",   value: driver   },
                ]
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Style.colBg03
                    radius: 7
                    border.color: Style.colHighlight
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 3
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.label
                            color: Style.colBorder
                            opacity: 0.55
                            font { pixelSize: 8; letterSpacing: 1.3; weight: Font.Light }
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
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

                Column {
                    anchors.centerIn: parent
                    spacing: 3
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "LATENCY"
                        color: Style.colBorder
                        opacity: 0.55
                        font { pixelSize: 8; letterSpacing: 1.3; weight: Font.Light }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: latency
                        color: Style.colWhite
                        opacity: 0.85
                        font { pixelSize: 13; weight: Font.Medium; letterSpacing: 0.5 }
                    }
                }
            }
        }
    }
}
