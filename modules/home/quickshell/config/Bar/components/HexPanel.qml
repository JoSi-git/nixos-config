import QtQuick
import QtQuick.Shapes
import "../.."
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

    property int shadowOffset: 2
    height: 24
    property int hexHeight: height - shadowOffset + 2
    implicitWidth: container.implicitWidth + (hexHeight * 1.1) + 2
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined

    layer.enabled: true
    layer.samples: 8

    property color effectiveBgColor: hoverHandler.hovered ? Qt.lighter(hexRoot.bgColor, 1.3) : hexRoot.bgColor
    Behavior on effectiveBgColor { ColorAnimation { duration: 150 } }

    Shape {
        id: shadowShape
        property real s: 0.99
        property real ox: hexRoot.width * (1 - s) / 2
        property real oy: (hexRoot.hexHeight + 1) * (1 - s) / 2
        x: 1; y: 1
        width: parent.width
        height: hexRoot.hexHeight + 1
        antialiasing: true
        ShapePath {
            strokeColor: "transparent"
            fillColor: hexRoot.borderColor
            strokeWidth: 0
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            startX: hexRoot.hexHeight * 0.4 * shadowShape.s + shadowShape.ox; startY: 1 * shadowShape.s + shadowShape.oy
            PathLine { x: (hexRoot.width - hexRoot.hexHeight * 0.4) * shadowShape.s + shadowShape.ox; y: 1 * shadowShape.s + shadowShape.oy }
            PathLine { x: (hexRoot.width - 1) * shadowShape.s + shadowShape.ox;                      y: hexRoot.hexHeight / 2 }
            PathLine { x: (hexRoot.width - hexRoot.hexHeight * 0.4) * shadowShape.s + shadowShape.ox; y: (hexRoot.hexHeight - 1) * shadowShape.s + shadowShape.oy }
            PathLine { x: hexRoot.hexHeight * 0.4 * shadowShape.s + shadowShape.ox;                  y: (hexRoot.hexHeight - 1) * shadowShape.s + shadowShape.oy }
            PathLine { x: 1 * shadowShape.s + shadowShape.ox;                                        y: hexRoot.hexHeight / 2 }
            PathLine { x: hexRoot.hexHeight * 0.4 * shadowShape.s + shadowShape.ox;                  y: 1 * shadowShape.s + shadowShape.oy }
        }
    }

    Item {
        id: mainWrapper
        anchors.fill: parent

        Shape {
            x: 0; y: -1
            width: parent.width
            height: hexRoot.hexHeight
            antialiasing: true
            ShapePath {
                strokeColor: "transparent"
                fillColor: hexRoot.effectiveBgColor
                strokeWidth: 0
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                startX: hexRoot.hexHeight * 0.4; startY: 1
                PathLine { x: hexRoot.width - (hexRoot.hexHeight * 0.4); y: 1 }
                PathLine { x: hexRoot.width - 1; y: hexRoot.hexHeight / 2 }
                PathLine { x: hexRoot.width - (hexRoot.hexHeight * 0.4); y: hexRoot.hexHeight - 1 }
                PathLine { x: hexRoot.hexHeight * 0.4; y: hexRoot.hexHeight - 1 }
                PathLine { x: 1; y: hexRoot.hexHeight / 2 }
                PathLine { x: hexRoot.hexHeight * 0.4; y: 1 }
            }
        }

        Row {
            id: container
            x: (parent.width - width) / 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -(hexRoot.shadowOffset / 2)
        }
    }
}
