import QtQuick
import QtQuick.Templates as T

// Loom ComboBox — T.ComboBox üstüne düz seçim (select). Kapalı kutu TextField
// gibi border-emphasis (focus/açık → 2px accent); chevron açıkken döner; popup
// liste elevation gölgeli. String-array model. size: small | medium | large.
//
// qmllint: delegate ayrı scope → KÖK control'e erişme. Highlight ListView.isCurrentItem
// + item.hovered ile; control.delegateModel/highlightedIndex yalnız popup (control scope).
T.ComboBox {
    id: control

    property string size: "medium"
    property string placeholderText: ""

    readonly property int _h: control.size === "small" ? 32 : control.size === "large" ? 44 : 38
    readonly property int _fontSize: control.size === "small" ? Theme.font.sm
        : control.size === "large" ? Theme.font.lg : Theme.font.base
    readonly property bool _open: control.popup.visible
    readonly property bool _active: control.activeFocus || control._open

    implicitWidth: Math.max(180, control.implicitContentWidth + control.leftPadding + control.rightPadding)
    implicitHeight: control._h
    leftPadding: Theme.spacing.md
    rightPadding: control.indicator.width + Theme.spacing.md
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5
    font.pixelSize: control._fontSize

    contentItem: Text {
        text: control.currentIndex >= 0 ? control.displayText : control.placeholderText
        color: control.currentIndex >= 0 ? Theme.foreground : Theme.mutedForeground
        font: control.font
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    indicator: Text {
        x: control.width - width - Theme.spacing.md
        y: (control.height - height) / 2
        text: "▾"
        color: control._active ? Theme.accent : Theme.mutedForeground
        font.pixelSize: Theme.font.lg
        rotation: control._open ? 180 : 0
        Behavior on rotation {
            NumberAnimation { duration: Theme.motion.fast; easing.type: Theme.motion.easing }
        }
    }

    background: Rectangle {
        radius: Theme.radiusMd
        color: "transparent"
        border.width: control._active ? 2 : 1
        border.color: control._active ? Theme.accent
            : control.hovered ? Theme.mutedForeground : Theme.input
    }

    delegate: T.ItemDelegate {
        id: item
        required property var modelData
        width: ListView.view.width
        // Headless T.ItemDelegate içeriğe göre otomatik boylanmaz → yüksekliği
        // metin + padding'den açıkça türet (yoksa satır 0px, popup görünmez).
        implicitHeight: cbText.implicitHeight + item.topPadding + item.bottomPadding
        topPadding: Theme.spacing.sm
        bottomPadding: Theme.spacing.sm
        leftPadding: Theme.spacing.md
        rightPadding: Theme.spacing.md
        hoverEnabled: true
        text: item.modelData

        contentItem: Text {
            id: cbText
            text: item.text
            color: Theme.foreground
            font.pixelSize: Theme.font.base
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            radius: Theme.radiusSm
            color: (item.hovered || item.ListView.isCurrentItem) ? Theme.muted : "transparent"
        }
    }

    popup: T.Popup {
        y: control.height + 4
        width: control.width
        implicitHeight: Math.min(listView.contentHeight + 2, 260)
        padding: 1

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.motion.fast }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.motion.fast }
        }

        contentItem: ListView {
            id: listView
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
        }

        background: Item {
            Elevation { anchors.fill: pbg; level: 2; cornerRadius: pbg.radius }
            Rectangle {
                id: pbg
                anchors.fill: parent
                radius: Theme.radiusMd
                color: Theme.card
                border.color: Theme.border
                border.width: 1
            }
        }
    }
}
