import QtQuick
import QtQuick.Templates as T

// Loom ProgressBar — token'lı track + accent dolu kısım. T.ProgressBar üstüne:
// determinate (value/from/to → position) veya indeterminate (kayan segment).
// Display component → FocusRing/etkileşim yok; T.ProgressBar Accessible.ProgressBar verir.
T.ProgressBar {
    id: control

    implicitWidth: 200
    implicitHeight: 8

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 8
        radius: height / 2
        color: Theme.input
    }

    contentItem: Item {
        id: fill
        implicitWidth: 200
        implicitHeight: 8
        clip: true

        // determinate dolu kısım — position (0..1) ile boyanır.
        Rectangle {
            width: control.position * fill.width
            height: fill.height
            radius: height / 2
            color: Theme.accent
            visible: !control.indeterminate
            Behavior on width {
                NumberAnimation { duration: Theme.motion.base; easing.type: Theme.motion.easing }
            }
        }

        // indeterminate — track içinde sağa süzülen segment. Kaynak control.width
        // (deklaratif, erken çözülür) → fill.width=0 timing tuzağına düşmez.
        Rectangle {
            id: sweep
            visible: control.indeterminate
            width: control.width * 0.4
            height: fill.height
            radius: height / 2
            color: Theme.accent
            SequentialAnimation on x {
                running: control.indeterminate && control.visible
                loops: Animation.Infinite
                NumberAnimation {
                    from: -control.width * 0.4
                    to: control.width
                    duration: 1100
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
