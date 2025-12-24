import QtQuick
import QtQuick.Layouts

// Loom Toast — yüzen, opak bildirim. Card kabuğu (Item + Elevation + opak bg)
// üstüne Alert'in variant/ton/glyph içeriği; opsiyonel aksiyon butonu + kapatma (✕).
// variant: info (default) | success | warning | destructive.
Item {
    id: control

    property string variant: "info"
    property string title: ""
    property string text: ""
    property string action: ""       // boş → aksiyon butonu gizli
    property bool closable: true
    property int elevation: 2

    signal actionTriggered()
    signal closed()

    // variant → ana renk + glyph (Alert ile aynı tablo; warning Theme'de yok → amber literal).
    readonly property color tone: control.variant === "success" ? Theme.success
        : control.variant === "warning" ? "#f59e0b"
        : control.variant === "destructive" ? Theme.destructive
        : Theme.accent
    readonly property string glyph: control.variant === "success" ? "✓"
        : control.variant === "warning" ? "!"
        : control.variant === "destructive" ? "✕" : "i"

    implicitWidth: 380
    implicitHeight: layout.implicitHeight + Theme.spacing.md * 2

    Accessible.role: Accessible.StaticText
    Accessible.name: control.title + " " + control.text

    // Card pattern: caster opak bg'nin ARKASINDA kalır, yalnız taşan gölge görünür.
    Elevation {
        anchors.fill: bg
        level: control.elevation
        cornerRadius: bg.radius
    }
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusMd
        color: Theme.card
        border.color: Theme.border
        border.width: 1
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Theme.spacing.md
        spacing: Theme.spacing.md

        Rectangle {
            id: icon
            Layout.alignment: Qt.AlignTop
            implicitWidth: 20
            implicitHeight: 20
            radius: width / 2
            color: control.tone
            Text {
                anchors.centerIn: parent
                text: control.glyph
                color: "white"
                font.pixelSize: 12
                font.bold: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2
            Text {
                visible: control.title !== ""
                Layout.fillWidth: true
                text: control.title
                color: Theme.foreground
                font.pixelSize: Theme.font.base
                font.weight: Theme.font.semibold
                wrapMode: Text.WordWrap
            }
            Text {
                visible: control.text !== ""
                Layout.fillWidth: true
                text: control.text
                color: Theme.mutedForeground
                font.pixelSize: Theme.font.sm
                wrapMode: Text.WordWrap
            }
        }

        // Opsiyonel aksiyon — Loom.Button (focus/klavye/a11y bedava).
        Button {
            visible: control.action !== ""
            Layout.alignment: Qt.AlignVCenter
            variant: "outline"
            size: "small"
            text: control.action
            onClicked: control.actionTriggered()
        }

        // Kapatma (✕) — closable ile gizlenir; a11y adı "Close".
        Button {
            visible: control.closable
            Layout.alignment: Qt.AlignTop
            variant: "ghost"
            size: "small"
            text: "✕"
            Accessible.name: "Close"
            onClicked: control.closed()
        }
    }
}
