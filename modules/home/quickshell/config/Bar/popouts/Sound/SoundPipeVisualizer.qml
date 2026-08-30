import QtQuick
import Quickshell.Io

Item {
    id: root
    anchors.fill: parent

    property var levels: Array(13).fill(0)

    Process {
        running: true
        command: ["bash", "-c", "cava -p ${HOME}/.config/quickshell/Bar/assets/cava.ini"]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                var p = line.trim().split(";")
                if (p.length >= 13)
                    root.levels = p.slice(0, 13).map(x => Math.min(1, parseInt(x) / 100))
            }
        }
    }

    readonly property real sc:   height / 337.02
    readonly property real padX: (width - 290.18 * sc) / 2
    readonly property real topY: 62.22 * sc

    // Left/right pipe edges in SVG units (viewBox 290.18×337.02, translate -775,-518)
    readonly property var lefts:  [60.07, 72.18, 85.58,  98.98, 112.38, 125.78, 139.19,
                                   153.34, 167.71, 182.07, 196.44, 210.80, 223.88]
    readonly property var rights: [66.30, 79.38, 93.74, 108.11, 122.47, 136.84, 150.99,
                                   164.40, 177.80, 191.20, 204.60, 218.00, 230.11]

    Repeater {
        model: 13
        delegate: Rectangle {
            required property int index
            property real lvl: root.levels[index] ?? 0
            Behavior on lvl { NumberAnimation { duration: 16 } }

            x:      root.padX + root.lefts[index] * root.sc
            y:      root.topY * (1 - lvl)
            width:  (root.rights[index] - root.lefts[index]) * root.sc
            height: root.topY * lvl
            color:  "#dcb748"
        }
    }
}
