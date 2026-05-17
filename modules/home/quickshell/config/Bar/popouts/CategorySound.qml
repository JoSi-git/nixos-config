import QtQuick
import QtQuick.Layouts
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
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundInputDevice {}
        }
        Rectangle {
            Layout.preferredWidth: 170
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundMaster {}
        }
        Rectangle {
            Layout.fillWidth: true
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
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundDeviceInfo {}
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundBalance {}
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            SoundTest {}
        }
    }
}
