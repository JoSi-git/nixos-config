/*
 * Copyright (c) 2026 Ronin-CK
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    property var hyprlandMonitor: Hyprland.focusedMonitor
    property string activeScreenName: hyprlandMonitor ? hyprlandMonitor.name : (Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "")
    property string mode: "region"
    property var modes: ["edit", "region", "window", "ocr", "lens", "temp"]
    property bool tempActive: false
    property bool editActive: false
    property bool shareActive: false
    property bool capturing: false
    property bool overlaysVisible: true
    property string lastSavedPath: ""
    property string lastTimestamp: ""
    property string _pendingCmd: ""
    property int connectivityStatus: 0
    property var theme: themeObj
    readonly property real tabItemSize: 100
    readonly property real controlHeight: 50
    readonly property real targetMenuWidth: (modes.length - (editActive ? 1 : 0) - (tempActive ? 1 : 0)) * tabItemSize + 8

    function parseTOML(text) {
        let result = {};
        let section = "";
        const lines = text.split(/\r?\n/);
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            if (!line || line.startsWith("#")) continue;
            const secMatch = line.match(/^\[(\w+)\]$/);
            if (secMatch) { section = secMatch[1]; continue; }
            const quotedMatch = line.match(/^(\w+)\s*=\s*"([^"]*)"/);
            if (quotedMatch) {
                const rawKey = quotedMatch[1];
                const key = section ? section + rawKey.charAt(0).toUpperCase() + rawKey.slice(1) : rawKey;
                result[key] = quotedMatch[2];
                continue;
            }
            const unquotedMatch = line.match(/^(\w+)\s*=\s*([^\s#]+)/);
            if (unquotedMatch) {
                const rawKey = unquotedMatch[1];
                const key = section ? section + rawKey.charAt(0).toUpperCase() + rawKey.slice(1) : rawKey;
                let val = unquotedMatch[2];
                if (val === "true") val = true;
                else if (val === "false") val = false;
                else { const num = parseFloat(val); if (!isNaN(num)) val = num; }
                result[key] = val;
            }
        }
        return result;
    }

    function shellEscape(s) {
        return "'" + s.replace(/'/g, "'\\''") + "'";
    }

    function grimGeometry(x, y, width, height) {
        let target = null;
        const monitors = Hyprland.monitors.values;
        for (const m of monitors) {
            if (m && m.name === hyprlandMonitor.name) { target = m; break; }
        }
        if (!target) target = hyprlandMonitor;
        const mx = target.lastIpcObject.x;
        const my = target.lastIpcObject.y;
        return `${Math.round(x + mx)},${Math.round(y + my)} ${Math.round(width)}x${Math.round(height)}`;
    }

    function runPostSaveHook() {
        const hook = theme.postSaveHook;
        if (!hook || !root.lastSavedPath) return;
        const filePath = root.lastSavedPath;
        const fileName = filePath.substring(filePath.lastIndexOf('/') + 1);
        const dirPath = filePath.substring(0, filePath.lastIndexOf('/'));
        let cmd = hook;
        cmd = cmd.replace(/%f/g, shellEscape(filePath));
        cmd = cmd.replace(/%n/g, shellEscape(fileName));
        cmd = cmd.replace(/%d/g, shellEscape(dirPath));
        cmd = cmd.replace(/%t/g, shellEscape(root.lastTimestamp));
        Quickshell.execDetached(["sh", "-c", cmd]);
    }

    function saveScreenshot(x, y, width, height) {
        const geom = grimGeometry(x, y, width, height);
        const picturesBase = Quickshell.env("XDG_PICTURES_DIR") || (Quickshell.env("HOME") + "/Pictures");
        const picturesDir = picturesBase + "/Screenshots";
        const timestamp = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss");
        const outputPath = `${picturesDir}/screenshot-${timestamp}.png`;
        const ePicturesDir = shellEscape(picturesDir);
        const eOutputPath = shellEscape(outputPath);
        const eGeom = shellEscape(geom);

        root.lastTimestamp = timestamp;
        root.lastSavedPath = root.tempActive ? "" : outputPath;

        const grimRegion = `timeout 5 grim -l 1 -g ${eGeom}`;
        const shareCmd = "kdeconnect-cli -l | grep 'reachable' | grep -oP '[a-f0-9-]{8,}'"
            + " | head -1 | xargs -I{} sh -c"
            + " 'kdeconnect-cli -d {} --share \"$1\" && sleep 0.2"
            + " && kdeconnect-cli -d {} --send-clipboard' --";
        const maybeShare = (escapedPath) => root.shareActive ? ` && ${shareCmd} ${escapedPath}` : "";
        const shareTag = root.shareActive ? " & phone" : "";
        const mkdirCmd = `mkdir -p ${ePicturesDir}`;

        const sattyCommand =
            `${mkdirCmd} && ${grimRegion} - `
            + `| satty --filename - --output-filename ${eOutputPath} --early-exit --init-tool brush --copy-command "wl-copy --type image/png" `
            + `; if [ -f ${eOutputPath} ]; then wl-copy --type image/png < ${eOutputPath}${maybeShare(eOutputPath)}; fi`;
        const defaultSaveCommand =
            `${mkdirCmd} && ${grimRegion} ${eOutputPath} `
            + `&& wl-copy --type image/png < ${eOutputPath}`
            + `${maybeShare(eOutputPath)} `
            + `&& notify-send -a "HyprQuickFrame" -i ${eOutputPath} `
            + `-h string:image-path:${eOutputPath} "Screenshot Saved" `
            + `"Saved to ${picturesDir}"`;
        const eTempSnip = shellEscape(Quickshell.cachePath(`snip-${timestamp}.png`));
        const tempShareCommand =
            `${grimRegion} ${eTempSnip} `
            + `&& wl-copy --type image/png < ${eTempSnip}`
            + `${maybeShare(eTempSnip)} `
            + `&& notify-send -a "HyprQuickFrame" "Screenshot Copied" "Copied to clipboard${shareTag}"; `
            + `rm -f ${eTempSnip}`;
        const tempPlainCommand =
            `${grimRegion} - | wl-copy --type image/png `
            + `&& notify-send -a "HyprQuickFrame" "Screenshot Copied" "Copied to clipboard"`;
        const defaultTempCommand = root.shareActive ? tempShareCommand : tempPlainCommand;

        const ocrPipeline = [
            `${grimRegion} -`,
            `tesseract - - -l eng`,
            `awk 'BEGIN{RS=""; FS="\\n"; ORS="\\n\\n"} {for(i=1;i<=NF;i++){printf "%s",$i; if(i<NF)printf " "} printf "\\n"}'`,
            `sed 's/  */ /g; s/[[:space:]]*$//'`,
            `wl-copy`
        ].join(" | ");
        const ocrCommand = `${ocrPipeline} && notify-send 'OCR Complete' 'Text copied to clipboard'`;

        const ts2 = Date.now();
        const cropJpg = Quickshell.cachePath(`snip-crop-${ts2}.jpg`);
        const lensHtml = Quickshell.cachePath(`snip-lens-${ts2}.html`);
        const eCropJpg = shellEscape(cropJpg);
        const eLensHtml = shellEscape(lensHtml);
        const buildHtml = [
            `echo '<html><body style="margin:0;display:flex;justify-content:center;align-items:center;height:100vh;background:#111;color:#fff;font-family:system-ui"><p>Searching with Google Lens…</p><form id="f" method="POST" enctype="multipart/form-data" action="https://lens.google.com/v3/upload"></form><script>'`,
            `echo "var b=atob('$B64');"`,
            `echo 'var a=new Uint8Array(b.length);for(var i=0;i<b.length;i++)a[i]=b.charCodeAt(i);var d=new DataTransfer();d.items.add(new File([a],"i.jpg",{type:"image/jpeg"}));var inp=document.createElement("input");inp.type="file";inp.name="encoded_image";inp.files=d.files;document.getElementById("f").appendChild(inp);document.getElementById("f").submit();'`,
            `echo '</script></body></html>'`
        ].join(" ; ");
        const lensCommand = [
            `${grimRegion} - | magick - -resize '1000x1000>' -strip -quality 85 ${eCropJpg}`,
            `B64=$(base64 -w0 ${eCropJpg})`,
            `{ ${buildHtml} ; } > ${eLensHtml}`,
            `xdg-open ${eLensHtml}`
        ].join(" && ");

        let cmd;
        if (root.mode === "ocr")
            cmd = ocrCommand;
        else if (root.mode === "lens")
            cmd = lensCommand;
        else if (root.editActive)
            cmd = sattyCommand;
        else if (root.tempActive)
            cmd = defaultTempCommand;
        else
            cmd = defaultSaveCommand;

        root._pendingCmd = cmd;
        root.capturing = true;
        captureDelayTimer.start();

        if (root.editActive)
            hideOverlaysTimer.start();
    }

    Theme {
        id: themeObj
    }

    FileView {
        id: themeFile

        property string configHome: Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")
        property string userPath1: configHome + "/hyprquickframe/theme.toml"
        property string userPath2: configHome + "/quickshell/HyprQuickFrame/theme.toml"
        property string defaultPath: Quickshell.shellDir.toString().replace(/^file:\/\//, "") + "/theme.toml"

        path: defaultPath
        Component.onCompleted: {
            themePathCheck.command = ["sh", "-c", `if [ -f "${userPath1}" ]; then echo "${userPath1}";
                 elif [ -f "${userPath2}" ]; then echo "${userPath2}";
                 else echo "${defaultPath}"; fi`];
            themePathCheck.running = true;
        }
        onTextChanged: {
            try {
                let rawText = (typeof text === 'function') ? text() : text;
                themeObj.source = root.parseTOML(rawText);
            } catch (e) {
                console.warn("Failed to parse theme.toml:", e);
            }
        }
    }

    Process {
        id: themePathCheck

        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                themeFile.path = this.text.trim();
                console.log("Theme loaded from:", themeFile.path);
            }
        }
    }

    Timer {
        id: captureDelayTimer
        interval: 100
        repeat: false
        onTriggered: {
            screenshotProcess.command = ["sh", "-c", root._pendingCmd];
            screenshotProcess.running = true;
        }
    }

    Timer {
        id: hideOverlaysTimer
        interval: 300
        repeat: false
        onTriggered: root.overlaysVisible = false
    }

    Timer {
        id: readyWatchdog
        interval: 4000
        repeat: false
        onTriggered: {
            for (const w of overlayVariants.instances) {
                if (w && w.isReady) return;
            }
            console.error("HyprQuickShot: screencopy never produced a frame; exiting.");
            Qt.quit();
        }
    }

    Process {
        id: screenshotProcess

        running: false
        onExited: (code) => {
            if (code !== 0)
                console.error("Screenshot pipeline failed with exit code:", code);
            else
                root.runPostSaveHook();
            Qt.quit();
        }
        stdout: StdioCollector {
            onStreamFinished: { if (this.text.trim()) console.log(this.text); }
        }
        stderr: StdioCollector {
            onStreamFinished: { if (this.text.trim()) console.warn(this.text); }
        }
    }

    Process {
        id: connectivityProcess

        command: ["sh", "-c", "timeout 5 kdeconnect-cli -l | grep 'reachable'"]
        onExited: (code) => {
            root.connectivityStatus = (code === 0 ? 1 : 2);
        }
    }

    Variants {
        id: overlayVariants
        model: Quickshell.screens

        FreezeScreen {
            id: overlay

            required property var modelData
            property bool isFocused: modelData.name === root.activeScreenName

            targetScreen: modelData
            visible: root.overlaysVisible

            Component.onCompleted: {
                if (isFocused)
                    connectivityProcess.running = true;
                readyWatchdog.start();
            }

            ShaderEffect {
                visible: !overlay.isFocused && overlay.isReady && root.overlaysVisible
                anchors.fill: parent
                z: 0
                property vector4d selectionRect: Qt.vector4d(0, 0, 0, 0)
                property real dimOpacity: root.theme.dimOpacity
                property vector2d screenSize: Qt.vector2d(width, height)
                property real borderRadius: 0
                property real outlineThickness: 0
                fragmentShader: Qt.resolvedUrl("dimming.frag.qsb")
            }

            RegionSelector {
                id: regionSelector

                visible: overlay.isFocused && (root.mode === "region" || root.mode === "ocr" || root.mode === "lens") && overlay.isReady && !root.capturing
                anchors.fill: parent
                dimOpacity: root.theme.dimOpacity
                borderRadius: root.theme.borderRadius
                outlineThickness: root.theme.outlineThickness
                globalAnimations: root.theme.animations
                onRegionSelected: (x, y, width, height) => root.saveScreenshot(x, y, width, height)
            }

            WindowSelector {
                id: windowSelector

                visible: overlay.isFocused && root.mode === "window" && overlay.isReady && !root.capturing
                anchors.fill: parent
                monitor: root.hyprlandMonitor
                dimOpacity: root.theme.dimOpacity
                borderRadius: root.theme.borderRadius
                outlineThickness: root.theme.outlineThickness
                animateSelection: root.theme.animations
                onRegionSelected: (x, y, width, height) => root.saveScreenshot(x, y, width, height)
            }

            Rectangle {
                id: segmentedControl

                visible: overlay.isFocused && overlay.isReady && !root.capturing
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: root.theme.bottomMargin
                height: root.controlHeight
                width: root.targetMenuWidth
                radius: height / 2
                color: root.theme.barBackground
                border.color: root.theme.barBorder
                border.width: 1

                Rectangle {
                    id: highlight

                    width: root.tabItemSize
                    height: parent.height - 8
                    y: 4
                    radius: height / 2
                    color: root.theme.accent
                    x: 4 + (root.modes.slice(0, root.modes.indexOf(root.mode)).filter((m) => {
                        if (m === "edit") return !root.editActive;
                        if (m === "temp") return !root.tempActive;
                        return true;
                    }).length * root.tabItemSize)

                    Behavior on x {
                        SpringAnimation { spring: 4; damping: 0.25; mass: 1 }
                    }
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 4

                    Repeater {
                        model: root.modes

                        Item {
                            id: tabItem

                            property bool isTemp: modelData === "temp"
                            property bool isEdit: modelData === "edit"
                            property bool isDisabled: (isEdit || isTemp) && (root.mode === "ocr" || root.mode === "lens")
                            property bool collapsed: (isTemp && root.tempActive) || (isEdit && root.editActive)

                            width: collapsed ? 0 : root.tabItemSize
                            height: segmentedControl.height - 8
                            visible: width > 0

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: !isDisabled
                                cursorShape: isDisabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                                enabled: !isDisabled
                                onClicked: {
                                    if (modelData === "temp") {
                                        root.tempActive = true;
                                        root.editActive = false;
                                    } else if (modelData === "edit") {
                                        root.editActive = true;
                                        root.tempActive = false;
                                    } else {
                                        root.mode = modelData;
                                        root.tempActive = false;
                                        root.editActive = false;
                                    }
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: {
                                    const icons = { "region": "󰒉", "window": "󱂬", "temp": "󰅇", "edit": "󰏫", "ocr": "󰈙", "lens": "󰍉" };
                                    const labels = { "region": "Region", "window": "Window", "temp": "Temp", "edit": "Edit", "ocr": "OCR", "lens": "Lens" };
                                    return icons[modelData] + "  " + labels[modelData];
                                }
                                color: tabItem.isDisabled ? "#555555" : ((modelData === "temp" || modelData === "edit") ? root.theme.barText : (root.mode === modelData ? root.theme.accentText : root.theme.barText))
                                font.weight: (modelData === "temp" || modelData === "edit") ? Font.Medium : (root.mode === modelData ? Font.Bold : Font.Medium)
                                font.pixelSize: 15
                                opacity: tabItem.collapsed ? 0 : 1

                                Behavior on opacity {
                                    enabled: root.tempActive || root.editActive
                                    NumberAnimation { duration: 150 }
                                }
                            }

                            Behavior on width {
                                SpringAnimation { spring: 4; damping: 0.25; mass: 1 }
                            }
                        }
                    }
                }

                Behavior on width {
                    SpringAnimation { spring: 4; damping: 0.25; mass: 1 }
                }
            }

            QuickToggle {
                id: editToggleButton

                active: root.editActive
                disabled: root.mode === "ocr" || root.mode === "lens"
                visible: overlay.isFocused && !(root.mode === "ocr" || root.mode === "lens") && overlay.isReady && !root.capturing
                icon: "󰏫"
                iconColor: root.theme.toggleEdit
                backgroundColor: root.theme.toggleBackground
                shadowColor: root.theme.toggleShadow
                targetX: (overlay.width - root.targetMenuWidth) / 2 - 15 - width
                targetY: segmentedControl.y + segmentedControl.height / 2
                sourceX: overlay.width / 2 - 204 + 32
                onClicked: root.editActive = false
            }

            QuickToggle {
                id: tempToggleButton

                active: root.tempActive
                disabled: root.mode === "ocr" || root.mode === "lens"
                visible: overlay.isFocused && !(root.mode === "ocr" || root.mode === "lens") && overlay.isReady && !root.capturing
                icon: "󰅇"
                iconColor: root.theme.toggleTemp
                backgroundColor: root.theme.toggleBackground
                shadowColor: root.theme.toggleShadow
                targetX: (overlay.width + root.targetMenuWidth) / 2 + 15
                targetY: segmentedControl.y + segmentedControl.height / 2
                sourceX: overlay.width / 2 - 204 + 332
                onClicked: root.tempActive = false
            }

            QuickToggle {
                id: shareToggleButton

                visible: overlay.isFocused && overlay.isReady && !root.capturing
                active: root.shareActive
                icon: "󰄜"
                iconColor: {
                    if (root.connectivityStatus === 1) return root.theme.shareConnected;
                    if (root.connectivityStatus === 2) return root.theme.shareErrorIcon;
                    return root.theme.sharePending;
                }
                backgroundColor: root.connectivityStatus === 2 ? root.theme.shareErrorBackground : root.theme.toggleBackground
                shadowColor: root.theme.toggleShadow
                pulse: root.connectivityStatus === 0
                targetX: (overlay.width + root.targetMenuWidth) / 2 + 15 + (root.tempActive ? 44 + 10 : 0)
                targetY: segmentedControl.y + segmentedControl.height / 2
                sourceX: overlay.width / 2 + (root.targetMenuWidth / 2) - 22
                onClicked: root.shareActive = false
            }

            Item {
                visible: overlay.isFocused && overlay.isReady && !root.capturing
                anchors.fill: parent
                z: 999

                HoverHandler {
                    onPointChanged: {
                        if ((root.mode === "region" || root.mode === "ocr" || root.mode === "lens") && !regionSelector.pressed) {
                            regionSelector.mouseX = point.position.x;
                            regionSelector.mouseY = point.position.y;
                        }
                        if (root.mode === "window" && !windowSelector.pressed) {
                            windowSelector.mouseX = point.position.x;
                            windowSelector.mouseY = point.position.y;
                        }
                    }
                }
            }

            Shortcut {
                sequences: ["Escape", "q"]
                onActivated: Qt.quit()
            }

            Shortcut {
                sequence: "r"
                onActivated: root.mode = "region"
            }

            Shortcut {
                sequence: "w"
                onActivated: root.mode = "window"
            }

            Shortcut {
                sequence: "o"
                onActivated: root.mode = "ocr"
            }

            Shortcut {
                sequence: "l"
                onActivated: root.mode = "lens"
            }

            Shortcut {
                sequence: "s"
                onActivated: root.saveScreenshot(0, 0, overlay.width, overlay.height)
            }

            Shortcut {
                sequence: "e"
                onActivated: {
                    root.editActive = !root.editActive;
                    if (root.editActive) root.tempActive = false;
                }
            }

            Shortcut {
                sequence: "t"
                onActivated: {
                    root.tempActive = !root.tempActive;
                    if (root.tempActive) root.editActive = false;
                }
            }

            Shortcut {
                sequence: "k"
                onActivated: {
                    root.shareActive = !root.shareActive;
                    if (root.shareActive && !connectivityProcess.running && root.connectivityStatus !== 0)
                        connectivityProcess.running = true;
                }
            }
        }
    }
}
