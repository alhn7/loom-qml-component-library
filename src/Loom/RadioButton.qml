import QtQuick
import QtQuick.Templates as T

// Loom RadioButton — etiket sağda; daire indicator + seçilince accent dolgu + iç nokta.
// Aynı parent'taki RadioButton'lar autoExclusive ile tek-seç olur (RadioGroup bunu kullanır).
T.RadioButton {
    id: control

    // Grup içinde tanımlama için opsiyonel değer — RadioGroup.currentValue bunu döndürür.
    property var value

    spacing: Theme.spacing.sm
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5
    font.pixelSize: Theme.font.base
    implicitWidth: contentItem.implicitWidth
    implicitHeight: Math.max(indicator.implicitHeight, contentItem.implicitHeight)

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.text

    indicator: Rectangle {
        id: dot
        implicitWidth: 18
        implicitHeight: 18
        x: 0
        y: (control.height - height) / 2
        radius: width / 2
        color: "transparent"
        border.width: control.checked ? 0 : 1
        border.color: control.hovered ? Theme.foreground : Theme.input
        Behavior on border.color { ColorAnimation { duration: Theme.motion.fast } }

        // seçili daire dolgusu (accent)
        Rectangle {
            anchors.fill: parent
            radius: dot.radius
            visible: control.checked
            color: Theme.accent
        }
        // içteki açık nokta
        Rectangle {
            anchors.centerIn: parent
            visible: control.checked
            width: dot.width * 0.4
            height: width
            radius: width / 2
            color: Theme.accentForeground
        }

        FocusRing {
            active: control.visualFocus
            cornerRadius: dot.radius
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
