import QtQuick

// Loom Alert — durum/feedback kutusu (callout). Saf görsel (Badge gibi düz Rectangle).
// variant: info (default) | success | warning | destructive.
Rectangle {
    id: root

    property string variant: "info"
    property string title: ""
    property string text: ""

    // variant → ana renk. warning hariç hepsi Theme token'ı (Theme'de warning token'ı
    // yok; gelecekte eklenebilir, şimdilik amber literal).
    readonly property color tone: root.variant === "success" ? Theme.success
        : root.variant === "warning" ? "#f59e0b"
        : root.variant === "destructive" ? Theme.destructive
        : Theme.accent
    readonly property string glyph: root.variant === "success" ? "✓"
        : root.variant === "warning" ? "!"
        : root.variant === "destructive" ? "✕" : "i"

    implicitWidth: 360
    implicitHeight: layout.implicitHeight + Theme.spacing.md * 2
    radius: Theme.radiusMd
    color: Qt.rgba(root.tone.r, root.tone.g, root.tone.b, 0.08)
    border.width: 1
    border.color: Qt.rgba(root.tone.r, root.tone.g, root.tone.b, 0.35)

    Accessible.role: Accessible.StaticText
    Accessible.name: root.title + " " + root.text

    Row {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Theme.spacing.md
        spacing: Theme.spacing.md

        Rectangle {
            id: icon
            width: 20
            height: 20
            radius: width / 2
            color: root.tone
            Text {
                anchors.centerIn: parent
                text: root.glyph
                color: "white"
                font.pixelSize: 12
                font.bold: true
            }
        }

        Column {
            id: body
            spacing: 2
            width: layout.width - icon.width - layout.spacing
            Text {
                visible: root.title !== ""
                width: body.width
                text: root.title
                color: Theme.foreground
                font.pixelSize: Theme.font.base
                font.weight: Theme.font.semibold
                wrapMode: Text.WordWrap
            }
            Text {
                visible: root.text !== ""
                width: body.width
                text: root.text
                color: Theme.mutedForeground
                font.pixelSize: Theme.font.sm
                wrapMode: Text.WordWrap
            }
        }
    }
}
