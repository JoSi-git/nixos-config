import QtQuick
import QtQuick.Shapes
import "../.."

Item {
    id: root

    property bool  filled:      true
    property color strokeColor: Style.colYellow
    property color fillColor:   Style.colBg03
    property real  strokeWidth: 1.8
    property real  padding:     2.0

    layer.enabled: true
    layer.samples: 8

    Shape {
        anchors.fill: parent
        antialiasing: true

        property real cx: width  / 2
        property real cy: height / 2
        property real r:  Math.min(width, height) / 2 - root.padding

        ShapePath {
            strokeColor: root.strokeColor
            fillColor:   root.filled ? root.fillColor : "transparent"
            strokeWidth: root.strokeWidth
            capStyle:    ShapePath.RoundCap
            joinStyle:   ShapePath.RoundJoin

            startX: parent.cx + parent.r * Math.cos(-90 * Math.PI / 180)
            startY: parent.cy + parent.r * Math.sin(-90 * Math.PI / 180)
            PathLine { x: parent.cx + parent.r * Math.cos(-30 * Math.PI / 180); y: parent.cy + parent.r * Math.sin(-30 * Math.PI / 180) }
            PathLine { x: parent.cx + parent.r * Math.cos( 30 * Math.PI / 180); y: parent.cy + parent.r * Math.sin( 30 * Math.PI / 180) }
            PathLine { x: parent.cx + parent.r * Math.cos( 90 * Math.PI / 180); y: parent.cy + parent.r * Math.sin( 90 * Math.PI / 180) }
            PathLine { x: parent.cx + parent.r * Math.cos(150 * Math.PI / 180); y: parent.cy + parent.r * Math.sin(150 * Math.PI / 180) }
            PathLine { x: parent.cx + parent.r * Math.cos(210 * Math.PI / 180); y: parent.cy + parent.r * Math.sin(210 * Math.PI / 180) }
            PathLine { x: parent.cx + parent.r * Math.cos(-90 * Math.PI / 180); y: parent.cy + parent.r * Math.sin(-90 * Math.PI / 180) }
        }
    }
}
