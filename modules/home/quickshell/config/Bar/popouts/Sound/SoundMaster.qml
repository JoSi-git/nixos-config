import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../../components"
import "../../.."

Item {
    id: root
    anchors.fill: parent

    property bool speakerPlaying: false
    property bool micListening:   false
    property real micLevel:       0.0

    readonly property real speakerLevel: {
        var s = 0, lv = pipeViz.levels
        for (var i = 0; i < lv.length; i++) s += lv[i]
        return s / lv.length
    }

    Process {
        id: speakerTestProc
        command: ["bash", "-c",
            "pw-play" + (Pipewire.defaultAudioSink ? " --target " + Pipewire.defaultAudioSink.name : "") +
            " ${HOME}/.config/quickshell/Bar/assets/klugheim_01.mp3"]
        onRunningChanged: if (!running) root.speakerPlaying = false
    }

    Process {
        id: micLevelProc
        command: ["bash", "-c",
            "cfg=$(mktemp --suffix=.ini) && " +
            "printf '[general]\\nbars=1\\nframerate=30\\n\\n[input]\\nmethod=pipewire\\nsource=" +
            (Pipewire.defaultAudioSource ? Pipewire.defaultAudioSource.name : "auto") +
            "\\n\\n[output]\\nmethod=raw\\nraw_target=/dev/stdout\\ndata_format=ascii\\nascii_max_range=100\\nchannels=mono\\n' > \"$cfg\" && " +
            "cava -p \"$cfg\"; rm -f \"$cfg\""]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                var v = parseInt(line.trim().split(";")[0])
                if (!isNaN(v)) root.micLevel = Math.min(1, v / 100)
            }
        }
        onRunningChanged: if (!running) { root.micListening = false; root.micLevel = 0 }
    }

    function toggleSpeaker() {
        if (root.speakerPlaying) { speakerTestProc.running = false; return }
        speakerTestProc.running = true
        root.speakerPlaying = true
    }

    function toggleMic() {
        if (root.micListening) { micLevelProc.running = false; return }
        micLevelProc.running = true
        root.micListening = true
    }

    Image {
        anchors.centerIn: parent
        source: "../../assets/pipe_organ_themed.svg"
        width: Math.min(parent.width, parent.height) * 0.82
        height: width
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(512, 512)
        smooth: true
        SoundPipeVisualizer { id: pipeViz }
    }

    Column {
        anchors { left: parent.left; bottom: parent.bottom; margins: 8 }
        spacing: 5

        LevelBars {
            anchors.horizontalCenter: parent.horizontalCenter
            level:    root.micLevel
            barColor: Style.colBlue
            active:   root.micListening
        }
        HexActionBtn {
            anchors.horizontalCenter: parent.horizontalCenter
            icon:        root.micListening ? "󰓛" : "󱂬"
            label:       root.micListening ? "STOP" : "LISTEN"
            accentColor: root.micListening ? Style.colBlue : Style.colYellow
            active:      root.micListening
            onClicked:   root.toggleMic()
        }
    }

    Column {
        anchors { right: parent.right; bottom: parent.bottom; margins: 8 }
        spacing: 5

        LevelBars {
            anchors.horizontalCenter: parent.horizontalCenter
            level:    root.speakerLevel
            barColor: Style.colGreen
            active:   root.speakerPlaying
        }
        HexActionBtn {
            anchors.horizontalCenter: parent.horizontalCenter
            icon:        root.speakerPlaying ? "󰓛" : "󰕾"
            label:       root.speakerPlaying ? "STOP" : "TEST"
            accentColor: root.speakerPlaying ? Style.colGreen : Style.colYellow
            active:      root.speakerPlaying
            onClicked:   root.toggleSpeaker()
        }
    }

    component LevelBars: Item {
        id: lvl
        property real  level:    0.0
        property color barColor: Style.colYellow
        property bool  active:   false

        width: 27; height: 36
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Repeater {
            model: [{ w: 0.65, lag: 55 },
                    { w: 1.0,  lag: 40 },
                    { w: 0.82, lag: 65 },
                    { w: 1.0,  lag: 45 },
                    { w: 0.65, lag: 55 }]
            delegate: Rectangle {
                required property var modelData
                required property int index
                x: index * 6; width: 3; radius: 1.5
                color: lvl.barColor
                anchors.bottom: parent.bottom
                property real targetH: Math.max(3, lvl.level * modelData.w * 36)
                height: targetH
                Behavior on height { NumberAnimation { duration: modelData.lag; easing.type: Easing.OutQuad } }
            }
        }
    }

    component HexActionBtn: Item {
        id: btn
        property string icon:        ""
        property string label:       ""
        property color  accentColor: Style.colYellow
        property bool   active:      false
        signal clicked()

        width: 64; height: 56

        property real breathScale: 1.0
        scale: breathScale
        SequentialAnimation on breathScale {
            running: btn.active
            loops:   Animation.Infinite
            NumberAnimation { to: 1.07; duration: 700; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0;  duration: 700; easing.type: Easing.InOutSine }
            onStopped: btn.breathScale = 1.0
        }

        HoverHandler { id: btnHover }
        TapHandler   { onTapped: btn.clicked() }

        HexShape {
            anchors.fill: parent
            filled:      true
            fillColor:   btnHover.hovered
                         ? Qt.darker(btn.accentColor, 1.6)
                         : (btn.active ? Qt.darker(btn.accentColor, 2.2) : "transparent")
            strokeColor: btn.accentColor
            strokeWidth: 1.5
            padding:     2
            Behavior on fillColor { ColorAnimation { duration: 120 } }
        }

        Column {
            anchors.centerIn: parent
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: btn.icon
                font { family: "Symbols Nerd Font Mono"; pixelSize: 15 }
                color: btnHover.hovered ? Style.colWhite : btn.accentColor
                Behavior on color { ColorAnimation { duration: 120 } }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: btn.label
                font { pixelSize: 9; family: "Courier New"; letterSpacing: 1 }
                color: btnHover.hovered ? Style.colWhite : btn.accentColor
                opacity: 0.85
            }
        }
    }
}
