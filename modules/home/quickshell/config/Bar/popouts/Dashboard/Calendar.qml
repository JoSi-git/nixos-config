import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import "../../components"
import "../../.."

Item {
    id: root
    anchors.fill: parent

    component HexNavButton: Item {
        id: navBtn
        property string label: "›"
        signal clicked()

        width: 28; height: 24

        HoverHandler { id: navHover }
        TapHandler   { onTapped: navBtn.clicked() }

        layer.enabled: true
        layer.samples: 8

        Shape {
            anchors.fill: parent
            antialiasing: true
            ShapePath {
                fillColor:   navHover.hovered ? Qt.lighter(Style.colBg03, 1.6) : Style.colBg03
                strokeColor: navHover.hovered ? Style.colYellow : Qt.darker(Style.colYellow, 1.8)
                strokeWidth: 1.2
                startX: 7;  startY: 1
                PathLine { x: 21; y: 1  }
                PathLine { x: 27; y: 12 }
                PathLine { x: 21; y: 23 }
                PathLine { x: 7;  y: 23 }
                PathLine { x: 1;  y: 12 }
                PathLine { x: 7;  y: 1  }
            }
        }

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -1
            text: navBtn.label
            color: navHover.hovered ? Style.colYellow : Qt.darker(Style.colYellow, 1.4)
            font.pixelSize: 17
            font.family: "Courier New"
            font.bold: true
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    Process {
        id: thunderbirdProcess
        running: false
        command: ["thunderbird", "-calendar"]
    }

    readonly property var todayDate: new Date()
    property int curYear:            todayDate.getFullYear()
    property int curMonth:           todayDate.getMonth()
    property int selectedDay:        -1

    readonly property var monthNames: [
        "JANUAR","FEBRUAR","MÄRZ","APRIL","MAI","JUNI",
        "JULI","AUGUST","SEPTEMBER","OKTOBER","NOVEMBER","DEZEMBER"
    ]

    readonly property var calCells:       buildCells()
    readonly property int numWeeks:       calCells.length / 7
    readonly property int todayWeekIndex: getTodayWeekIndex(calCells)

    function buildCells() {
        let cells      = []
        let firstDow   = new Date(curYear, curMonth, 1).getDay()
        let startDow   = firstDow === 0 ? 6 : firstDow - 1
        let daysInMonth = new Date(curYear, curMonth + 1, 0).getDate()
        let prevStart  = new Date(curYear, curMonth, 0).getDate() - startDow + 1

        for (let i = 0; i < startDow; i++)
            cells.push({ d: prevStart + i, type: "prev" })
        for (let d = 1; d <= daysInMonth; d++)
            cells.push({ d: d, type: "cur" })
        let nd = 1
        while (cells.length % 7 !== 0)
            cells.push({ d: nd++, type: "next" })
        return cells
    }

    function getTodayWeekIndex(cells) {
        if (curYear !== todayDate.getFullYear() || curMonth !== todayDate.getMonth()) return -1
        for (let i = 0; i < cells.length; i++)
            if (cells[i].type === "cur" && cells[i].d === todayDate.getDate())
                return Math.floor(i / 7)
        return -1
    }

    function goToToday() {
        curYear     = todayDate.getFullYear()
        curMonth    = todayDate.getMonth()
        selectedDay = -1
    }

    function prevMonth() {
        if (curMonth === 0) { curMonth = 11; curYear-- } else curMonth--
        selectedDay = -1
    }

    function nextMonth() {
        if (curMonth === 11) { curMonth = 0; curYear++ } else curMonth++
        selectedDay = -1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            HexNavButton { label: "‹"; onClicked: root.prevMonth() }

            Item { Layout.fillWidth: true }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignVCenter

                HexShape {
                    width: 10; height: 10
                    Layout.alignment: Qt.AlignVCenter
                    filled:      false
                    strokeColor: Qt.darker(Style.colYellow, 1.6)
                    strokeWidth: 1.0
                    padding:     1.0
                }

                Text {
                    text: root.monthNames[root.curMonth] + "   " + root.curYear
                    color: Style.colYellow
                    font.pixelSize: 16
                    font.bold: true
                    font.family: "Courier New"
                    font.letterSpacing: 2
                    Layout.alignment: Qt.AlignVCenter
                    TapHandler { onTapped: root.goToToday() }
                }

                HexShape {
                    width: 10; height: 10
                    Layout.alignment: Qt.AlignVCenter
                    filled:      false
                    strokeColor: Qt.darker(Style.colYellow, 1.6)
                    strokeWidth: 1.0
                    padding:     1.0
                }
            }

            Item { Layout.fillWidth: true }

            HexNavButton { label: "›"; onClicked: root.nextMonth() }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 6
            spacing: 4
            Repeater {
                model: ["Mo","Di","Mi","Do","Fr","Sa","So"]
                Text {
                    Layout.fillWidth: true
                    text: modelData
                    color: Style.colBlue
                    font.pixelSize: 11
                    font.family: "Courier New"
                    horizontalAlignment: Text.AlignHCenter
                    font.letterSpacing: 1
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Repeater {
                model: root.numWeeks

                Rectangle {
                    id: weekRow
                    required property int index
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 5
                    color:   weekRow.index === root.todayWeekIndex ? Style.colHighlight : "transparent"
                    opacity: weekRow.index === root.todayWeekIndex ? 1.0 : 0.5

                    RowLayout {
                        anchors.fill: parent
                        spacing: 4

                        Repeater {
                            model: 7

                            Item {
                                id: dayCell
                                required property int index
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                property var cell:       root.calCells[dayCell.index + weekRow.index * 7]
                                property bool isToday:   cell.type === "cur"
                                    && root.curYear  === root.todayDate.getFullYear()
                                    && root.curMonth === root.todayDate.getMonth()
                                    && cell.d === root.todayDate.getDate()
                                property bool isOther:    cell.type !== "cur"
                                property bool isSelected: !isToday && cell.type === "cur" && cell.d === root.selectedDay

                                HexShape {
                                    anchors.fill: parent
                                    visible:     dayCell.isToday
                                    filled:      true
                                    fillColor:   "#1c1500"
                                    strokeColor: Style.colYellow
                                    strokeWidth: 1.8
                                    padding:     2.0
                                }

                                HoverHandler { id: dayHover }

                                Rectangle {
                                    anchors.fill: parent
                                    visible: dayHover.hovered && !dayCell.isOther && !dayCell.isToday && !dayCell.isSelected
                                    color: Qt.rgba(1, 1, 1, 0.06)
                                    radius: 4
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    visible: dayCell.isSelected
                                    color: Qt.rgba(1, 1, 1, 0.05)
                                    border.color: Style.colRivet
                                    border.width: 1
                                    radius: 4
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: dayCell.cell.d
                                    font.pixelSize: 14
                                    font.family: "Courier New"
                                    font.bold: dayCell.isToday
                                    color: dayCell.isToday     ? Style.colYellow
                                         : dayCell.isOther    ? Qt.rgba(1, 1, 1, 0.08)
                                         : dayCell.isSelected ? Style.colRivet
                                         : Style.colWhite
                                }

                                TapHandler {
                                    enabled: !dayCell.isOther
                                    acceptedButtons: Qt.LeftButton
                                    onTapped: root.selectedDay = dayCell.cell.d
                                }
                                TapHandler {
                                    enabled: !dayCell.isOther
                                    acceptedButtons: Qt.RightButton
                                    onTapped: thunderbirdProcess.running = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
