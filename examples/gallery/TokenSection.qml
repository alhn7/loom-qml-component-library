import QtQuick
import QtQuick.Layouts
import Loom as Loom

// Başlıklı bölüm: başlık + ayraç + içeriğin aktığı bir Flow.
ColumnLayout {
    id: root
    property string title
    default property alias content: holder.data
    spacing: Loom.Theme.spacing.md

    Text {
        text: root.title
        color: Loom.Theme.foreground
        font.pixelSize: Loom.Theme.font.lg
        font.weight: Loom.Theme.font.semibold
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: Loom.Theme.border
    }
    Flow {
        id: holder
        Layout.fillWidth: true
        spacing: Loom.Theme.spacing.lg
    }
}
