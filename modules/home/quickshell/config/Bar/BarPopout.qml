import QtQuick
import Quickshell
import ".."

Rectangle {
    id: popout
    property bool isOpen: false
    width: 450 
    height: 280
    
    color: Style.colBg 
    radius: 12
    border.color: Style.colBorder
    border.width: 1
    
    visible: opacity > 0
    opacity: isOpen ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    y: isOpen ? 85 : 60
    Behavior on y { 
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic 
        } 
    }

    Text {
        id: title
        text: "Control Center"
        color: Style.colWhite
        font.pixelSize: 14
        font.bold: true
        anchors {
            top: parent.top
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 40
        color: "transparent"
        
        Text {
            anchors.centerIn: parent
            text: "Hopp Mitenand"
            color: Style.colWhite
            opacity: 0.3
            font.italic: true
        }
    }
}
