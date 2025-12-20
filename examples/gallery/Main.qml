import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Loom as Loom

// Loom Gallery — sidebar navigasyonlu, kategorize component showcase.
ApplicationWindow {
    id: win
    width: 1160
    height: 760
    visible: true
    minimumWidth: 940
    minimumHeight: 620
    title: "Loom · Component Gallery (v1)"
    color: Loom.Theme.background

    readonly property int section: navList.currentIndex
    readonly property var sections: [
        { key: "Overview", id: "overview", num: "01" },
        { key: "Theme",    id: "theme",    num: "02" },
        { key: "Button",   id: "button",   num: "03" },
        { key: "Card",     id: "card",     num: "04" },
        { key: "Inputs",   id: "inputs",   num: "05" },
        { key: "Badge",    id: "badge",    num: "06" }
    ]

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ===================== SIDEBAR =====================
        Rectangle {
            Layout.preferredWidth: 252
            Layout.fillHeight: true
            color: Loom.Theme.card

            Rectangle {
                anchors.right: parent.right
                width: 1
                height: parent.height
                color: Loom.Theme.border
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Loom.Theme.spacing.xl
                spacing: Loom.Theme.spacing.xl

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Loom.Theme.spacing.sm
                    Rectangle { implicitWidth: 18; implicitHeight: 18; radius: 5; color: Loom.Theme.accent }
                    Text {
                        text: "loom"
                        color: Loom.Theme.foreground
                        font.family: "Menlo"
                        font.pixelSize: 21
                        font.weight: Font.DemiBold
                    }
                    Text {
                        text: "/ui"
                        color: Loom.Theme.mutedForeground
                        font.family: "Menlo"
                        font.pixelSize: 15
                    }
                    Item { Layout.fillWidth: true }
                }

                // dil seçici
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    Repeater {
                        model: I18n.languages
                        delegate: Rectangle {
                            id: langBtn
                            required property int index
                            required property var modelData
                            implicitWidth: 36
                            implicitHeight: 26
                            radius: Loom.Theme.radiusSm
                            color: I18n.lang === langBtn.modelData.code ? Loom.Theme.accent
                                : langMouse.containsMouse ? Loom.Theme.muted : "transparent"
                            border.width: I18n.lang === langBtn.modelData.code ? 0 : 1
                            border.color: Loom.Theme.border
                            Text {
                                anchors.centerIn: parent
                                text: langBtn.modelData.label
                                color: I18n.lang === langBtn.modelData.code
                                    ? Loom.Theme.accentForeground : Loom.Theme.mutedForeground
                                font.family: "Menlo"
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                            }
                            MouseArea {
                                id: langMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: I18n.lang = langBtn.modelData.code
                            }
                        }
                    }
                    Item { Layout.fillWidth: true }
                }

                ListView {
                    id: navList
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentHeight
                    interactive: false
                    spacing: 3
                    currentIndex: 0
                    model: win.sections

                    delegate: Rectangle {
                        id: navItem
                        required property int index
                        required property var modelData
                        width: ListView.view.width
                        height: 46
                        radius: Loom.Theme.radiusMd
                        color: navItem.ListView.isCurrentItem ? Loom.Theme.muted
                            : navMouse.containsMouse
                                ? Qt.rgba(Loom.Theme.muted.r, Loom.Theme.muted.g, Loom.Theme.muted.b, 0.55)
                                : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: 3
                            height: 22
                            radius: 2
                            color: Loom.Theme.accent
                            opacity: navItem.ListView.isCurrentItem ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Loom.Theme.spacing.md
                            anchors.rightMargin: Loom.Theme.spacing.md
                            spacing: Loom.Theme.spacing.md
                            Text {
                                text: navItem.modelData.num
                                color: navItem.ListView.isCurrentItem ? Loom.Theme.accent : Loom.Theme.mutedForeground
                                font.family: "Menlo"
                                font.pixelSize: 12
                            }
                            Text {
                                text: navItem.modelData.key
                                color: navItem.ListView.isCurrentItem ? Loom.Theme.foreground : Loom.Theme.mutedForeground
                                font.pixelSize: Loom.Theme.font.base
                                font.weight: navItem.ListView.isCurrentItem ? Font.DemiBold : Font.Normal
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: navMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: navItem.ListView.view.currentIndex = navItem.index
                        }

                        opacity: 0
                        Component.onCompleted: navIntro.start()
                        SequentialAnimation {
                            id: navIntro
                            PauseAnimation { duration: 90 + navItem.index * 55 }
                            NumberAnimation {
                                target: navItem
                                property: "opacity"
                                from: 0; to: 1
                                duration: 300
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Text {
                    text: "QtQuick.Templates · Qt 6.5+\n8 components · zero C++"
                    color: Loom.Theme.mutedForeground
                    font.family: "Menlo"
                    font.pixelSize: 11
                    lineHeight: 1.4
                }
            }
        }

        // ===================== CONTENT =====================
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Canvas {
                id: dots
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var c = Loom.Theme.foreground
                    ctx.fillStyle = Qt.rgba(c.r, c.g, c.b, 0.05)
                    var gap = 26
                    for (var gx = gap; gx < width; gx += gap)
                        for (var gy = gap; gy < height; gy += gap) {
                            ctx.beginPath()
                            ctx.arc(gx, gy, 1.1, 0, 2 * Math.PI)
                            ctx.fill()
                        }
                }
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
                Connections {
                    target: Loom.Theme
                    function onAppearanceChanged() { dots.requestPaint() }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Loom.Theme.spacing.xxl
                spacing: Loom.Theme.spacing.lg

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Loom.Theme.spacing.lg

                    ColumnLayout {
                        spacing: 3
                        Text {
                            text: win.sections[win.section].num + " · LOOM/" + win.sections[win.section].key.toUpperCase()
                            color: Loom.Theme.accent
                            font.family: "Menlo"
                            font.pixelSize: 12
                        }
                        Text {
                            text: win.sections[win.section].key
                            color: Loom.Theme.foreground
                            font.pixelSize: 32
                            font.weight: Font.DemiBold
                        }
                        Text {
                            text: I18n.t("desc_" + win.sections[win.section].id)
                            color: Loom.Theme.mutedForeground
                            font.pixelSize: Loom.Theme.font.base
                        }
                    }

                    Item { Layout.fillWidth: true }

                    RowLayout {
                        Layout.alignment: Qt.AlignTop
                        spacing: Loom.Theme.spacing.sm
                        Repeater {
                            model: ["#6366f1", "#f43f5e", "#10b981", "#f59e0b", "#0ea5e9", "#8b5cf6"]
                            delegate: Rectangle {
                                id: dot
                                required property int index
                                required property string modelData
                                width: 24
                                height: 24
                                radius: 12
                                color: dot.modelData
                                border.width: Qt.colorEqual(Loom.Theme.accent, dot.modelData) ? 3 : 1
                                border.color: Qt.colorEqual(Loom.Theme.accent, dot.modelData)
                                    ? Loom.Theme.foreground : Loom.Theme.border
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Loom.Theme.accent = dot.modelData
                                }
                            }
                        }
                        Loom.Button {
                            text: Loom.Theme.isDark ? "☀ Light" : "☾ Dark"
                            variant: "outline"
                            size: "small"
                            onClicked: Loom.Theme.appearance =
                                Loom.Theme.isDark ? Loom.Theme.Light : Loom.Theme.Dark
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Loom.Theme.border }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    transform: Translate { id: pageSlide; y: 0 }

                    StackLayout {
                        id: stack
                        anchors.fill: parent
                        currentIndex: win.section
                        OverviewPage {}
                        ThemePage {}
                        ButtonPage {}
                        CardPage {}
                        InputsPage {}
                        BadgePage {}
                    }
                }
            }
        }
    }

    onSectionChanged: pageAnim.restart()
    ParallelAnimation {
        id: pageAnim
        NumberAnimation { target: stack; property: "opacity"; from: 0; to: 1; duration: 240; easing.type: Easing.OutCubic }
        NumberAnimation { target: pageSlide; property: "y"; from: 14; to: 0; duration: 280; easing.type: Easing.OutCubic }
    }
}
