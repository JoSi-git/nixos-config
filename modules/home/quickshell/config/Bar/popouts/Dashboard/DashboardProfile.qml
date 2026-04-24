import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import "../../.."

Item {
    id: root
    anchors.fill: parent

    property string username: ""

    Process {
        command: ["whoami"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.username = text.trim()
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth:  100
            Layout.preferredHeight: 87

            Shape {
                anchors.fill: parent
                antialiasing: true
                ShapePath {
                    fillColor: Style.colYellow
                    strokeColor: "transparent"
                    startX: 25;  startY: 0
                    PathLine { x: 75;  y: 0    }
                    PathLine { x: 100; y: 43.5 }
                    PathLine { x: 75;  y: 87   }
                    PathLine { x: 25;  y: 87   }
                    PathLine { x: 0;   y: 43.5 }
                    PathLine { x: 25;  y: 0    }
                }
            }

            Shape {
                anchors.fill: parent
                antialiasing: true
                ShapePath {
                    fillColor: Style.colBg
                    strokeColor: "transparent"
                    startX: 27;  startY: 3
                    PathLine { x: 73;  y: 3    }
                    PathLine { x: 97;  y: 43.5 }
                    PathLine { x: 73;  y: 84   }
                    PathLine { x: 27;  y: 84   }
                    PathLine { x: 3;   y: 43.5 }
                    PathLine { x: 27;  y: 3    }
                }
            }

            Image {
                anchors.centerIn: parent
                width: 94
                height: 81
                source: "../../assets/profile_hex.png"
                fillMode: Image.PreserveAspectCrop
                smooth: true
                antialiasing: true
            }
        }

        Item { Layout.preferredHeight: 12 }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 3

            Rectangle { width: 18; height: 1; color: Style.colHighlight }
            Rectangle { width: 6;  height: 1; color: Style.colHighlight; opacity: 0.55 }

            Item {
                width: 6; height: 7
                Shape {
                    anchors.fill: parent; antialiasing: true
                    ShapePath {
                        fillColor: Style.colHighlight; strokeColor: "transparent"
                        startX: 3; startY: 0
                        PathLine { x: 6; y: 1.75 } PathLine { x: 6; y: 5.25 }
                        PathLine { x: 3; y: 7    } PathLine { x: 0; y: 5.25 }
                        PathLine { x: 0; y: 1.75 } PathLine { x: 3; y: 0    }
                    }
                }
            }
            Item {
                width: 7; height: 8
                Shape {
                    anchors.fill: parent; antialiasing: true
                    ShapePath {
                        fillColor: Style.colHighlight; strokeColor: "transparent"
                        startX: 3.5; startY: 0
                        PathLine { x: 7;   y: 2 } PathLine { x: 7;   y: 6 }
                        PathLine { x: 3.5; y: 8 } PathLine { x: 0;   y: 6 }
                        PathLine { x: 0;   y: 2 } PathLine { x: 3.5; y: 0 }
                    }
                }
            }
            Item {
                width: 10; height: 11
                opacity: 0.8
                Shape {
                    anchors.fill: parent; antialiasing: true
                    ShapePath {
                        fillColor: Style.colYellow; strokeColor: "transparent"
                        startX: 5; startY: 0
                        PathLine { x: 10; y: 2.75 } PathLine { x: 10; y: 8.25 }
                        PathLine { x: 5;  y: 11   } PathLine { x: 0;  y: 8.25 }
                        PathLine { x: 0;  y: 2.75 } PathLine { x: 5;  y: 0    }
                    }
                }
            }
            Item {
                width: 7; height: 8
                Shape {
                    anchors.fill: parent; antialiasing: true
                    ShapePath {
                        fillColor: Style.colHighlight; strokeColor: "transparent"
                        startX: 3.5; startY: 0
                        PathLine { x: 7;   y: 2 } PathLine { x: 7;   y: 6 }
                        PathLine { x: 3.5; y: 8 } PathLine { x: 0;   y: 6 }
                        PathLine { x: 0;   y: 2 } PathLine { x: 3.5; y: 0 }
                    }
                }
            }
            Item {
                width: 6; height: 7
                Shape {
                    anchors.fill: parent; antialiasing: true
                    ShapePath {
                        fillColor: Style.colHighlight; strokeColor: "transparent"
                        startX: 3; startY: 0
                        PathLine { x: 6; y: 1.75 } PathLine { x: 6; y: 5.25 }
                        PathLine { x: 3; y: 7    } PathLine { x: 0; y: 5.25 }
                        PathLine { x: 0; y: 1.75 } PathLine { x: 3; y: 0    }
                    }
                }
            }

            Rectangle { width: 6;  height: 1; color: Style.colHighlight; opacity: 0.55 }
            Rectangle { width: 18; height: 1; color: Style.colHighlight }
        }

        Item { Layout.preferredHeight: 12 }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.username.length > 0
                  ? root.username.charAt(0).toUpperCase() + root.username.slice(1)
                  : ""
            color: Style.colWhite
            font.pixelSize: 20
            font.weight: Font.Bold
            font.letterSpacing: 3
        }
    }
}
