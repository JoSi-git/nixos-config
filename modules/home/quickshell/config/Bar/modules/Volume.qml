import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import ".."
import "../.."

HexPanel {
    MouseArea {
        id: volumeModule
        width: volumeContent.width
        height: 20
        anchors.verticalCenter: parent.verticalCenter
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        readonly property var sink: Pipewire.defaultAudioSink

        PwObjectTracker { objects: volumeModule.sink ? [volumeModule.sink] : [] }

        onWheel: (wheel) => {
            if (sink?.ready && sink?.audio) {
                let delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                sink.audio.volume = Math.max(0, Math.min(1.0, sink.audio.volume + delta));
            }
        }

        onPressed: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached("pavucontrol");
            } else if (mouse.button === Qt.LeftButton) {
                if (sink?.audio) sink.audio.muted = !sink.audio.muted;
            }
        }

        Row {
            id: volumeContent
            spacing: 6
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: audioIcon
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 16
                color: Style.colAqua
                anchors.verticalCenter: parent.verticalCenter

                text: {
                    if (volumeModule.sink?.audio?.muted) return "󰝟";
                    if (!volumeModule.sink) return "󰓃";
                    let name = volumeModule.sink.name.toLowerCase();
                    let isHeadset = name.includes("headset") || name.includes("phone");
                    return isHeadset ? "󰋋" : "󰓃";
                }
            }

            Text {
                id: volumeText
                text: {
                    if (volumeModule.sink?.ready && volumeModule.sink?.audio) {
                        let v = volumeModule.sink.audio.volume;
                        return isNaN(v) ? "0%" : Math.round(v * 100) + "%";
                    }
                    return "--%";
                }

                color: Style.colWhite
                font.pixelSize: 18
                font.bold: true
            }
        }
    }
}
