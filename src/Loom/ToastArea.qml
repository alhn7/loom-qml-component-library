import QtQuick

// Loom ToastArea — köşeye sabit overlay host (orchestrator, saf görseli yok →
// Elevation/FocusRing gibi building block). show(opts) ile transient, auto-dismiss
// Toast spawn eder; stacking + giriş/çıkış animasyonu dahili.
// position: "top-left" | "top-center" | "top-right"
//         | "bottom-left" | "bottom-center" | "bottom-right" (default).
Item {
    id: area

    property string position: "bottom-right"
    property int duration: 4000          // auto-dismiss (ms); 0 → kalıcı
    property int gap: Theme.spacing.sm
    property int margins: Theme.spacing.lg
    property int toastWidth: 360

    readonly property bool _isTop: area.position.indexOf("top") === 0
    readonly property bool _isRight: area.position.indexOf("right") >= 0
    readonly property bool _isCenter: area.position.indexOf("center") >= 0

    // show({ variant, title, text, action, duration }) → spawn edilen nesneyi döner.
    function show(opts: var): var {
        return entry.createObject(stack, {
            w: area.toastWidth,
            variant: opts.variant !== undefined ? opts.variant : "info",
            title: opts.title !== undefined ? opts.title : "",
            text: opts.text !== undefined ? opts.text : "",
            action: opts.action !== undefined ? opts.action : "",
            life: opts.duration !== undefined ? opts.duration : area.duration
        })
    }

    Column {
        id: stack
        spacing: area.gap
        width: area.toastWidth

        // Köşe yerleşimi position'dan türer (tek kaynak). Dikey = anchor;
        // yatay = x (left+right+hCenter aynı anda anchor'lanamaz).
        x: area._isCenter ? (area.width - width) / 2
            : area._isRight ? (area.width - width - area.margins)
            : area.margins
        anchors.top: area._isTop ? parent.top : undefined
        anchors.bottom: area._isTop ? undefined : parent.bottom
        anchors.topMargin: area.margins
        anchors.bottomMargin: area.margins

        // Giriş: fade + edge'den slide. Kalanların kayması move ile bedava.
        add: Transition {
            NumberAnimation {
                property: "opacity"; from: 0; to: 1
                duration: Theme.motion.base; easing.type: Theme.motion.easing
            }
            NumberAnimation {
                property: "x"
                from: area._isCenter ? 0 : (area._isRight ? 24 : -24); to: 0
                duration: Theme.motion.base; easing.type: Theme.motion.easing
            }
        }
        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: Theme.motion.base; easing.type: Theme.motion.easing
            }
        }
    }

    // Transient sarmalayıcı: Loom.Toast + auto-dismiss + çıkış animasyonu.
    Component {
        id: entry
        Item {
            id: wrap
            property string variant: "info"
            property string title: ""
            property string text: ""
            property string action: ""
            property int life: 0
            property real w: 360

            width: wrap.w
            height: t.implicitHeight

            function dismiss() { outAnim.start() }

            Toast {
                id: t
                width: parent.width
                variant: wrap.variant
                title: wrap.title
                text: wrap.text
                action: wrap.action
                onClosed: wrap.dismiss()
                onActionTriggered: wrap.dismiss()
            }

            Timer {
                running: wrap.life > 0
                interval: wrap.life
                onTriggered: wrap.dismiss()
            }

            NumberAnimation {
                id: outAnim
                target: wrap
                property: "opacity"
                to: 0
                duration: Theme.motion.fast
                easing.type: Theme.motion.easing
                onFinished: wrap.destroy()
            }
        }
    }
}
