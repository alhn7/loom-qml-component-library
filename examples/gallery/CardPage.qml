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
            text: I18n.t("intro_card")
            color: Loom.Theme.mutedForeground
            font.pixelSize: Loom.Theme.font.base
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'Loom.Card {\n    elevation: 2   // 0 .. 3\n    header:  Component { Text { text: "Title" } }\n    content: Component { Text { text: "Body..."; wrapMode: Text.WordWrap } }\n    footer:  Component { Loom.Button { text: "Action"; size: "small" } }\n}'
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("desc_card")

            Loom.Card {
                width: 300
                elevation: 2
                header: Component {
                    Text {
                        text: I18n.t("card_title")
                        color: Loom.Theme.cardForeground
                        font.pixelSize: Loom.Theme.font.lg
                        font.weight: Font.DemiBold
                    }
                }
                content: Component {
                    Text {
                        text: I18n.t("card_body")
                        color: Loom.Theme.mutedForeground
                        font.pixelSize: Loom.Theme.font.sm
                        wrapMode: Text.WordWrap
                    }
                }
                footer: Component {
                    Row {
                        spacing: Loom.Theme.spacing.sm
                        Loom.Button { text: I18n.t("card_pay");    variant: "primary"; size: "small" }
                        Loom.Button { text: I18n.t("card_detail"); variant: "outline"; size: "small" }
                    }
                }
            }

            Loom.Card {
                width: 300
                elevation: 0
                header: Component {
                    Text {
                        text: "elevation: 0"
                        color: Loom.Theme.cardForeground
                        font.pixelSize: Loom.Theme.font.base
                        font.weight: Font.Medium
                    }
                }
                content: Component {
                    Text {
                        text: I18n.t("card_e0_body")
                        color: Loom.Theme.mutedForeground
                        font.pixelSize: Loom.Theme.font.sm
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Loom.Card {
                width: 300
                elevation: 3
                header: Component {
                    Text {
                        text: "elevation: 3"
                        color: Loom.Theme.cardForeground
                        font.pixelSize: Loom.Theme.font.base
                        font.weight: Font.Medium
                    }
                }
                content: Component {
                    Text {
                        text: I18n.t("card_e3_body")
                        color: Loom.Theme.mutedForeground
                        font.pixelSize: Loom.Theme.font.sm
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
