pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    readonly property real uptimeSeconds: _rawUptime
    property real _rawUptime: 0.0

    property FileView _procFile: FileView {
        path: "/proc/uptime"
        watchChanges: false
        onLoaded: {
            const val = parseFloat(text())
            if (!isNaN(val)) root._rawUptime = val
        }
    }

    property Timer _pollTimer: Timer {
        interval: 10000
        running:  true
        repeat:   true
        triggeredOnStart: true
        onTriggered: root._procFile.reload()
    }
}
