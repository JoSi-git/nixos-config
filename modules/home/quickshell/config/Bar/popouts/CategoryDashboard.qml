import QtQuick
import QtQuick.Layouts
import "../.."

Item {
    id: root
    anchors.fill: parent

    RowLayout {
        anchors.fill: parent
        spacing: 8

        ColumnLayout {
            Layout.preferredWidth: 200
            Layout.maximumWidth: 200
            Layout.minimumWidth: 200
            Layout.fillHeight: true
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                color: Style.colBg02
                radius: 8
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.colBg02
                radius: 8
            }
        }

        ColumnLayout {
            Layout.preferredWidth: 454
            Layout.maximumWidth: 454
            Layout.minimumWidth: 454
            Layout.fillHeight: true
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 163
                color: Style.colBg02
                radius: 8
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.colBg02
                radius: 8
            }
        }

        Rectangle {
            Layout.preferredWidth: 200
            Layout.maximumWidth: 200
            Layout.minimumWidth: 200
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
        }
    }
}
