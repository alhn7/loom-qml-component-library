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
            text: I18n.t("intro_badge")
            color: Loom.Theme.mutedForeground
            font.pixelSize: Loom.Theme.font.base
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'Loom.Badge {\n    text: "New"\n    variant: "success"   // default | secondary | outline | destructive | success\n}'
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_variants")
            Loom.Badge { text: "Default" }
            Loom.Badge { text: "Secondary";   variant: "secondary" }
            Loom.Badge { text: "Outline";     variant: "outline" }
            Loom.Badge { text: "Destructive"; variant: "destructive" }
            Loom.Badge { text: "Success";     variant: "success" }
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_usage")
            RowLayout {
                spacing: Loom.Theme.spacing.sm
                Text {
                    text: I18n.t("badge_order")
                    color: Loom.Theme.foreground
                    font.pixelSize: Loom.Theme.font.base
                }
                Loom.Badge { text: I18n.t("badge_delivered"); variant: "success" }
            }
            RowLayout {
                spacing: Loom.Theme.spacing.sm
                Text {
                    text: I18n.t("badge_stock")
                    color: Loom.Theme.foreground
                    font.pixelSize: Loom.Theme.font.base
                }
                Loom.Badge { text: I18n.t("badge_out"); variant: "destructive" }
            }
            RowLayout {
                spacing: Loom.Theme.spacing.sm
                Text {
                    text: I18n.t("badge_version")
                    color: Loom.Theme.foreground
                    font.pixelSize: Loom.Theme.font.base
                }
                Loom.Badge { text: "v1.0.0"; variant: "outline" }
            }
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
