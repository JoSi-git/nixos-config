import QtQuick 2.15

// The main element for the Bar content
Rectangle {
    implicitWidth: 200
    implicitHeight: 35
    color: "transparent"

    Text {
        id: welcomeText
        text: "Hello from Quickshell"
        color: "#ff0000"
        font.pixelSize: 18
        anchors.centerIn: parent
    }
}
