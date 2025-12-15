import QtQuick
import QtQuick.Templates as T

// Loom Button — QtQuick.Templates üstüne (headless davranış + Loom görseli).
// variant: primary | secondary | outline | ghost | destructive
// size:    small | medium | large
T.Button {
    id: control

    property string variant: "primary"
    property string size: "medium"
    property bool loading: false
    // İkon: QQC2'nin hazır 'icon' grubu kullanılır → 'icon.source: "..."'

    readonly property bool _hasIcon: control.icon.source.toString() !== ""
    readonly property bool _filled: control.variant === "primary"
        || control.variant === "destructive" || control.variant === "secondary"
    readonly property int _h: control.size === "small" ? 32 : control.size === "large" ? 44 : 38
    readonly property int _padH: control.size === "small" ? 12 : control.size === "large" ? 20 : 16
    readonly property int _iconSize: control.size === "small" ? 14 : control.size === "large" ? 20 : 16
    readonly property int _fontSize: control.size === "small" ? Theme.font.sm
        : control.size === "large" ? Theme.font.lg : Theme.font.base
    readonly property color _bg: control.variant === "primary" ? Theme.accent
        : control.variant === "destructive" ? Theme.destructive
        : control.variant === "secondary" ? Theme.muted : "transparent"
    readonly property color _fg: control.variant === "primary" ? Theme.accentForeground
        : control.variant === "destructive" ? Theme.destructiveForeground : Theme.foreground

    implicitHeight: control._h
    implicitWidth: Math.max(control._h, contentItem.implicitWidth + control.leftPadding + control.rightPadding)
    leftPadding: control._padH
    rightPadding: control._padH
    topPadding: 0
    bottomPadding: 0
    hoverEnabled: true
    opacity: control.enabled ? 1.0 : 0.5
    font.pixelSize: control._fontSize
    font.weight: Theme.font.medium

    Accessible.role: Accessible.Button
    Accessible.name: control.text

    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        color: {
            if (!control._filled) {
                if (control.pressed) return Theme.border
                if (control.hovered) return Theme.muted
                return "transparent"
            }
            if (control.pressed) return Qt.darker(control._bg, 1.15)
            if (control.hovered) return Qt.darker(control._bg, 1.07)
            return control._bg
        }
        border.width: control.variant === "outline" ? 1 : 0
        border.color: Theme.border

        FocusRing {
            active: control.visualFocus
            cornerRadius: bg.radius
        }
    }

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        Row {
            id: row
            anchors.centerIn: parent
            spacing: (control.text !== "" && (control.loading || control._hasIcon)) ? Theme.spacing.sm : 0

            Item {
                id: leading
                width: control._iconSize
                height: control._iconSize
                anchors.verticalCenter: parent.verticalCenter
                visible: control.loading || control._hasIcon

                Image {
                    anchors.fill: parent
                    visible: !control.loading && control._hasIcon
                    source: control.icon.source
                    fillMode: Image.PreserveAspectFit
                }
                // Sonsuz dönen spinner (PLAN.md #21): loading iken icon yerini alır.
                Item {
                    id: spinner
                    anchors.fill: parent
                    visible: control.loading
                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "transparent"
                        border.width: 2
                        border.color: Qt.rgba(control._fg.r, control._fg.g, control._fg.b, 0.3)
                    }
                    Rectangle {
                        width: 3
                        height: 3
                        radius: 1.5
                        color: control._fg
                        x: parent.width / 2 - 1.5
                        y: -1
                    }
                    RotationAnimator on rotation {
                        running: control.loading
                        from: 0
                        to: 360
                        duration: 700
                        loops: Animation.Infinite
                    }
                }
            }

            Text {
                id: label
                anchors.verticalCenter: parent.verticalCenter
                visible: control.text !== ""
                text: control.text
                color: control._fg
                font: control.font
            }
        }
    }
}
