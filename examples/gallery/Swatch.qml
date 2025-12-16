import QtQuick
import Loom as Loom

// Tek bir renk token'ını gösteren swatch: renk kutusu + ad + hex.
Column {
    id: root
    property string name
    property color value
    spacing: Loom.Theme.spacing.xs

    Rectangle {
        width: 112
        height: 56
        radius: Loom.Theme.radiusSm
        color: root.value
        border.color: Loom.Theme.border
        border.width: 1
    }
    Text {
        text: root.name
        color: Loom.Theme.foreground
        font.pixelSize: Loom.Theme.font.sm
        font.weight: Loom.Theme.font.medium
    }
    Text {
        text: "" + root.value
        color: Loom.Theme.mutedForeground
        font.pixelSize: Loom.Theme.font.xs
    }
}
