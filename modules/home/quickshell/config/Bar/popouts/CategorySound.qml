import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../.."
import "Sound"

Item {
    anchors.fill: parent

    RowLayout {
        id: topRow
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 215
        spacing: 8

        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundInputDevice {}
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundMaster {}
        }
        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundOutputDevice {}
        }
    }

    RowLayout {
        anchors { top: topRow.bottom; topMargin: 8; left: parent.left; right: parent.right; bottom: parent.bottom }
        spacing: 8

        Rectangle {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            clip: true

            SoundDeviceInfo {}

            ClippingWrapperRectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: -20
                color: "transparent"
                width: 175
                height: 175
                radius: 8

                Image {
                    source: "../assets/basalt03.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    verticalAlignment: Image.AlignBottom
                    horizontalAlignment: Image.AlignLeft
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundBalance {}
        }
        Rectangle {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            clip: true

            SoundTest {}

            ClippingWrapperRectangle {
                anchors.bottom: parent.bottom

                anchors.right: parent.right
                color: "transparent"
                width: 130
                height: 130
                radius: 8

                Image {
                    source: "../assets/basalt04.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    verticalAlignment: Image.AlignBottom
                    horizontalAlignment: Image.AlignRight
                }
            }
        }
    }
}
