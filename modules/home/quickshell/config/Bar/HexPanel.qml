import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import ".."

Item {
    id: hexRoot
    property color borderColor: Style.colBorder02 
    property color bgColor: Style.colBg02
    default property alias content: container.data

    property var onHoverChanged: null
    signal clicked()

    TapHandler {
        onTapped: hexRoot.clicked()
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hexRoot.onHoverChanged) hexRoot.onHoverChanged(hovered)
        }
    }

    height: 24
    property int hexHeight: height
    opacity: hoverHandler.hovered ? 0.8 : 1.0
    Behavior on opacity { NumberAnimation { duration: 150 } }
    
    implicitWidth: container.childrenRect.width + (hexHeight * 1.1)
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 8
        antialiasing: true 

        ShapePath {
            strokeColor: hexRoot.borderColor 
            fillColor: hexRoot.bgColor
            strokeWidth: 1.2
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: hexHeight * 0.4; startY: 1
            PathLine { x: hexRoot.width - (hexHeight * 0.4); y: 1 }
            PathLine { x: hexRoot.width - 1; y: hexRoot.height / 2 }
            PathLine { x: hexRoot.width - (hexHeight * 0.4); y: hexRoot.height - 1 }
            PathLine { x: hexHeight * 0.4; y: hexRoot.height - 1 }
            PathLine { x: 1; y: hexRoot.height / 2 }
            PathLine { x: hexHeight * 0.4; y: 1 }
        }
    }
    Row {
        id: container
        anchors.centerIn: parent
    }
}
