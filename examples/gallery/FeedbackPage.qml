import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Loom as Loom

Item {
    id: page

    property string toastPos: "bottom-right"

    ScrollView {
        id: scroller
        anchors.fill: parent
        clip: true
        contentWidth: availableWidth

        ColumnLayout {
            width: scroller.availableWidth
            spacing: Loom.Theme.spacing.xl

            Text {
                text: I18n.t("intro_feedback")
                color: Loom.Theme.mutedForeground
                font.pixelSize: Loom.Theme.font.base
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.maximumWidth: 640
            }

            // ── Progress: determinate barlar + indeterminate ──
            TokenSection {
                Layout.fillWidth: true
                title: I18n.t("g_progress")
                ColumnLayout {
                    spacing: Loom.Theme.spacing.md
                    RowLayout {
                        spacing: Loom.Theme.spacing.md
                        Loom.ProgressBar { Layout.preferredWidth: 280; Layout.alignment: Qt.AlignVCenter; value: 0.3 }
                        Text { text: "30%"; color: Loom.Theme.mutedForeground; font.pixelSize: Loom.Theme.font.sm }
                    }
                    RowLayout {
                        spacing: Loom.Theme.spacing.md
                        Loom.ProgressBar { Layout.preferredWidth: 280; Layout.alignment: Qt.AlignVCenter; value: 0.6 }
                        Text { text: "60%"; color: Loom.Theme.mutedForeground; font.pixelSize: Loom.Theme.font.sm }
                    }
                    RowLayout {
                        spacing: Loom.Theme.spacing.md
                        Loom.ProgressBar { Layout.preferredWidth: 280; Layout.alignment: Qt.AlignVCenter; value: 1.0 }
                        Text { text: "100%"; color: Loom.Theme.mutedForeground; font.pixelSize: Loom.Theme.font.sm }
                    }
                    RowLayout {
                        spacing: Loom.Theme.spacing.md
                        Loom.ProgressBar { Layout.preferredWidth: 280; Layout.alignment: Qt.AlignVCenter; indeterminate: true }
                        Text { text: I18n.t("pb_loading"); color: Loom.Theme.mutedForeground; font.pixelSize: Loom.Theme.font.sm }
                    }
                }
            }

            // ── "Dene" paneli: konum seçici + variant tetikleyicileri ──
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Loom.Theme.spacing.md

                Text {
                    text: I18n.t("g_toast_try")
                    color: Loom.Theme.foreground
                    font.pixelSize: Loom.Theme.font.lg
                    font.weight: Loom.Theme.font.semibold
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Loom.Theme.border
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Loom.Theme.spacing.sm
                    Text {
                        text: I18n.t("toast_position") + ":"
                        color: Loom.Theme.mutedForeground
                        font.pixelSize: Loom.Theme.font.sm
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Flow {
                        Layout.fillWidth: true
                        spacing: Loom.Theme.spacing.sm
                        Loom.Button {
                            text: "top-left"; size: "small"
                            variant: page.toastPos === "top-left" ? "primary" : "outline"
                            onClicked: page.toastPos = "top-left"
                        }
                        Loom.Button {
                            text: "top-center"; size: "small"
                            variant: page.toastPos === "top-center" ? "primary" : "outline"
                            onClicked: page.toastPos = "top-center"
                        }
                        Loom.Button {
                            text: "top-right"; size: "small"
                            variant: page.toastPos === "top-right" ? "primary" : "outline"
                            onClicked: page.toastPos = "top-right"
                        }
                        Loom.Button {
                            text: "bottom-left"; size: "small"
                            variant: page.toastPos === "bottom-left" ? "primary" : "outline"
                            onClicked: page.toastPos = "bottom-left"
                        }
                        Loom.Button {
                            text: "bottom-center"; size: "small"
                            variant: page.toastPos === "bottom-center" ? "primary" : "outline"
                            onClicked: page.toastPos = "bottom-center"
                        }
                        Loom.Button {
                            text: "bottom-right"; size: "small"
                            variant: page.toastPos === "bottom-right" ? "primary" : "outline"
                            onClicked: page.toastPos = "bottom-right"
                        }
                    }
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: Loom.Theme.spacing.sm
                    Loom.Button {
                        text: "Success"; size: "small"; variant: "outline"
                        onClicked: toaster.show({ variant: "success", title: "Saved", text: "Your changes are now live." })
                    }
                    Loom.Button {
                        text: "Info"; size: "small"; variant: "outline"
                        onClicked: toaster.show({ variant: "info", title: "File deleted", text: "1 item moved to trash.", action: "Undo" })
                    }
                    Loom.Button {
                        text: "Warning"; size: "small"; variant: "outline"
                        onClicked: toaster.show({ variant: "warning", title: "Storage almost full", text: "You have used 92% of your quota." })
                    }
                    Loom.Button {
                        text: "Destructive"; size: "small"; variant: "outline"
                        onClicked: toaster.show({ variant: "destructive", title: "Upload failed", text: "Check your connection and retry.", action: "Retry" })
                    }
                }
            }

            // ── Statik vitrin: solda Alert'ler, sağda Toast'lar ──
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
                code: 'Loom.Toast {\n    variant: "info"      // info | success | warning | destructive\n    title: "File deleted"\n    text: "1 item moved to trash."\n    action: "Undo"       // optional action button\n    onActionTriggered: restore()\n    onClosed: hide()\n}'
            }

            CodeBlock {
                Layout.fillWidth: true
                code: 'Loom.ToastArea {\n    id: toaster\n    anchors.fill: parent\n    position: "bottom-right"   // top-left … bottom-right\n}\n\n// trigger from anywhere:\ntoaster.show({\n    variant: "success",\n    title: "Saved",\n    text: "All changes stored."\n})'
            }

            Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
        }
    }

    // Overlay host: ScrollView'dan SONRA = üstte, scroll'la kaymaz.
    Loom.ToastArea {
        id: toaster
        anchors.fill: parent
        position: page.toastPos
    }
}
