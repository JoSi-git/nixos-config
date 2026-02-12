import QtQuick
import QtQuick.Shapes
import ".."

Item {
    id: hexRoot
    property color borderColor: Style.colBorder02 
    property color bgColor: Style.colBg02
    default property alias content: container.data

    height: 24
    implicitWidth: container.childrenRect.width + 26
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

            startX: 10; startY: 1
            PathLine { x: hexRoot.width - 10; y: 1 }
            PathLine { x: hexRoot.width - 1; y: hexRoot.height / 2 }
            PathLine { x: hexRoot.width - 10; y: hexRoot.height - 1 }
            PathLine { x: 10; y: hexRoot.height - 1 }
            PathLine { x: 1; y: hexRoot.height / 2 }
            PathLine { x: 10; y: 1 }
        }
    }

    Row {
        id: container
        anchors.centerIn: parent
    }
}