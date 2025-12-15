import QtQuick

// Loom Badge — saf görsel pill. variant: default | secondary | outline |
// destructive | success.
Rectangle {
    id: root

    property string text: ""
    property string variant: "default"

    implicitWidth: label.implicitWidth + 18
    implicitHeight: label.implicitHeight + 6
    radius: Theme.radiusFull
    color: root.variant === "default" ? Theme.accent
        : root.variant === "secondary" ? Theme.muted
        : root.variant === "destructive" ? Theme.destructive
        : root.variant === "success" ? Theme.success : "transparent"
    border.width: root.variant === "outline" ? 1 : 0
    border.color: Theme.border

    Accessible.role: Accessible.StaticText
    Accessible.name: root.text

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        color: root.variant === "default" ? Theme.accentForeground
            : root.variant === "destructive" ? Theme.destructiveForeground
            : root.variant === "success" ? Theme.successForeground : Theme.foreground
        font.pixelSize: Theme.font.xs
        font.weight: Theme.font.medium
    }
}
