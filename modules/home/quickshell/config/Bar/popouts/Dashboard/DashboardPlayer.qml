import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../../components"
import "../../.."

Item {
    id: root
    anchors.fill: parent

    readonly property MprisPlayer activePlayer: {
        const arr = Array.from(Mpris.players.values ?? [])
        let spotify = null, playing = null, any = null
        for (const p of arr) {
            const name = p.identity?.toLowerCase() ?? ""
            if (name.includes("spotify")) spotify = p
            if (p.playbackState === MprisPlaybackState.Playing && !playing) playing = p
            if (!any) any = p
        }
        return spotify ?? playing ?? any ?? null
    }

    readonly property bool   hasPlayer:   activePlayer !== null
    readonly property string trackTitle:  activePlayer?.trackTitle  || "nothing playing"
    readonly property string trackArtist: activePlayer?.trackArtist || ""
    readonly property string sourceApp:   activePlayer?.identity?.toLowerCase() ?? ""
    readonly property bool   isPlaying:   activePlayer?.playbackState === MprisPlaybackState.Playing
    readonly property bool   shuffleOn:   activePlayer?.shuffle ?? false
    readonly property int    loopState:   activePlayer?.loopState ?? MprisLoopState.None
    readonly property real   position:    activePlayer?.position ?? 0
    readonly property real   duration:    activePlayer?.length   ?? 0
    readonly property bool   hasArt:      (activePlayer?.trackArtUrl ?? "") !== ""

    Timer {
        interval: 1000
        repeat:   true
        running:  root.isPlaying && root.hasPlayer
        onTriggered: root.activePlayer.positionChanged()
    }

    function fmtTime(s) {
        if (!s || s <= 0) return "0:00"
        const m = Math.floor(s / 60)
        const sec = Math.floor(s % 60)
        return m + ":" + (sec < 10 ? "0" : "") + sec
    }

    function sourceIcon(name) {
        if (!name)                    return "\uf001"
        if (name.includes("spotify")) return "\uf1bc"
        if (name.includes("firefox")) return "\uf269"
        if (name.includes("chrome"))  return "\uf268"
        return "\uf001"
    }

    function sourceColor(name) {
        if (!name)                    return Style.colRivet
        if (name.includes("spotify")) return Style.colGreen
        if (name.includes("firefox")) return Style.colOrange
        return Style.colBlue
    }

    function doPlayPause() {
        if (!root.activePlayer) return
        root.isPlaying ? root.activePlayer.pause() : root.activePlayer.play()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                width: 44; height: 44
                radius: 6
                color: Style.colBg03
                border.color: Style.colBorder02
                border.width: 1
                clip: true

                Rectangle {
                    anchors.fill: parent
                    color: Style.colBg03
                    radius: 6
                    visible: !root.hasArt || artImage.status !== Image.Ready

                    Text {
                        anchors.centerIn: parent
                        text: root.sourceIcon(root.sourceApp)
                        font { family: "Symbols Nerd Font Mono"; pixelSize: 22 }
                        color: root.hasPlayer ? root.sourceColor(root.sourceApp) : Style.colRivet
                        opacity: 0.6
                    }
                }

                Image {
                    id: artImage
                    anchors.fill: parent
                    source: root.activePlayer?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    visible: root.hasArt && status === Image.Ready
                    asynchronous: true
                    cache: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                Text {
                    Layout.fillWidth: true
                    text: root.trackTitle
                    color: Style.colWhite
                    font { pixelSize: 12; family: "Courier New"; bold: true }
                    elide: Text.ElideRight
                    opacity: root.hasPlayer ? 1.0 : 0.4
                }

                Text {
                    Layout.fillWidth: true
                    text: root.trackArtist
                    color: Style.colRivet
                    font { pixelSize: 10; family: "Courier New" }
                    elide: Text.ElideRight
                    visible: root.trackArtist !== ""
                }

                RowLayout {
                    spacing: 5

                    Text {
                        text: root.sourceIcon(root.sourceApp)
                        font { family: "Symbols Nerd Font Mono"; pixelSize: 11 }
                        color: root.hasPlayer ? root.sourceColor(root.sourceApp) : Style.colRivet
                    }
                    Text {
                        text: root.hasPlayer ? root.sourceApp : "no player"
                        color: Style.colHighlight
                        font { pixelSize: 10; family: "Courier New"; letterSpacing: 1 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            opacity: root.hasPlayer ? 1.0 : 0.25

            Text {
                text: root.fmtTime(root.position)
                color: Style.colHighlight
                font { pixelSize: 10; family: "Courier New" }
            }

            Item {
                Layout.fillWidth: true
                height: 12

                Rectangle {
                    id: trackBar
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 2
                    radius: 1
                    color: Style.colBg

                    Rectangle {
                        width: root.duration > 0
                               ? Math.round(parent.width * Math.min(1, root.position / root.duration))
                               : 0
                        height: parent.height
                        radius: 1
                        color: Style.colYellow
                    }

                    Rectangle {
                        x: root.duration > 0
                           ? Math.round((parent.width * Math.min(1, root.position / root.duration)) - 4)
                           : -4
                        anchors.verticalCenter: parent.verticalCenter
                        width: 8; height: 8; radius: 4
                        color: Style.colYellow
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    enabled: root.hasPlayer && root.duration > 0
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mouse => {
                        const pct = Math.max(0, Math.min(1, mouse.x / trackBar.width))
                        root.activePlayer.position = pct * root.duration
                    }
                }
            }

            Text {
                text: root.fmtTime(root.duration)
                color: Style.colHighlight
                font { pixelSize: 10; family: "Courier New" }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            Item { Layout.fillWidth: true }

            CtrlBtn {
                nfIcon: "\uf074"
                active: root.shuffleOn
                enabled: root.hasPlayer && (root.activePlayer?.shuffleSupported ?? false)
                onClicked: root.activePlayer.shuffle = !root.activePlayer.shuffle
            }

            Item { Layout.fillWidth: true }

            CtrlBtn {
                nfIcon: "\uf048"
                enabled: root.hasPlayer && (root.activePlayer?.canGoPrevious ?? false)
                onClicked: root.activePlayer.previous()
            }

            Item { Layout.fillWidth: true }

            Item {
                width: 36; height: 36

                HexShape {
                    anchors.fill: parent
                    filled:      true
                    fillColor:   playHover.containsMouse
                                 ? Qt.darker(Style.colYellow, 1.4)
                                 : (root.isPlaying ? Qt.darker(Style.colYellow, 1.8) : "transparent")
                    strokeColor: root.hasPlayer ? Style.colYellow : Style.colRivet
                    strokeWidth: 1.5
                    padding:     2
                    opacity:     root.hasPlayer ? 1.0 : 0.3
                    Behavior on fillColor   { ColorAnimation { duration: 120 } }
                    Behavior on strokeColor { ColorAnimation { duration: 120 } }
                }

                Text {
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: root.isPlaying ? 0 : 1
                    text: root.isPlaying ? "\uf04c" : "\uf04b"
                    font { family: "Symbols Nerd Font Mono"; pixelSize: 13 }
                    color: playHover.containsMouse ? Style.colWhite : Style.colYellow
                    Behavior on color { ColorAnimation { duration: 120 } }
                }

                MouseArea {
                    id: playHover
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: root.hasPlayer
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.doPlayPause()
                }
            }

            Item { Layout.fillWidth: true }

            CtrlBtn {
                nfIcon: "\uf051"
                enabled: root.hasPlayer && (root.activePlayer?.canGoNext ?? false)
                onClicked: root.activePlayer.next()
            }

            Item { Layout.fillWidth: true }

            CtrlBtn {
                nfIcon: root.loopState === MprisLoopState.Track ? "\uf021" : "\uf01e"
                active: root.loopState !== MprisLoopState.None
                enabled: root.hasPlayer && (root.activePlayer?.loopSupported ?? false)
                onClicked: {
                    if (!root.activePlayer) return
                    const s = root.activePlayer.loopState
                    if      (s === MprisLoopState.None)     root.activePlayer.loopState = MprisLoopState.Playlist
                    else if (s === MprisLoopState.Playlist) root.activePlayer.loopState = MprisLoopState.Track
                    else                                    root.activePlayer.loopState = MprisLoopState.None
                }
            }

            Item { Layout.fillWidth: true }
        }
    }

    component CtrlBtn: Item {
        width: 28; height: 28
        property string nfIcon: ""
        property bool   active: false
        signal clicked

        Text {
            anchors.centerIn: parent
            text: parent.nfIcon
            font { family: "Symbols Nerd Font Mono"; pixelSize: 15 }
            color: parent.active
                   ? Style.colYellow
                   : (btnArea.containsMouse && parent.enabled ? Style.colWhite : Style.colRivet)
            opacity: parent.enabled ? 1.0 : 0.25
            Behavior on color   { ColorAnimation { duration: 120 } }
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            width: 3; height: 3; radius: 2
            color: Style.colYellow
            visible: parent.active && parent.enabled
        }

        MouseArea {
            id: btnArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: parent.enabled
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }
}
