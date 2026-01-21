import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Loom as Loom

ScrollView {
    id: page
    clip: true
    contentWidth: availableWidth

    ColumnLayout {
        width: page.availableWidth
        spacing: Loom.Theme.spacing.xl

        Text {
            text: I18n.t("ov_hero")
            color: Loom.Theme.foreground
            font.pixelSize: 24
            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }
        Text {
            text: I18n.t("ov_body")
            color: Loom.Theme.mutedForeground
            font.pixelSize: Loom.Theme.font.lg
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }

        CodeBlock {
            Layout.fillWidth: true
            open: true
            code: '# CMakeLists.txt\nFetchContent_MakeAvailable(Loom)\ntarget_link_libraries(app PRIVATE LoomModule)\n\n// main.qml\nimport Loom as Loom\nLoom.Button { text: "Save"; variant: "primary" }'
        }

        RowLayout {
            spacing: Loom.Theme.spacing.md
            Loom.Button { text: "Primary"; variant: "primary" }
            Loom.Button { text: "Outline"; variant: "outline" }
            Loom.Badge { text: "v1.0.0"; variant: "success" }
            Loom.Switch { checked: true }
        }

        Text {
            text: I18n.t("g_whatsinside")
            color: Loom.Theme.foreground
            font.pixelSize: Loom.Theme.font.lg
            font.weight: Font.DemiBold
            Layout.topMargin: Loom.Theme.spacing.sm
        }
        GridLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 760
            columns: 2
            columnSpacing: Loom.Theme.spacing.md
            rowSpacing: Loom.Theme.spacing.md

            Repeater {
                model: [
                    { n: "Button",    k: "wi_button" },
                    { n: "Card",      k: "wi_card" },
                    { n: "TextField", k: "wi_textfield" },
                    { n: "ComboBox",  k: "wi_combobox" },
                    { n: "CheckBox",  k: "wi_checkbox" },
                    { n: "Switch",    k: "wi_switch" },
                    { n: "Slider",    k: "wi_slider" },
                    { n: "RadioButton", k: "wi_radio" },
                    { n: "Badge",     k: "wi_badge" },
                    { n: "Alert",     k: "wi_alert" },
                    { n: "Toast",     k: "wi_toast" },
                    { n: "Progress",  k: "wi_progress" },
                    { n: "Tooltip",   k: "wi_tooltip" }
                ]
                delegate: Rectangle {
                    id: cell
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 58
                    radius: Loom.Theme.radiusLg
                    color: Loom.Theme.card
                    border.color: Loom.Theme.border
                    border.width: 1
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Loom.Theme.spacing.md
                        spacing: Loom.Theme.spacing.md
                        Rectangle { implicitWidth: 6; implicitHeight: 6; radius: 3; color: Loom.Theme.accent }
                        ColumnLayout {
                            spacing: 1
                            Text {
                                text: cell.modelData.n
                                color: Loom.Theme.foreground
                                font.pixelSize: Loom.Theme.font.base
                                font.weight: Font.DemiBold
                            }
                            Text {
                                text: I18n.t(cell.modelData.k)
                                color: Loom.Theme.mutedForeground
                                font.pixelSize: Loom.Theme.font.xs
                            }
                        }
                        Item { Layout.fillWidth: true }
                    }
                }
            }
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
