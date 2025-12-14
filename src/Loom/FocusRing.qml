import QtQuick

// Klavye-focus halkası: parent'ı saran ince accent ring; 'active' ile görünür.
// Public tip (PLAN.md #15): Loom.FocusRing.
Rectangle {
    id: ring
    property bool active: false
    property real cornerRadius: Theme.radiusMd

    anchors.fill: parent
    anchors.margins: -3
    radius: ring.cornerRadius + 3
    color: "transparent"
    border.color: Theme.ring
    border.width: 2
    visible: ring.active
}
