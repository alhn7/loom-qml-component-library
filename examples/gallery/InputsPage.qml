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
            text: I18n.t("intro_inputs")
            color: Loom.Theme.mutedForeground
            font.pixelSize: Loom.Theme.font.base
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'Loom.TextField {\n    label: "Email"\n    placeholderText: "you@example.com"\n    helperText: "Use your work email."\n    error: false           // true -> red border + errorText\n    variant: "outline"     // outline | filled\n}\n\nLoom.CheckBox { text: "Accept"; tristate: true }\nLoom.Switch   { text: "Notifications"; checked: true }\nLoom.Slider   { from: 0; to: 100; value: 60; stepSize: 10 }\nLoom.RadioGroup { model: ["Light", "Dark", "System"] }'
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Loom.Theme.spacing.xxl
            Layout.alignment: Qt.AlignTop

            TokenSection {
                Layout.alignment: Qt.AlignTop
                title: I18n.t("g_textfield")
                Column {
                    spacing: Loom.Theme.spacing.md
                    Loom.TextField { width: 300; placeholderText: "you@example.com" }
                    Loom.TextField {
                        width: 300
                        label: I18n.t("f_email")
                        placeholderText: "you@example.com"
                        helperText: I18n.t("f_email_helper")
                    }
                    Loom.TextField {
                        width: 300
                        label: I18n.t("f_password")
                        echoMode: TextInput.Password
                        text: "1234"
                        error: true
                        errorText: I18n.t("f_password_err")
                    }
                    Loom.TextField { width: 300; variant: "filled"; placeholderText: I18n.t("f_filled") }
                    Loom.TextField { width: 300; placeholderText: I18n.t("f_disabled"); enabled: false }
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                spacing: Loom.Theme.spacing.xl

                TokenSection {
                    title: I18n.t("g_checkbox")
                    Column {
                        spacing: Loom.Theme.spacing.sm
                        Loom.CheckBox { text: "Unchecked" }
                        Loom.CheckBox { text: "Checked"; checked: true }
                        Loom.CheckBox { text: "Indeterminate"; tristate: true; checkState: Qt.PartiallyChecked }
                        Loom.CheckBox { text: I18n.t("f_disabled"); checked: true; enabled: false }
                    }
                }

                TokenSection {
                    title: I18n.t("g_switch")
                    Column {
                        spacing: Loom.Theme.spacing.sm
                        Loom.Switch { text: "Off" }
                        Loom.Switch { text: "On"; checked: true }
                        Loom.Switch { text: I18n.t("f_disabled"); checked: true; enabled: false }
                    }
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                spacing: Loom.Theme.spacing.xl

                TokenSection {
                    title: I18n.t("g_slider")
                    Column {
                        spacing: Loom.Theme.spacing.md
                        Loom.Slider { width: 200; value: 0.4 }
                        Loom.Slider { width: 200; from: 0; to: 100; value: 60; stepSize: 10 }
                        Loom.Slider { width: 200; value: 0.5; enabled: false }
                    }
                }

                TokenSection {
                    title: I18n.t("g_radio")
                    Loom.RadioGroup {
                        model: [
                            { text: "Light" },
                            { text: "Dark", checked: true },
                            { text: "System" },
                            { text: I18n.t("f_disabled"), enabled: false }
                        ]
                    }
                }
            }
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
