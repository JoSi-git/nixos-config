import QtQuick
import QtQuick.Controls
import ".."
import "../.."

HexPanel {
    id: clockModuleContainer
    onHoverChanged: (hovered) => { qsbar.clockHovered = hovered }
    property bool showDate: false
    property date currentTime: new Date()
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentTime = new Date()
    }

    Text {
        id: clockText
        text: showDate ? currentTime.toLocaleDateString(Qt.locale("de_DE"), "dd/MM/yyyy") : currentTime.toLocaleTimeString(Qt.locale("de_DE"), "HH:mm:ss")
        font.pixelSize: 18
        font.bold: true
        color: Style.colWhite
        TapHandler {
            onTapped: clockModuleContainer.showDate = !clockModuleContainer.showDate
        }
    }
}