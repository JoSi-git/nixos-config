import QtQuick
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: qsbar
    implicitHeight: 60
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }

    property color colBg: "#0b1119"
    property color colBorder: "#C0C0C0"
    property color colWhite: "#FFFFFF"
        
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
            color: colBg
            radius: 8
            border.color: colBorder
            border.width: 1

            Loader {
                anchors.fill: parent
                source: "bar_content.qml"
            }
        }
    }
}

