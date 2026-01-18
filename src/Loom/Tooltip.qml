import QtQuick
import QtQuick.Templates as T

// Loom Tooltip — hover/focus ipucu balonu. T.ToolTip üstüne: koyu opak yüzey
// (bg=foreground, text=background → klasik tooltip kontrastı) + Elevation gölge +
// fade in/out. Standalone kullanılır (attached ToolTip.text Loom temasını almaz):
//   Loom.Button { id: b; Loom.Tooltip { text: "..."; visible: b.hovered } }
T.ToolTip {
    id: control

    // Parent'ın üst-ortasında konumlan (default x/y garip yere koyar).
    x: (parent ? (parent.width - width) / 2 : 0)
    y: -control.height - 6
    padding: Theme.spacing.sm
    leftPadding: Theme.spacing.md
    rightPadding: Theme.spacing.md

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    contentItem: Text {
        text: control.text
        color: Theme.background
        font.pixelSize: Theme.font.sm
        wrapMode: Text.WordWrap
    }

    background: Item {
        Elevation { anchors.fill: bg; level: 1; cornerRadius: bg.radius }
        Rectangle {
            id: bg
            anchors.fill: parent
            radius: Theme.radiusSm
            color: Theme.foreground
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.motion.fast }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.motion.fast }
    }
}
