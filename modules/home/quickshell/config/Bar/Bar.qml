import QtQuick
import Quickshell
import Quickshell.Hyprland
import ".."

PanelWindow {
    id: qsbar
    
    property var targetScreen 
    property bool centerVisible: false
    
    screen: targetScreen 
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: targetScreen ? targetScreen.height : 60
    color: "transparent"
    exclusiveZone: 60 

    mask: Region {
        Region {
            x: 0
            y: 0
            width: qsbar.width
            height: 80 
        }

        Region {
            x: controlCenter.x
            y: controlCenter.y
            width: qsbar.centerVisible ? controlCenter.width : 0
            height: qsbar.centerVisible ? controlCenter.height : 0
        }
    }

    Rectangle {
        id: barMainContent
        width: parent.width
        height: 80
        color: "transparent"
        
        Image {
            id: barChainLeft
            source: "./assets/chain.svg"
            width: 25; height: 25
            anchors { top: parent.top; left: parent.left; leftMargin: 75 }
            sourceSize.width: width; sourceSize.height: height
        }
        
        Image {
            id: barChainRight
            source: "./assets/chain.svg"
            width: 25; height: 25
            anchors { top: parent.top; right: parent.right; rightMargin: 75 }
            sourceSize.width: width; sourceSize.height: height
        }
        
        Rectangle {
            id: barContainer
            height: 35
            anchors {
                left: parent.left; right: parent.right
                top: barChainLeft.bottom
                leftMargin: 8; rightMargin: 8
            }
            color: Style.colBg
            radius: 8
            border.color: Style.colBorder
            border.width: 1

            Loader {
                anchors.fill: parent
                source: "BarContent.qml"
            }
        }
    }

    BarPopout {
        id: controlCenter
        isOpen: qsbar.centerVisible
        anchors.horizontalCenter: parent.horizontalCenter
    }
}