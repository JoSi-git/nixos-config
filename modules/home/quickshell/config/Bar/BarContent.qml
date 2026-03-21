import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import ".."


Rectangle {
    id: barContentRoot
    color: "transparent"
    anchors.fill: parent

    property bool showDate: false
    property date currentTime: new Date()

    function toRoman(num) {
        const roman = ["", "I", "II", "III", "IV", "V"];
        return roman[num] || "";
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentTime = new Date()
    }

    Row {
        id: leftSide
        spacing: 5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10

        HexPanel {
            Text {
                text: "\uf313"
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 20
                color: Style.colWhite
            }
        }
    
        HexPanel {
            Row {
                id: workspacesRow
                spacing: 15
                Repeater {
                    model: 5
                    delegate: Text {
                        property int workspaceId: index + 1
                        property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceId)
                        property bool isActive: Hyprland.focusedWorkspace?.id === workspaceId
                        
                        text: toRoman(workspaceId)
                        font.pixelSize: 18
                        font.bold: true
                        color: isActive ? Style.colOrange : (workspace ? Style.colYellow : Style.colWhite)

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("workspace " + workspaceId)
                        }
                    }
                }
            }
        }

        HexPanel {
            visible: trayRepeater.count > 0
            Row {
                id: trayModule
                spacing: 8
                Repeater {
                    id: trayRepeater
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

                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                if (modelData.hasMenu || modelData.onlyMenu) {
                                    var globalPos = parent.mapToItem(qsbar.contentItem, 0, 0)
                                    modelData.display(
                                        qsbar,
                                        globalPos.x,
                                        globalPos.y + parent.height + 4
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    HexPanel {
        anchors.centerIn: parent

        Text {
            id: clockModule
            anchors.centerIn: parent
            
            text: showDate ? currentTime.toLocaleDateString(Qt.locale("de_DE"), "dd/MM/yyyy") : currentTime.toLocaleTimeString(Qt.locale("de_DE"), "HH:mm:ss")
            font.pixelSize: 18
            font.bold: true
            color: Style.colWhite

            MouseArea {
                id: clockMouse
                width: parent.width + 20
                height: parent.height + 10
                anchors.centerIn: parent
                
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        qsbar.centerVisible = !qsbar.centerVisible 
                    } else if (mouse.button === Qt.RightButton) {
                        showDate = !showDate
                    }
                }
            }
        }
    }

    Row {
        id: rightSide
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10
        spacing: 5

        HexPanel {
            visible: privacyDotsModule.rawText !== ""
            Row {
                id: privacyDotsModule
                property string rawText: ""

                Process {
                    id: privacyProcess
                    running: true
                    command: ["bash", "-c", "~/nixos-config/modules/home/scripts/privacy_dots.sh"]
                    stdout: StdioCollector { 
                        onStreamFinished: {
                            try {
                                privacyDotsModule.rawText = JSON.parse(this.text).text
                            } catch(e) {}
                        }
                    }
                    
                    onRunningChanged: if (!running) privacyReloader.start()
                }

                Timer {
                    id: privacyReloader
                    interval: 1000
                    onTriggered: privacyProcess.running = true
                }

                Text {
                    textFormat: Text.StyledText
                    text: privacyDotsModule.rawText.replace(/foreground/g, "color").replace(/span/g, "font")
                    font.bold: true
                }
            }
        }
        
        HexPanel {
            Row {
                id: batteryModule
                spacing: 0
                
                readonly property var device: UPower.displayDevice
                readonly property bool isPlugged: device.state === 1 || device.state === 4
            
                readonly property int displayPercentage: {
                    if (!device || device.percentage === undefined) return 0;
                    let p = device.percentage;
                    return (p <= 1.0 && p > 0) ? Math.round(p * 100) : Math.round(p);
                }
            
                readonly property bool showPercentage: displayPercentage < 100

                Item {
                    width: 22
                    height: 24
            
                    Text {
                        id: batteryIcon
                        anchors.centerIn: parent
                        text: batteryModule.isPlugged ? "" : (
                            batteryModule.displayPercentage <= 20 ? " " : 
                            batteryModule.displayPercentage <= 40 ? " " : 
                            batteryModule.displayPercentage <= 60 ? " " : 
                            batteryModule.displayPercentage <= 80 ? " " : " "
                        )
                        font.family: "Symbols Nerd Font Mono"
                        font.pixelSize: 17
                        
                        color: {
                            if (batteryModule.isPlugged) return Style.colYellow;
                            if (batteryModule.displayPercentage <= 20) return Style.colRed;
                            if (batteryModule.displayPercentage <= 50) return Style.colYellow;
                            return Style.colGreen;
                        }
                    }
                }

                Text {
                    id: batteryPercentageText
                    text: batteryModule.displayPercentage + "%"
                    color: Style.colWhite
                    font.pixelSize: 18
                    font.bold: true
                    leftPadding: 2
                    visible: batteryModule.showPercentage
                }
            }
        }

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

        HexPanel {
            Row {
                id: statusIcons
                spacing: 10

                Text {
                    id: wifiIcon
                    text: "󰤨"
                    font.family: "Symbols Nerd Font Mono"
                    font.pixelSize: 17
                    color: Style.colBlue

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
                    id: bluetoothIcon
                    text: "󰂯"
                    font.family: "Symbols Nerd Font Mono"
                    font.pixelSize: 17
                    color: Style.colBlue
                                    
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
        }

        HexPanel {
            Text {
                id: powerIcon
                text: "\uf011"
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 17
                color: Style.colWhite
            
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed: {
                        if (mouse.button === Qt.LeftButton) {
                            Quickshell.execDetached(["wlogout", "-b", "4"]);
                        }
                    }
                }
            }
        }        
    }
}
