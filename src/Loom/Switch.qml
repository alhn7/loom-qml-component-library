import QtQuick
import QtQuick.Templates as T

// Loom Switch — pill track + animasyonlu beyaz thumb, etiket sağda (PLAN.md #9).
T.Switch {
    id: control

    spacing: Theme.spacing.sm
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5
    font.pixelSize: Theme.font.base
    implicitWidth: contentItem.implicitWidth
    implicitHeight: Math.max(indicator.implicitHeight, contentItem.implicitHeight)

    Accessible.name: control.text

    indicator: Rectangle {
        id: track
        implicitWidth: 40
        implicitHeight: 22
        x: 0
        y: (control.height - height) / 2
        radius: height / 2
        color: control.checked ? Theme.accent : Theme.input
        Behavior on color { ColorAnimation { duration: Theme.motion.fast } }

        FocusRing {
            active: control.visualFocus
            cornerRadius: track.radius
        }

        Rectangle {
            id: thumb
            width: 16
            height: 16
            radius: 8
            y: 3
            x: control.checked ? track.width - width - 3 : 3
            color: "white"
            Behavior on x {
                NumberAnimation {
                    duration: Theme.motion.fast
                    easing.type: Theme.motion.easing
                }
            }
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
