import QtQuick
import QtQuick.Controls
import Quickshell
import ".."
import "popouts"

Rectangle {
    id: popout
    property bool isOpen: false
    property string activeCategory: "Dashboard"

    width: 720 
    height: 405
    color: Style.colBg 
    radius: 12
    border.color: Style.colBorder
    border.width: 1
    
    visible: opacity > 0
    opacity: isOpen ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }
    
    y: isOpen ? 70 : 60
    Behavior on y { 
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic 
        } 
    }

    HoverHandler {
        onHoveredChanged: { qsbar.popoutHovered = hovered }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        PopoutHeader {
            id: header
            width: parent.width
            activeTab: popout.activeCategory
            onTabClicked: (name) => popout.activeCategory = name
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Style.colBorder
            opacity: 0.5
        }

        Loader {
            id: contentLoader
            width: parent.width
            height: parent.height - header.height - 31
            source: "./popouts/Category" + popout.activeCategory + ".qml"
            
            onStatusChanged: {
                if (status === Loader.Error) {
                    console.warn("Could not load category: " + source)
                }
            }
        }
    }
}
