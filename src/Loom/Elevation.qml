import QtQuick
import QtQuick.Effects

// Verilen alanın arkasına yumuşak gölge çizer (MultiEffect, Qt 6.5+).
// level: 0 none · 1 sm · 2 md · 3 lg. cornerRadius kaynakla aynı olmalı.
// Public tip (PLAN.md #15): Loom.Elevation. Perf: statik gölge, küçük blur.
Item {
    id: root
    property int level: 1
    property real cornerRadius: Theme.radiusLg
    visible: root.level > 0

    readonly property real _blur: root.level === 1 ? 0.5 : root.level === 2 ? 0.85 : 1.0
    readonly property real _yoff: root.level === 1 ? 2  : root.level === 2 ? 8   : 16
    readonly property real _op:   root.level === 1 ? 0.12 : root.level === 2 ? 0.20 : 0.28

    // Görünmez siyah kaynak → MultiEffect bunu gölgeye çevirir; kaynağın kendisi
    // üstteki opak card arka planının arkasında kaldığı için yalnız gölge görünür.
    // Kaynak görünür + layer.enabled → geçerli texture; üstteki opak card bg
    // bu kutuyu tamamen örttüğü için yalnızca taşan gölge görünür.
    Rectangle {
        id: caster
        anchors.fill: parent
        radius: root.cornerRadius
        color: Theme.card
        layer.enabled: true
    }
    MultiEffect {
        anchors.fill: caster
        source: caster
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, root._op)
        shadowBlur: root._blur
        shadowVerticalOffset: root._yoff
    }
}
