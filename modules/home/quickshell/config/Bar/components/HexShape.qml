import QtQuick
import "../.."

Item {
    id: root
    property bool  filled:      true
    property color strokeColor: Style.colYellow
    property color fillColor:   Style.colBg03
    property real  strokeWidth: 1.8
    property real  padding:     2.0

    onWidthChanged:       canvas.requestPaint()
    onHeightChanged:      canvas.requestPaint()
    onFilledChanged:      canvas.requestPaint()
    onStrokeColorChanged: canvas.requestPaint()
    onFillColorChanged:   canvas.requestPaint()
    onStrokeWidthChanged: canvas.requestPaint()
    onPaddingChanged:     canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var cx = width  / 2
            var cy = height / 2
            var r  = Math.min(width, height) / 2 - root.padding

            ctx.beginPath()
            for (var i = 0; i < 6; i++) {
                var angle = (i * 60 - 90) * Math.PI / 180
                var x = cx + r * Math.cos(angle)
                var y = cy + r * Math.sin(angle)
                if (i === 0) ctx.moveTo(x, y)
                else         ctx.lineTo(x, y)
            }
            ctx.closePath()

            if (root.filled) {
                ctx.fillStyle = root.fillColor
                ctx.fill()
            }

            ctx.strokeStyle = root.strokeColor
            ctx.lineWidth   = root.strokeWidth
            ctx.lineJoin    = "round"
            ctx.stroke()
        }
    }
}
