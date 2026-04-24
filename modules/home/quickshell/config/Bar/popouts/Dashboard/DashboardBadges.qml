import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../.."

Item {
    id: root
    anchors.fill: parent

    property string nixVersion:    ""
    property string hlVersion:     ""
    property string kernelVersion: ""
    property string nixPkgs:       ""
    property string uptime:        ""

    Process {
        command: ["bash", "-c",
            "f=/tmp/qs_nixVersion; [ -f \"$f\" ] && cat \"$f\" || " +
            "(grep ^VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '\"' | tee \"$f\")"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.nixVersion = text.trim() }
    }
    Process {
        command: ["bash", "-c",
            "f=/tmp/qs_hlVersion; [ -f \"$f\" ] && cat \"$f\" || " +
            "(hyprctl version 2>/dev/null | head -1 | awk '{print $2}' | tee \"$f\")"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.hlVersion = text.trim() }
    }
    Process {
        command: ["bash", "-c",
            "f=/tmp/qs_kernelVersion; [ -f \"$f\" ] && cat \"$f\" || " +
            "(uname -r | cut -d- -f1 | tee \"$f\")"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.kernelVersion = text.trim() }
    }
    Process {
        command: ["bash", "-c",
            "f=/tmp/qs_nixPkgs; [ -f \"$f\" ] && cat \"$f\" || " +
            "(nix-store -qR /run/current-system 2>/dev/null | wc -l | tee \"$f\")"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.nixPkgs = text.trim() }
    }
    Process {
        id: uptimeProcess
        command: ["bash", "-c",
            "uptime | grep -oP '[\\d]+:[\\d]+(?= an)' | awk -F: '{print $1\"h \" $2\"m\"}'"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.uptime = text.trim() }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: uptimeProcess.running = true
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columns: 2
        rowSpacing: 8
        columnSpacing: 8

        Repeater {
            model: [
                { icon: "\ue843", label: "NixOS",    value: root.nixVersion    },
                { icon: "\uf359", label: "Hyprland",  value: root.hlVersion    },
                { icon: "\uf17c", label: "Kernel",    value: root.kernelVersion },
                { icon: "\uf520", label: "Uptime",    value: root.uptime       },
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
                    spacing: 4

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 5
                        Text {
                            text: modelData.icon
                            font.family: "Hack Nerd Font"
                            font.pixelSize: 13
                            color: Style.colBorder
                        }
                        Text {
                            text: modelData.label
                            color: Style.colBorder
                            opacity: 0.55
                            font.pixelSize: 9
                            font.letterSpacing: 1.3
                            font.weight: Font.Light
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: modelData.value.length > 0 ? modelData.value : "—"
                        color: Style.colWhite
                        opacity: 0.85
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        font.letterSpacing: 0.5
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
                spacing: 4

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5
                    Text {
                        text: "\uf187"
                        font.family: "Hack Nerd Font"
                        font.pixelSize: 13
                        color: Style.colBorder
                    }
                    Text {
                        text: "Nix Pkgs"
                        color: Style.colBorder
                        opacity: 0.55
                        font.pixelSize: 9
                        font.letterSpacing: 1.3
                        font.weight: Font.Light
                    }
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.nixPkgs.length > 0 ? root.nixPkgs : "—"
                    color: Style.colWhite
                    opacity: 0.85
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    font.letterSpacing: 0.5
                }
            }
        }
    }
}