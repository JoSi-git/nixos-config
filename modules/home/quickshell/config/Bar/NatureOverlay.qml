import QtQuick
import "assets/nature"

Item {
    id: root
    property real uptimeSeconds: 0
    property real barHeight:    35
    property real headroomTop:  25
    property real headroomBot:  3
    property int  seed:         7331

    readonly property real excludeLeft:  280
    readonly property real excludeRight: 220

    function fade(start, window) {
        return Math.max(0.0, Math.min(1.0, (uptimeSeconds - start) / window))
    }

    enabled:        false
    implicitHeight: headroomTop + barHeight + headroomBot

    // moss: starts at 15 min, one patch every ~32s, 28 patches over 15 min
    MossRenderer {
        anchors.fill: parent
        fraction:     root.fade(900, 900)
        barTop:       root.headroomTop
        barBot:       root.headroomTop + root.barHeight
        maxDown:      root.headroomTop + root.barHeight + root.headroomBot
        seed:         root.seed
        zoneLeft:     root.excludeLeft - 180
        zoneRight:    root.excludeRight - 150
        mossDeep:     Style.natMossDeep
        mossLight:    Style.natMossLight
    }

    // brown mushroom: starts at 1 hr
    Image {
        source: "assets/nature/mushroom_brown.svg"
        width:  60
        height: 22
        x:      root.excludeLeft - 40
        y:      root.headroomTop - height
        opacity: root.fade(3600, 15) * 0.9
        visible: opacity > 0
        sourceSize.width:  width
        sourceSize.height: height
    }

    // green mushrooms: starts at 1 hr 10 min
    Image {
        source: "assets/nature/mushroom_green.svg"
        width:  200
        height: 22
        x:      root.excludeLeft + (root.width - root.excludeLeft - root.excludeRight) / 2 - width / 2
        y:      root.headroomTop - height
        opacity: root.fade(3600 + 600, 15) * 0.9
        visible: opacity > 0
        sourceSize.width:  width
        sourceSize.height: height
    }

    // fly agaric: starts at 1 hr 20 min
    Image {
        source: "assets/nature/mushroom_fly.svg"
        width:  60
        height: 28
        x:      root.width - root.excludeRight - 80
        y:      root.headroomTop - height
        opacity: root.fade(3600 + 1200, 15) * 0.9
        visible: opacity > 0
        sourceSize.width:  width
        sourceSize.height: height
    }

    // vine: starts at 2 hr
    Image {
        source: "assets/nature/vine_left.svg"
        width:  40
        height: 58
        x:      60
        y:      -20
        opacity: root.fade(7200, 15) * 0.9
        visible: opacity > 0
        sourceSize.width:  width
        sourceSize.height: height
    }
}
