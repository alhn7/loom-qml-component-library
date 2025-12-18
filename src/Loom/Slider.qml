import QtQuick
import QtQuick.Templates as T

// Loom Slider — token'lı groove + accent dolu kısım + sürüklenebilir thumb.
// T.Slider üstüne (PLAN.md §6): focus / klavye / drag bedava, görseli biz çiziyoruz.
T.Slider {
    id: control

    implicitWidth: 200
    implicitHeight: 20
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5

    background: Rectangle {
        id: groove
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 6
        width: control.availableWidth
        height: implicitHeight
        radius: height / 2
        color: Theme.input

        // dolu kısım — visualPosition (mirroring-uyumlu) ile accent'e boyanır
        Rectangle {
            width: control.visualPosition * groove.width
            height: groove.height
            radius: groove.radius
            color: Theme.accent
        }
    }

    handle: Rectangle {
        id: handleRect
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 18
        implicitHeight: 18
        radius: width / 2
        color: "white"
        border.width: (control.hovered || control.pressed) ? 2 : 1
        border.color: (control.hovered || control.pressed) ? Theme.accent : Theme.border
        scale: control.pressed ? 1.15 : (control.hovered ? 1.08 : 1.0)
        Behavior on scale {
            NumberAnimation { duration: Theme.motion.fast; easing.type: Theme.motion.easing }
        }

        FocusRing {
            active: control.visualFocus
            cornerRadius: handleRect.radius
        }
    }
}
