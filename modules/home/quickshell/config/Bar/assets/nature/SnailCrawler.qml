import QtQuick

Item {
    id: root
    property real barTop: 0
    property real snailX: -48
    property bool goingRight: true

    AnimatedImage {
        id: snailImg
        source: "../frog-snail.gif"
        width:  48
        height: 28
        x:      -48
        y:      root.barTop - height
        playing: true
        mirror:  root.goingRight
    }

    SequentialAnimation {
        id: crossingSetup
        running: false
        ScriptAction {
            script: {
                root.goingRight = (Math.random() >= 0.5)
                root.snailX     = root.goingRight ? -48 : root.width + 48
                snailImg.x      = root.snailX
                stepLoop.restart()
            }
        }
    }

    SequentialAnimation {
        id: stepLoop
        loops: Animation.Infinite
        running: false

        PauseAnimation  { duration: 810 }
        NumberAnimation {
            target:      snailImg
            property:    "x"
            to:          root.snailX + (root.goingRight ? 20 : -20)
            duration:    600
            easing.type: Easing.OutQuad
        }
        ScriptAction {
            script: {
                root.snailX = snailImg.x
                var done = root.goingRight
                    ? snailImg.x > root.width + 48
                    : snailImg.x < -48
                if (done) {
                    stepLoop.stop()
                    pauseTimer.interval = Math.floor(1800000 + Math.random() * 1800000)
                    pauseTimer.restart()
                }
            }
        }
        PauseAnimation  { duration: 810 }
    }

    // first crossing starts 30–60 min after shell loads, then every 30–60 min
    Timer {
        id: pauseTimer
        repeat: false
        running: true
        interval: Math.floor(1800000 + Math.random() * 1800000)
        onTriggered: crossingSetup.restart()
    }
}
