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
            text: I18n.t("intro_button")
            color: Loom.Theme.mutedForeground
            font.pixelSize: Loom.Theme.font.base
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: 640
        }

        CodeBlock {
            Layout.fillWidth: true
            code: 'import Loom as Loom\n\nLoom.Button {\n    text: "Save"\n    variant: "primary"   // primary | secondary | outline | ghost | destructive\n    size: "medium"       // small | medium | large\n    loading: false\n    icon.source: "save.svg"\n    onClicked: console.log("clicked")\n}'
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_variants")
            Loom.Button { text: "Primary";     variant: "primary" }
            Loom.Button { text: "Secondary";   variant: "secondary" }
            Loom.Button { text: "Outline";     variant: "outline" }
            Loom.Button { text: "Ghost";       variant: "ghost" }
            Loom.Button { text: "Destructive"; variant: "destructive" }
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_sizes")
            Loom.Button { text: "Small";  variant: "primary"; size: "small" }
            Loom.Button { text: "Medium"; variant: "primary"; size: "medium" }
            Loom.Button { text: "Large";  variant: "primary"; size: "large" }
        }

        TokenSection {
            Layout.fillWidth: true
            title: I18n.t("g_states") + " — " + I18n.t("g_states_hint")
            Loom.Button { text: "Icon";             variant: "primary"; icon.source: Qt.resolvedUrl("star.svg") }
            Loom.Button { text: "Loading";          variant: "primary"; loading: true }
            Loom.Button { text: "Disabled";         variant: "primary"; enabled: false }
            Loom.Button { text: "Outline disabled"; variant: "outline"; enabled: false }
        }

        Item { implicitHeight: Loom.Theme.spacing.xl; Layout.fillWidth: true }
    }
}
