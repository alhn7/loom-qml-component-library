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

        // İki sütun: solda satır içi Alert'ler, sağda yüzen Toast'lar — yeni
        // bölüm fold üstünde kalsın diye yan yana.
        RowLayout {
            Layout.fillWidth: true
            spacing: Loom.Theme.spacing.xl

            TokenSection {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                title: I18n.t("g_alert")
                Column {
                    spacing: Loom.Theme.spacing.md
                    Loom.Alert {
                        width: 360
                        variant: "info"
                        title: "Heads up"
                        text: "This is an informational message for context."
                    }
                    Loom.Alert {
                        width: 360
                        variant: "success"
                        title: "Saved"
                        text: "Your changes have been saved successfully."
                    }
                    Loom.Alert {
                        width: 360
                        variant: "warning"
                        title: "Careful"
                        text: "This action may have unintended side effects."
                    }
                    Loom.Alert {
                        width: 360
                        variant: "destructive"
                        title: "Something went wrong"
                        text: "We couldn't complete the request. Please try again."
                    }
                }
            }

            TokenSection {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                title: I18n.t("g_toast")
                Column {
                    spacing: Loom.Theme.spacing.md
                    Loom.Toast {
                        width: 360
                        variant: "success"
                        title: "Saved"
                        text: "Your changes are now live."
                        onClosed: visible = false
                    }
                    Loom.Toast {
                        width: 360
                        variant: "info"
                        title: "File deleted"
                        text: "1 item moved to trash."
                        action: "Undo"
                        onClosed: visible = false
                    }
                    Loom.Toast {
                        width: 360
                        variant: "warning"
                        title: "Storage almost full"
                        text: "You have used 92% of your quota."
                        onClosed: visible = false
                    }
                    Loom.Toast {
                        width: 360
                        variant: "destructive"
                        title: "Upload failed"
                        text: "Check your connection and retry."
                        action: "Retry"
                        onClosed: visible = false
                    }
                }
            }
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'Loom.Alert {\n    variant: "success"   // info | success | warning | destructive\n    title: "Saved"\n    text: "Your changes have been saved."\n}'
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'Loom.Toast {\n    variant: "info"      // info | success | warning | destructive\n    title: "File deleted"\n    text: "1 item moved to trash."\n    action: "Undo"       // optional action button\n    onActionTriggered: restore()\n    onClosed: hide()\n}'
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
