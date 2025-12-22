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
            text: I18n.t("intro_feedback")
            color: Loom.Theme.mutedForeground
            font.pixelSize: Loom.Theme.font.base
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'Loom.Alert {\n    variant: "success"   // info | success | warning | destructive\n    title: "Saved"\n    text: "Your changes have been saved."\n}'
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_variants")
            Column {
                spacing: Loom.Theme.spacing.md
                Loom.Alert {
                    width: 520
                    variant: "info"
                    title: "Heads up"
                    text: "This is an informational message for context."
                }
                Loom.Alert {
                    width: 520
                    variant: "success"
                    title: "Saved"
                    text: "Your changes have been saved successfully."
                }
                Loom.Alert {
                    width: 520
                    variant: "warning"
                    title: "Careful"
                    text: "This action may have unintended side effects."
                }
                Loom.Alert {
                    width: 520
                    variant: "destructive"
                    title: "Something went wrong"
                    text: "We couldn't complete the request. Please try again."
                }
            }
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
