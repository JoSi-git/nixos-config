import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import ".."

FreezeScreen {
    id: root

    // --- Configuration ---
    property var activeScreen: null
    property var hyprlandMonitor: Hyprland.focusedMonitor
    property string tempPath
    property string cropPath

    property string mode: "region"
    property var modes: ["region", "window", "screen", "ocr", "lens"]
    property bool editorMode: Quickshell.env("HYPRQUICKFRAME_EDITOR") === "1"


    // --- Action Logic ---
    function executeAction(x, y, width, height) {
        // Ignore tiny accidental drags
        if (width < 10 || height < 10) {
            Qt.quit();
            return;
        }

        const scale = hyprlandMonitor.scale;
        const scaledX = Math.round(x * scale);
        const scaledY = Math.round(y * scale);
        const scaledWidth = Math.round(width * scale);
        const scaledHeight = Math.round(height * scale);

        root.visible = false;

        var cmd = "";
        const picturesDir = Quickshell.env("XDG_PICTURES_DIR") || (Quickshell.env("HOME") + "/Pictures/Screenshots");
        const now = new Date();
        const timestamp = Qt.formatDateTime(now, "yyyy-MM-dd_hh-mm-ss");
        const outputPath = `${picturesDir}/screenshot-${timestamp}.png`;
        const currentMode = root.mode;

        if (currentMode === "region" || currentMode === "window" || currentMode === "screen") {
            if (root.editorMode) {
                cmd = `magick "${tempPath}" -crop ${scaledWidth}x${scaledHeight}+${scaledX}+${scaledY} png:- | satty --filename - --output-filename "${outputPath}" --early-exit --init-tool brush`;
            } else {
                cmd = `magick "${tempPath}" -crop ${scaledWidth}x${scaledHeight}+${scaledX}+${scaledY} "${outputPath}" && wl-copy --type image/png < "${outputPath}" && notify-send -a "HyprQuickShot" -i "${outputPath}" -h string:image-path:"${outputPath}" "Screenshot Saved" "Saved to Pictures/Screenshots"`;
            }
        } else if (currentMode === "ocr") {
            cmd = `magick "${tempPath}" -crop ${scaledWidth}x${scaledHeight}+${scaledX}+${scaledY} - | tesseract - - -l eng | wl-copy && notify-send 'OCR Complete' 'Text copied to clipboard'`;
        } else if (currentMode === "lens") {
            const cropTimestamp = Date.now();
            const cropPath = Quickshell.cachePath(`snip-crop-${cropTimestamp}.png`);
            cmd = `magick "${tempPath}" -crop ${scaledWidth}x${scaledHeight}+${scaledX}+${scaledY} "${cropPath}" && imageLink=$(curl -sF files[]=@"${cropPath}" 'https://uguu.se/upload' | jq -r '.files[0].url') && xdg-open "https://lens.google.com/uploadbyurl?url=\${imageLink}" && rm "${cropPath}"`;
        }


        cmd += ` && rm "${tempPath}"`;
        actionProcess.command = ["sh", "-c", cmd];
        actionProcess.running = true;
    }


    // --- Lifecycle and Setup ---
    visible: false
    targetScreen: activeScreen

    property bool isInitialized: false

    function startCapture() {
        if (isInitialized || !hyprlandMonitor) return;

        isInitialized = true;
        const timestamp = Date.now();
        const path = Quickshell.cachePath(`screenshot-${timestamp}.png`);
        tempPath = path;
        captureProcess.command = ["grim", "-o", root.hyprlandMonitor.name, path];
        captureProcess.running = true;
    }

    Component.onCompleted: {
        startCapture();
    }

    onHyprlandMonitorChanged: {
        startCapture();
    }

    Process {
        id: captureProcess
        running: false
        onExited: showTimer.start()
    }

    Timer {
        id: showTimer
        interval: 50
        running: false
        repeat: false
        onTriggered: root.visible = true
    }

    Process {
        id: actionProcess
        running: false
        onExited: Qt.quit()
        stdout: StdioCollector { onStreamFinished: console.log(this.text) }
        stderr: StdioCollector { onStreamFinished: console.log(this.text) }
    }

    Connections {
        target: Hyprland
        enabled: activeScreen === null
        function onFocusedMonitorChanged() {
            const monitor = Hyprland.focusedMonitor;
            if (!monitor) return;
            for (const screen of Quickshell.screens) {
                if (screen.name === monitor.name)
                    activeScreen = screen;
            }
        }
    }


    // --- Shortcuts ---
    Shortcut { sequence: "Escape"; onActivated: () => { Quickshell.execDetached(["rm", tempPath]); Qt.quit(); } }
    Shortcut { sequence: "r"; onActivated: root.mode = "region" }
    Shortcut { sequence: "w"; onActivated: root.mode = "window" }
    Shortcut { sequence: "s"; onActivated: root.mode = "screen" }
    Shortcut { sequence: "o"; onActivated: root.mode = "ocr" }
    Shortcut { sequence: "l"; onActivated: root.mode = "lens" }



    // --- Selectors ---
    RegionSelector {
        id: regionSelector
        visible: root.mode === "region" || root.mode === "ocr" || root.mode === "lens"
        anchors.fill: parent
        onRegionSelected: (x, y, width, height) => executeAction(x, y, width, height)
    }

    WindowSelector {
        id: windowSelector
        visible: root.mode === "window"
        anchors.fill: parent
        monitor: root.hyprlandMonitor
        onRegionSelected: (x, y, width, height) => executeAction(x, y, width, height)
    }


    // --- UI Controls ---
    Rectangle {
        id: control
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        width: 450
        height: 50
        radius: height / 2
        color: Qt.rgba(0.15, 0.15, 0.15, 0.9)
        border.color: Qt.rgba(1, 1, 1, 0.15)
        border.width: 1

        Rectangle {
            id: highlight
            height: parent.height - 8
            width: (parent.width - 8) / root.modes.length
            y: 4
            radius: height / 2
            color: "#3478F6"
            x: 4 + (root.modes.indexOf(root.mode) * width)
            Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        }

        Row {
            anchors.fill: parent
            anchors.margins: 4
            Repeater {
                model: root.modes
                Item {
                    width: (control.width - 8) / root.modes.length
                    height: control.height - 8
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.mode = modelData;
                            if (modelData === "screen") {
                                executeAction(0, 0, root.targetScreen.width, root.targetScreen.height);
                            }
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: modelData.charAt(0).toUpperCase() + modelData.slice(1)
                        color: "white"
                        font.weight: root.mode === modelData ? Font.DemiBold : Font.Normal
                        font.pixelSize: 14
                    }
                }
            }
        }
    }
}
