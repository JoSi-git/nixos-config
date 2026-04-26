import QtQuick
import QtQuick.Layouts
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

        width: 34; height: 30

        HoverHandler { id: navHover }
        TapHandler   { onTapped: navBtn.clicked() }

        HexShape {
            anchors.fill: parent
            filled:      true
            fillColor:   navHover.hovered
                         ? Qt.darker(Style.colYellow, 1.4)
                         : "transparent"
            strokeColor: Style.colYellow
            strokeWidth: 1.5
            padding:     2
            Behavior on fillColor   { ColorAnimation { duration: 120 } }
            Behavior on strokeColor { ColorAnimation { duration: 120 } }
        }

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            text: navBtn.label
            color: navHover.hovered ? Style.colWhite : Style.colYellow
            font.pixelSize: 20
            font.family: "Courier New"
            font.bold: true
            Behavior on color { ColorAnimation { duration: 120 } }
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
        let cells       = []
        let firstDow    = new Date(curYear, curMonth, 1).getDay()
        let startDow    = firstDow === 0 ? 6 : firstDow - 1
        let daysInMonth = new Date(curYear, curMonth + 1, 0).getDate()
        let prevStart   = new Date(curYear, curMonth, 0).getDate() - startDow + 1
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

                                property var cell:        root.calCells[dayCell.index + weekRow.index * 7]
                                property bool isToday:    cell.type === "cur"
                                    && root.curYear  === root.todayDate.getFullYear()
                                    && root.curMonth === root.todayDate.getMonth()
                                    && cell.d === root.todayDate.getDate()
                                property bool isOther:    cell.type !== "cur"
                                property bool isSelected: !isToday && cell.type === "cur" && cell.d === root.selectedDay

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
                                    anchors.verticalCenterOffset: -1
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
