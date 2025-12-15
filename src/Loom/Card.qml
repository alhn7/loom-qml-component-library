import QtQuick
import QtQuick.Layouts

// Loom Card — named slot'lar (header/content/footer) Component + iç Loader ile
// (PLAN.md #6, #20). Opsiyonel elevation gölgesi (Loom.Elevation).
Item {
    id: control

    property Component header: null
    property Component content: null
    property Component footer: null
    property int padding: Theme.spacing.lg
    property int elevation: 0

    implicitWidth: Math.max(240, col.implicitWidth + control.padding * 2)
    implicitHeight: col.implicitHeight + control.padding * 2

    Elevation {
        anchors.fill: bg
        level: control.elevation
        cornerRadius: bg.radius
    }
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusLg
        color: Theme.card
        border.color: Theme.border
        border.width: 1
    }
    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: control.padding
        spacing: Theme.spacing.md

        Loader {
            Layout.fillWidth: true
            active: control.header !== null
            visible: active
            sourceComponent: control.header
        }
        Loader {
            Layout.fillWidth: true
            active: control.content !== null
            visible: active
            sourceComponent: control.content
        }
        Loader {
            Layout.fillWidth: true
            active: control.footer !== null
            visible: active
            sourceComponent: control.footer
        }
    }
}
