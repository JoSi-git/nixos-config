import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../.."

Item {
    id: root
    anchors.fill: parent

    readonly property var appIconMap: ({
        "firefox":          "\udb80",
        "chrome":           "\uf268",
        "discord":          "\uf1ff",
        "spotify":          "\uf1bc",
        "thunderbird":      "\uf370",
        "kitty":            "\uf120",
        "system":           "\uf013",
        "network":          "\uef09",
        "battery":          "\uf240",
        "hyprquickframe":   "\uf03e"
    })

    function resolveAppIcon(appName) {
        const name = (appName ?? "").toLowerCase()
        for (const key of Object.keys(appIconMap))
            if (name.includes(key)) return appIconMap[key]
        return "\uf05a"
    }

    function formatTimestamp(notif) {
        if (!notif) return ""
        const raw = notif.time ?? notif.timestamp ?? null
        if (!raw) return ""
        const d = (raw instanceof Date) ? raw : new Date(raw)
        if (isNaN(d)) return ""
        const diffMin = Math.floor((new Date() - d) / 60000)
        if (diffMin < 1)  return "gerade eben"
        if (diffMin < 60) return diffMin + " min"
        const diffH = Math.floor(diffMin / 60)
        if (diffH < 24)   return diffH + " h"
        return d.toLocaleDateString([], { day: "2-digit", month: "2-digit" })
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.bottomMargin: 10

            Text {
                text: "NOTIFICATIONS"
                color: Style.colYellow
                font { pixelSize: 13; family: "Courier New"; bold: true; letterSpacing: 2 }
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Item {
                width: 24; height: 24
                HoverHandler { id: clearHover }
                TapHandler {
                    onTapped: {
                        for (let i = 0; i < rootqs.notifications.count; i++)
                            rootqs.notifications.get(i).notif.dismiss()
                    }
                }

                HexShape {
                    anchors.fill: parent
                    filled:      true
                    fillColor:   clearHover.hovered ? Qt.darker(Style.colOrange, 2.5) : "transparent"
                    strokeColor: clearHover.hovered ? Style.colOrange : "transparent"
                    strokeWidth: 1.2
                    padding:     1.5
                    Behavior on fillColor   { ColorAnimation { duration: 120 } }
                    Behavior on strokeColor { ColorAnimation { duration: 120 } }
                }

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: clearHover.hovered ? Style.colOrange : Style.colRivet
                    font { pixelSize: 14; family: "Courier New" }
                    renderType: Text.NativeRendering
                    Behavior on color { ColorAnimation { duration: 120 } }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                anchors.top: parent.top
                anchors.topMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8
                visible: rootqs.notifications.count === 0

                HexShape {
                    width: 24; height: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    filled:      false
                    strokeColor: Style.colRivet
                    strokeWidth: 1.0
                    padding:     2.0
                    opacity:     0.4
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "no notifications"
                    color: Style.colRivet
                    font { pixelSize: 10; family: "Courier New"; letterSpacing: 1 }
                    opacity: 0.5
                }
            }

            ListView {
                anchors.fill: parent
                model: rootqs.notifications
                spacing: 6
                clip: true
                delegate: NotifCard {
                    required property var model
                    notif: model.notif
                    width: ListView.view.width
                }
            }
        }
    }

    component NotifCard: Item {
        id: card
        property var notif
        height: cardCol.implicitHeight + 16

        property color accentColor: {
            if (!notif) return Style.colRivet
            switch (notif.urgency) {
                case 2:  return Style.colRed
                case 1:  return Style.colBlue
                default: return Style.colRivet
            }
        }

        HoverHandler { id: cardHover }

        Rectangle {
            anchors.fill: parent
            radius: 5
            color: cardHover.hovered ? Qt.lighter(Style.colBg03, 1.2) : Style.colBg03
            Behavior on color { ColorAnimation { duration: 120 } }
        }

        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom; topMargin: 5; bottomMargin: 5 }
            width: 2; radius: 1
            color: card.accentColor
            opacity: 0.9
        }

        ColumnLayout {
            id: cardCol
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 10; rightMargin: 8 }
            spacing: 3

            RowLayout {
                Layout.fillWidth: true
                spacing: 5

                Text {
                    text: root.resolveAppIcon(card.notif?.appName)
                    color: card.accentColor
                    font { pixelSize: 14; family: "Symbols Nerd Font Mono" }
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 18
                }

                Text {
                    text: (card.notif?.appName ?? "unknown").toLowerCase()
                    color: Style.colBlue
                    font { pixelSize: 10; family: "Courier New"; letterSpacing: 1 }
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    text: root.formatTimestamp(card.notif)
                    color: Style.colRivet
                    font { pixelSize: 9; family: "Courier New" }
                    opacity: 0.6
                    Layout.alignment: Qt.AlignVCenter
                    visible: text !== ""
                }

                Item {
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    Layout.alignment: Qt.AlignVCenter
                    HoverHandler { id: dismissHover }
                    TapHandler   { onTapped: card.notif?.dismiss() }

                    HexShape {
                        anchors.fill: parent
                        filled:      true
                        fillColor:   dismissHover.hovered ? Qt.darker(Style.colOrange, 2.5) : "transparent"
                        strokeColor: dismissHover.hovered ? Style.colOrange : "transparent"
                        strokeWidth: 1.0
                        padding:     1.0
                        Behavior on fillColor   { ColorAnimation { duration: 100 } }
                        Behavior on strokeColor { ColorAnimation { duration: 100 } }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: dismissHover.hovered ? Style.colOrange : Style.colRivet
                        font { pixelSize: 14; family: "Courier New" }
                        renderType: Text.NativeRendering
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: card.notif?.summary ?? ""
                color: Style.colWhite
                font { pixelSize: 11; family: "Courier New"; bold: true }
                elide: Text.ElideRight
                visible: text !== ""
            }

            Text {
                Layout.fillWidth: true
                text: card.notif?.body ?? ""
                color: Style.colRivet
                font { pixelSize: 10; family: "Courier New" }
                wrapMode: Text.WordWrap
                maximumLineCount: 3
                elide: Text.ElideRight
                visible: text !== ""
            }

            Flow {
                Layout.fillWidth: true
                spacing: 4
                visible: (card.notif?.actions ?? []).length > 0

                Repeater {
                    model: card.notif?.actions ?? []
                    delegate: Item {
                        id: actionItem
                        required property var modelData
                        width:  actionLabel.implicitWidth + 16
                        height: 18
                        HoverHandler { id: actionHover }
                        TapHandler   { onTapped: actionItem.modelData.invoke() }

                        Rectangle {
                            anchors.fill: parent
                            radius: 3
                            color:        actionHover.hovered ? Qt.darker(card.accentColor, 2.8) : "transparent"
                            border.color: actionHover.hovered ? card.accentColor : Style.colBg03
                            border.width: 1
                            Behavior on color        { ColorAnimation { duration: 100 } }
                            Behavior on border.color { ColorAnimation { duration: 100 } }
                        }

                        Text {
                            id: actionLabel
                            anchors.centerIn: parent
                            text: actionItem.modelData.identifier === "default"
                                  ? "open"
                                  : actionItem.modelData.identifier.toLowerCase()
                            color: actionHover.hovered ? card.accentColor : Style.colRivet
                            font { pixelSize: 9; family: "Courier New"; letterSpacing: 0.5 }
                            Behavior on color { ColorAnimation { duration: 100 } }
                        }
                    }
                }
            }
        }
    }
}
