import QtQuick
import QtQuick.Templates as T

// Loom CheckBox — etiket sağda, tristate destekli (PLAN.md #9).
T.CheckBox {
    id: control

    spacing: Theme.spacing.sm
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5
    font.pixelSize: Theme.font.base
    implicitWidth: contentItem.implicitWidth
    implicitHeight: Math.max(indicator.implicitHeight, contentItem.implicitHeight)

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text

    indicator: Rectangle {
        id: box
        implicitWidth: 18
        implicitHeight: 18
        x: 0
        y: (control.height - height) / 2
        radius: Theme.radiusSm
        color: control.checkState !== Qt.Unchecked ? Theme.accent : "transparent"
        border.width: control.checkState !== Qt.Unchecked ? 0 : 1
        border.color: control.hovered ? Theme.foreground : Theme.input

        Text {
            anchors.centerIn: parent
            visible: control.checkState === Qt.Checked
            text: "✓"
            color: Theme.accentForeground
            font.pixelSize: box.width * 0.82
            font.bold: true
        }
        Rectangle {
            anchors.centerIn: parent
            visible: control.checkState === Qt.PartiallyChecked
            width: box.width * 0.5
            height: 2
            radius: 1
            color: Theme.accentForeground
        }

        FocusRing {
            active: control.visualFocus
            cornerRadius: box.radius
        }
    }

    contentItem: Text {
        text: control.text
        color: Theme.foreground
        font: control.font
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
