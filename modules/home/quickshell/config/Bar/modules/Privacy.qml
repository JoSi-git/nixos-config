import QtQuick
import Quickshell.Io
import ".."
import "../.."

HexPanel {
    id: privacyRoot
    visible: privacyDotsRow.rawText !== ""

    Row {
        id: privacyDotsRow
        property string rawText: ""

        Process {
            id: privacyProcess
            running: true
            command: ["bash", "-c", "~/nixos-config/modules/home/scripts/privacy_dots.sh"]
            stdout: StdioCollector { 
                onStreamFinished: {
                    try {
                        privacyDotsRow.rawText = JSON.parse(this.text).text
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
            text: privacyDotsRow.rawText.replace(/foreground/g, "color").replace(/span/g, "font")
            font.bold: true
        }
    }
}
