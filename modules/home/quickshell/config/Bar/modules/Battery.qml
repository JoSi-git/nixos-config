import QtQuick
import Quickshell.Services.UPower
import ".."
import "../.."

HexPanel {
    Row {
        id: batteryModule
        spacing: 0
        
        readonly property var device: UPower.displayDevice
        readonly property bool isPlugged: device.state === 1 || device.state === 4
    
        readonly property int displayPercentage: {
            if (!device || device.percentage === undefined) return 0;
            let p = device.percentage;
            return (p <= 1.0 && p > 0) ? Math.round(p * 100) : Math.round(p);
        }
    
        readonly property bool showPercentage: displayPercentage < 100

        Item {
            width: 22
            height: 24
    
            Text {
                id: batteryIcon
                anchors.centerIn: parent
                text: batteryModule.isPlugged ? "" : (
                    batteryModule.displayPercentage <= 20 ? " " : 
                    batteryModule.displayPercentage <= 40 ? " " : 
                    batteryModule.displayPercentage <= 60 ? " " : 
                    batteryModule.displayPercentage <= 80 ? " " : " "
                )
                font.family: "Symbols Nerd Font Mono"
                font.pixelSize: 17
                
                color: {
                    if (batteryModule.isPlugged) return Style.colYellow;
                    if (batteryModule.displayPercentage <= 20) return Style.colRed;
                    if (batteryModule.displayPercentage <= 50) return Style.colYellow;
                    return Style.colGreen;
                }
            }
        }

        Text {
            id: batteryPercentageText
            text: batteryModule.displayPercentage + "%"
            color: Style.colWhite
            font.pixelSize: 18
            font.bold: true
            leftPadding: 2
            visible: batteryModule.showPercentage
        }
    }
}
