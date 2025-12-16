import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Loom as Loom

ScrollView {
    id: page
    clip: true
    contentWidth: availableWidth

    readonly property var spacingScale: [
        { n: "xs", v: 4 }, { n: "sm", v: 8 }, { n: "md", v: 12 },
        { n: "lg", v: 16 }, { n: "xl", v: 24 }, { n: "xxl", v: 32 }
    ]
    readonly property var typeScale: [
        { n: "xs", v: 12 }, { n: "sm", v: 13 }, { n: "base", v: 14 },
        { n: "lg", v: 16 }, { n: "xl", v: 18 }, { n: "xxl", v: 24 }
    ]

    ColumnLayout {
        width: page.availableWidth
        spacing: Loom.Theme.spacing.xl

        Text {
            text: I18n.t("intro_theme")
            color: Loom.Theme.mutedForeground
            font.pixelSize: Loom.Theme.font.base
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'import Loom as Loom\n\n// rebrand at startup\nLoom.Theme.accent = "#ff5a5f"\nLoom.Theme.appearance = Loom.Theme.Dark\nLoom.Theme.radius = 12\n\n// consume tokens\nRectangle {\n    color: Loom.Theme.card\n    radius: Loom.Theme.radiusLg\n    border.color: Loom.Theme.border\n}'
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_semantic")
            Swatch { name: "background";            value: Loom.Theme.background }
            Swatch { name: "foreground";            value: Loom.Theme.foreground }
            Swatch { name: "card";                  value: Loom.Theme.card }
            Swatch { name: "cardForeground";        value: Loom.Theme.cardForeground }
            Swatch { name: "muted";                 value: Loom.Theme.muted }
            Swatch { name: "mutedForeground";       value: Loom.Theme.mutedForeground }
            Swatch { name: "border";                value: Loom.Theme.border }
            Swatch { name: "input";                 value: Loom.Theme.input }
            Swatch { name: "ring";                  value: Loom.Theme.ring }
            Swatch { name: "accent";                value: Loom.Theme.accent }
            Swatch { name: "accentForeground";      value: Loom.Theme.accentForeground }
            Swatch { name: "destructive";           value: Loom.Theme.destructive }
            Swatch { name: "destructiveForeground"; value: Loom.Theme.destructiveForeground }
            Swatch { name: "success";               value: Loom.Theme.success }
            Swatch { name: "successForeground";     value: Loom.Theme.successForeground }
        }

        TokenSection {
            Layout.fillWidth: true
            title: "Radius"
            Repeater {
                model: [
                    { n: "sm",   r: Loom.Theme.radiusSm },
                    { n: "md",   r: Loom.Theme.radiusMd },
                    { n: "lg",   r: Loom.Theme.radiusLg },
                    { n: "full", r: Loom.Theme.radiusFull }
                ]
                delegate: Column {
                    id: rad
                    required property var modelData
                    spacing: Loom.Theme.spacing.xs
                    Rectangle {
                        width: 96; height: 56
                        radius: rad.modelData.r
                        color: Loom.Theme.muted
                        border.color: Loom.Theme.border
                        border.width: 1
                    }
                    Text {
                        text: rad.modelData.n
                        color: Loom.Theme.mutedForeground
                        font.pixelSize: Loom.Theme.font.xs
                    }
                }
            }
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_spacing")
            Repeater {
                model: page.spacingScale
                delegate: Column {
                    id: sp
                    required property var modelData
                    spacing: Loom.Theme.spacing.xs
                    Rectangle {
                        width: sp.modelData.v * 2; height: 18; radius: 3
                        color: Loom.Theme.accent
                    }
                    Text {
                        text: sp.modelData.n + " · " + sp.modelData.v
                        color: Loom.Theme.mutedForeground
                        font.pixelSize: Loom.Theme.font.xs
                    }
                }
            }
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_typography")
            Column {
                spacing: Loom.Theme.spacing.sm
                Repeater {
                    model: page.typeScale
                    delegate: Text {
                        id: ty
                        required property var modelData
                        text: "Loom design system — " + ty.modelData.n + " (" + ty.modelData.v + "px)"
                        color: Loom.Theme.foreground
                        font.pixelSize: ty.modelData.v
                        font.family: Loom.Theme.font.family
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Loom.Theme.spacing.md
            Text {
                text: I18n.t("g_override")
                color: Loom.Theme.foreground
                font.pixelSize: Loom.Theme.font.lg
                font.weight: Font.DemiBold
            }
            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Loom.Theme.border }
            Text {
                Layout.fillWidth: true
                Layout.maximumWidth: 620
                wrapMode: Text.WordWrap
                text: I18n.t("ov_freeze_body")
                color: Loom.Theme.mutedForeground
                font.pixelSize: Loom.Theme.font.sm
            }
            RowLayout {
                spacing: Loom.Theme.spacing.md
                Rectangle {
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 84
                    radius: Loom.Theme.radiusLg
                    color: Loom.Theme.card
                    border.color: Loom.Theme.border
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "card"
                        color: Loom.Theme.cardForeground
                        font.pixelSize: Loom.Theme.font.sm
                    }
                }
                ColumnLayout {
                    spacing: Loom.Theme.spacing.sm
                    Loom.Button {
                        text: I18n.t("btn_override")
                        variant: "secondary"
                        size: "small"
                        onClicked: Loom.Theme.card = "#7c3aed"
                    }
                    Loom.Button {
                        text: I18n.t("btn_reset")
                        variant: "outline"
                        size: "small"
                        onClicked: Loom.Theme.card = Qt.binding(function () {
                            return Loom.Theme.isDark ? "#0f0f10" : "#ffffff"
                        })
                    }
                }
            }
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
