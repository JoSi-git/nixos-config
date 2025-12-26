import QtQuick
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: panel
    implicitHeight: 60
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }
        
    Rectangle {
        id: bar_main_content
        anchors.fill: parent
        color: "transparent"
        
        Image {
            id: bar_chain_left
            source: "assets/chain.svg"
            width: 25
            height: 25
            
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 75
            
            sourceSize.width: width
            sourceSize.height: height
        }
        
        Image {
            id: bar_chain_right
            source: "assets/chain.svg"
            width: 25
            height: 25
            
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 75
            
            sourceSize.width: width
            sourceSize.height: height
        }
        
        Rectangle {
            id: bar
            anchors.left: parent.left
            anchors.right: parent.right
            
            anchors.top: bar_chain_left.bottom
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            
            height: 35
            color: "#0b1119"
            radius: 8
            border.color: "#C0C0C0"
            border.width: 1
            
            BarContent {
                anchors.fill: parent 
                anchors.margins: 5
                }
        }
    }
}

