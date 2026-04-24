import QtQuick
import Quickshell
import Quickshell.Io
import "../components"
import "../.."

HexPanel {

    property int  wifiStrength:   -1
    property bool wifiConnected:  false
    property bool ethernetActive: false
    property bool btPowered:      false
    property bool btConnected:    false

    Process {
        id: statusProc
        command: ["bash", "-c", `
            eth=$(ip link show | grep -E '^[0-9]+: e[nt]' | grep -c 'state UP')
            echo "ETH:$eth"
            station=$(iwctl station list 2>/dev/null \
                | sed 's/\x1b\[[0-9;]*m//g' \
                | awk '/connected/{print $1; exit}')
            if [ -z "$station" ]; then
                echo "WIFI:none"
            else
                rssi=$(iwctl station "$station" show 2>/dev/null \
                    | sed 's/\x1b\[[0-9;]*m//g' \
                    | grep 'RSSI' | grep -v 'Average' \
                    | grep -oP '[-]?[0-9]+(?= dBm)')
                echo "WIFI:\${rssi:-none}"
            fi
            echo "BTPOWERED:$(bluetoothctl show 2>/dev/null | grep 'Powered' | grep -c 'yes')"
            echo "BTCONNECTED:$(bluetoothctl info 2>/dev/null | grep -E '^	Connected: yes' | grep -c 'yes')"
        `]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.trim().split("\n")
                for (var i = 0; i < lines.length; i++) {
                    var parts = lines[i].split(":")
                    var key = parts[0], val = parts[1]
                    if (key === "ETH") {
                        ethernetActive = (val !== "0" && val !== "")
                    } else if (key === "WIFI") {
                        if (val === "none" || val === "") {
                            wifiConnected = false; wifiStrength = -1
                        } else {
                            var dbm = parseFloat(val)
                            if (isNaN(dbm)) { wifiConnected = false; wifiStrength = -1 }
                            else {
                                wifiConnected = true
                                if (dbm <= -100)     wifiStrength = 0
                                else if (dbm >= -50) wifiStrength = 100
                                else                 wifiStrength = Math.round((dbm + 100) * 2)
                            }
                        }
                    } else if (key === "BTPOWERED") {
                        btPowered = (val === "1")
                    } else if (key === "BTCONNECTED") {
                        btConnected = (val === "1")
                    }
                }
            }
        }
    }

    Timer {
        interval: 3000
        running:  true
        repeat:   true
        triggeredOnStart: true
        onTriggered: {
            statusProc.running = false; statusProc.running = true
        }
    }

    function wifiIconChar() {
        if (ethernetActive)      return "󰈀"
        if (!wifiConnected)      return "󰤭"
        if (wifiStrength >= 75)  return "󰤨"
        if (wifiStrength >= 50)  return "󰤥"
        if (wifiStrength >= 25)  return "󰤢"
        return "󰤟"
    }

    function wifiColor() {
        if (!ethernetActive && !wifiConnected) return Style.colGray
        return Style.colBlue
    }

    function btIconChar() {
        if (!btPowered)  return "󰂲"
        if (btConnected) return "󰂱"
        return "󰂯"
    }

    function btColor() {
        if (btConnected) return Style.colBlue
        return Style.colGray
    }

    Row {
        id: statusIcons
        spacing: 10

        Item {
            width:  wifiIconText.width
            height: wifiIconText.height

            Text {
                id: wifiIconText
                text:           wifiIconChar()
                font.family:    "Symbols Nerd Font Mono"
                font.pixelSize: 17
                color:          wifiColor()
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onPressed: function(mouse) {
                    if (mouse.button === Qt.RightButton)
                        Quickshell.execDetached("iwgtk")
                }
            }
        }

        Item {
            width:  btIconText.width
            height: btIconText.height

            Text {
                id: btIconText
                text:           btIconChar()
                font.family:    "Symbols Nerd Font Mono"
                font.pixelSize: 17
                color:          btColor()
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onPressed: function(mouse) {
                    if (mouse.button === Qt.RightButton)
                        Quickshell.execDetached("blueman-manager")
                }
            }
        }
    }
}
