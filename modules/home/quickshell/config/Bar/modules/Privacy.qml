import QtQuick
import Quickshell.Io
import "../components"
import "../.."

HexPanel {
    id: privacyRoot
    visible: privacyDotsRow.rawText !== ""

    Row {
        id: privacyDotsRow
        leftPadding: 1
        rightPadding: 1
        property string rawText: ""

        Process {
            id: privacyProcess
            running: true
            command: ["bash", "-c", "~/nixos-config/modules/home/scripts/privacy_dots.sh"]
            stdout: StdioCollector { 
                onStreamFinished: {
                    try {
                        let raw = JSON.parse(this.text).text
                        privacyDotsRow.rawText = raw.replace(/foreground/g, "color").replace(/span/g, "font")
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
            text: privacyDotsRow.rawText
            font.bold: true
        }
    }
}
