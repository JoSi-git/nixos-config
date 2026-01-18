import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent

    property color colRed: "#CC241D"
    property color colGreen: "#32CD32"
    property color colYellow: "#FABD2F"
    property color colAqua: "#458588"
    property color colBlue:"#669bbc"
    property color colLavender: "#9381ff"
    property color colCyan: "#689D6A"
    property color colOrange: "#FE8019"
    property color colWhite: "#FFFFFF"
    property color bgCloud: '#b93131'
    property color colGray: '#3c3836'

    property bool showDate: false
    property date now: new Date()

    function toRoman(num) {
        const roman = ["", "I", "II", "III", "IV", "V"];
        return roman[num] || "";
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: now = new Date()
    }

    Row {
        id: leftSide
        spacing: 20
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10


        Text {
            text: "\uf313"
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 20
                color: colWhite
                anchors.verticalCenter: parent.verticalCenter
            }

        Row {
            id: workspacesRow
            spacing: 15
            Repeater {
                model: 5
                delegate: Text {
                    property int wsId: index + 1
                    property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
                    property bool isActive: Hyprland.focusedWorkspace?.id === wsId
                    
                    text: toRoman(wsId)
                    font.pixelSize: 18
                    font.bold: true
                    color: isActive ? colOrange : (ws ? colYellow : colWhite)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Hyprland.dispatch("workspace " + wsId);
                        }
                    }
                }
            }
        }

        Row {
            id: trayModule
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter
            Repeater {
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

                    onClicked: function(mouse) {
                        if (mouse.button === Qt.RightButton) {
                        if (modelData.hasMenu || modelData.onlyMenu) {
            
                        var globalPos = parent.mapToItem(qsbar.contentItem, 0, 0)
            
                        modelData.display(
                            qsbar,
                            globalPos.x,
                            globalPos.y + parent.height + 4
                            )
                        }
                        return
                        }
                    }
                }
            }
        }
    }

    Text {
        id: clockModule
        anchors.centerIn: parent
        text: showDate ? now.toLocaleDateString(Qt.locale("de_DE"), "dd/MM/yyyy") : now.toLocaleTimeString(Qt.locale("de_DE"), "HH:mm:ss")
        font.pixelSize: 18
        font.bold: true
        color: colWhite
        

        MouseArea {
            anchors.fill: parent
            onClicked: showDate = !showDate
        }
    }

    Row {
        id: rightSide
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10
        spacing: 15

        Row {
            id: privacydotsModule
            anchors.verticalCenter: parent.verticalCenter
            property string raw: ""

            Process {
                id: ps
                running: true
                command: ["bash", "-c", "~/nixos-config/modules/home/scripts/scripts/privacy_dots.sh"]
                stdout: StdioCollector { 
                onStreamFinished: {
                    try { privacydotsModule.raw = JSON.parse(this.text).text } catch(e) {}
                    }
                }
                
                onRunningChanged: if (!running) reloader.start()
            }

            Timer { id: reloader; interval: 1000; onTriggered: ps.running = true }

            Text {
                textFormat: Text.StyledText
                    text: privacydotsModule.raw.replace(/foreground/g, "color").replace(/span/g, "font")
                    font.bold: true
            }
        }
        
        Row {
            id: batteryModule
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            readonly property var device: UPower.displayDevice
            readonly property bool isPlugged: device.state === 1 || device.state === 4
        
            readonly property int displayPercentage: {
                if (!device || device.percentage === undefined) return 0;
                let p = device.percentage;
                return (p <= 1.0 && p > 0) ? Math.round(p * 100) : Math.round(p);
            }

            readonly property bool showPercentage: displayPercentage < 100

            Text {
                id: iconText
                text: batteryModule.isPlugged ? "" : (
                    batteryModule.displayPercentage <= 20 ? " " : 
                    batteryModule.displayPercentage <= 40 ? " " : 
                    batteryModule.displayPercentage <= 60 ? " " : 
                    batteryModule.displayPercentage <= 80 ? " " : " "
                )
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 17
            
                width: 22
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
            
                color: {
                    if (batteryModule.isPlugged) return colYellow;
                    if (batteryModule.displayPercentage <= 20) return colRed;
                    if (batteryModule.displayPercentage <= 50) return colYellow;
                    return colGreen;
                }
        }

        Text {
            id: percentageText
            text: batteryModule.displayPercentage + "%"
            color: colWhite
            font.pixelSize: 18
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 2
            visible: batteryModule.showPercentage
        }
    }

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
                color: (volumeModule.sink?.audio?.muted) ? colAqua : colAqua
                anchors.verticalCenter: parent.verticalCenter

                text: {
                if (volumeModule.sink.audio?.muted) return "󰝟";
                
                let name = volumeModule.sink.name.toLowerCase();
                let isHeadset = name.includes("headset") || name.includes("phone");
                return isHeadset ? "󰋋" : "󰓃";
                }
            }

            Text {
                text: {
                    if (volumeModule.sink?.ready && volumeModule.sink?.audio) {
                    let v = volumeModule.sink.audio.volume;
                    return isNaN(v) ? "0%" : Math.round(v * 100) + "%";
                    }
                    return "--%";
                }

                color: colWhite
                font.pixelSize: 18
                font.bold: true
            }
          }
        }

        Row {
            id: statusIcons
            spacing: 15 
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "󰤨"
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 17
                color: colBlue

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onPressed: {
                        if (mouse.button === Qt.RightButton) {
                            Quickshell.execDetached("iwgtk");
                        }
                    }
                }
            }

            Text {
                text: "󰂯"
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 17
                color: colBlue
                                
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onPressed: {
                        if (mouse.button === Qt.RightButton) {
                            Quickshell.execDetached("blueman-manager");
                        }
                    }
                }
            }
        }

        Text {            
            text: "\uf011"
            font.family: "Symbols Nerd Font Mono"
            font.pixelSize: 17
            color: colWhite
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}