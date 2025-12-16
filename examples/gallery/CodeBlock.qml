import QtQuick
import QtQuick.Layouts
import Loom as Loom

// Katlanır + kopyalanabilir kod bloğu. "</> Code" ile aç/kapa, "Copy" ile panoya.
// Pano erişimi saf-QML: readonly TextEdit.selectAll() + copy().
ColumnLayout {
    id: root
    property string code: ""
    property bool open: false
    property bool copied: false
    spacing: Loom.Theme.spacing.sm

    Component.onCompleted: panel.visible = root.open

    Loom.Button {
        text: panel.visible ? I18n.t("ui_hide") : "</>  " + I18n.t("ui_showcode")
        variant: panel.visible ? "ghost" : "outline"
        size: "small"
        onClicked: panel.visible = !panel.visible
    }

    Rectangle {
        id: panel
        visible: false
        Layout.fillWidth: true
        Layout.maximumWidth: 640
        radius: Loom.Theme.radiusLg
        color: Loom.Theme.isDark ? Qt.lighter(Loom.Theme.card, 1.6) : Qt.darker(Loom.Theme.muted, 1.03)
        border.color: Loom.Theme.border
        border.width: 1
        implicitHeight: inner.implicitHeight + Loom.Theme.spacing.lg * 2

        ColumnLayout {
            id: inner
            anchors.fill: parent
            anchors.margins: Loom.Theme.spacing.lg
            spacing: Loom.Theme.spacing.sm

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "qml"
                    color: Loom.Theme.mutedForeground
                    font.family: "Menlo"
                    font.pixelSize: 11
                }
                Item { Layout.fillWidth: true }
                Loom.Button {
                    text: root.copied ? I18n.t("ui_copied") : I18n.t("ui_copy")
                    variant: "outline"
                    size: "small"
                    onClicked: {
                        codeText.selectAll()
                        codeText.copy()
                        codeText.deselect()
                        root.copied = true
                        copiedTimer.restart()
                    }
                }
            }

            TextEdit {
                id: codeText
                Layout.fillWidth: true
                text: root.code
                readOnly: true
                selectByMouse: true
                wrapMode: TextEdit.NoWrap
                color: Loom.Theme.foreground
                font.family: "Menlo"
                font.pixelSize: 13
            }
        }
    }

    Timer {
        id: copiedTimer
        interval: 1400
        onTriggered: root.copied = false
    }
}
