import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../.."
import "Dashboard"

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
                DashboardProfile {}
            }

            Rectangle {
                id: badgesRect
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.colBg02
                radius: 8
                clip: true

                DashboardBadges {}

                ClippingWrapperRectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    color: "transparent"
                    width: 130
                    height: 130
                    radius: 8

                    Image {
                        source: "../assets/basalt01.png"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        verticalAlignment: Image.AlignBottom
                        horizontalAlignment: Image.AlignLeft
                    }
                }
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

                DashboardPlayer {}
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.colBg02
                radius: 8

                DashboardCalender {}
            }
        }

        Rectangle {
            Layout.preferredWidth: 200
            Layout.maximumWidth: 200
            Layout.minimumWidth: 200
            Layout.fillHeight: true
            color: Style.colBg02
            radius: 8
            clip: true

            DashboardNotification {}

            ClippingWrapperRectangle {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: "transparent"
                width: 140
                height: 140
                radius: 8

                Image {
                    source: "../assets/basalt02.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    
                }
            }
        }
    }
}