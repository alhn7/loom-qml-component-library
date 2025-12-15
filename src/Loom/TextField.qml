import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts

// Loom TextField — üst label + input (T.TextField) + helper/error metni.
// variant: outline | filled · size: small | medium | large
ColumnLayout {
    id: root

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property alias echoMode: field.echoMode
    property alias inputField: field
    property string label: ""
    property string helperText: ""
    property string errorText: ""
    property bool error: false
    property string variant: "outline"
    property string size: "medium"

    readonly property int _h: root.size === "small" ? 32 : root.size === "large" ? 44 : 38
    readonly property int _fontSize: root.size === "small" ? Theme.font.sm
        : root.size === "large" ? Theme.font.lg : Theme.font.base

    spacing: Theme.spacing.xs
    opacity: enabled ? 1.0 : 0.5

    Text {
        visible: root.label !== ""
        text: root.label
        color: Theme.foreground
        font.pixelSize: Theme.font.sm
        font.weight: Theme.font.medium
    }

    T.TextField {
        id: field
        Layout.fillWidth: true
        implicitHeight: root._h
        leftPadding: Theme.spacing.md
        rightPadding: Theme.spacing.md
        verticalAlignment: TextInput.AlignVCenter
        color: Theme.foreground
        placeholderTextColor: Theme.mutedForeground
        selectionColor: Theme.accent
        selectedTextColor: Theme.accentForeground
        font.pixelSize: root._fontSize

        background: Rectangle {
            radius: Theme.radiusMd
            color: root.variant === "filled" ? Theme.muted : "transparent"
            border.width: (field.activeFocus || root.error) ? 2 : 1
            border.color: root.error ? Theme.destructive
                : field.activeFocus ? Theme.accent : Theme.input
        }
    }

    Text {
        visible: (root.error && root.errorText !== "")
            || (!root.error && root.helperText !== "")
        text: root.error ? root.errorText : root.helperText
        color: root.error ? Theme.destructive : Theme.mutedForeground
        font.pixelSize: Theme.font.xs
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}
