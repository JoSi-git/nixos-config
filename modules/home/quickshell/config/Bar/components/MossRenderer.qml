import QtQuick

Canvas {
    id: root
    property real fraction:  1.0
    property real barTop:    25
    property real barBot:    60
    property real maxDown:   63
    property int  seed:      7331
    property real zoneLeft:  180
    property real zoneRight: 120

    property color mossDeep:  "#1a3d28"
    property color mossLight: "#2a5a3a"
    property string mossDeepStr:  mossDeep.toString()
    property string mossLightStr: mossLight.toString()

    enabled: false
    width:   parent ? parent.width  : 200
    height:  parent ? parent.height : 63

    Timer {
        interval: 200
        running:  true
        repeat:   true
        onTriggered: root.requestPaint()
    }

    onPaint: {
        const ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        const f = root.fraction
        if (f <= 0) return

        const zL = root.zoneLeft
        const zR = width - root.zoneRight
        const bt = root.barTop

        let s = root.seed
        function rng() {
            s = ((s * 1664525) + 1013904223) & 0xffffffff
            return (s >>> 0) / 0xffffffff
        }

        const totalClusters = 28
        const visibleCount  = f * totalClusters

        for (let i = 0; i < totalClusters; i++) {
            const clusterFade = Math.max(0.0, Math.min(1.0, visibleCount - i))

            const cx      = zL + rng() * (zR - zL)
            const blades  = 4 + Math.floor(rng() * 5)
            const spread  = 22 + rng() * 48
            const useDeep = rng() > 0.45
            const baseAlpha = 0.6 + rng() * 0.35

            if (clusterFade <= 0) continue

            for (let b = 0; b < blades; b++) {
                const ox  = (rng() - 0.5) * spread
                const oy  = -(rng() * 5)
                const rw  = 3.0 + rng() * 7.0
                const rh  = 1.2 + rng() * 4.0
                const rot = (rng() - 0.5) * 0.4

                ctx.fillStyle   = useDeep ? root.mossDeepStr : root.mossLightStr
                ctx.globalAlpha = baseAlpha * clusterFade

                ctx.save()
                ctx.translate(cx + ox, bt + oy)
                ctx.rotate(rot)
                ctx.beginPath()
                ctx.ellipse(0, 0, rw, rh, 0, 0, Math.PI * 2)
                ctx.fill()
                ctx.restore()
            }
        }
    }
}
