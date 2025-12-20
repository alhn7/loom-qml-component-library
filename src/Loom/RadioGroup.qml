import QtQuick
import QtQuick.Controls.Basic as C

// Loom RadioGroup — model'den dikey RadioButton listesi üretir; ortak ButtonGroup ile tek-seç.
// model: ["A", "B"] (düz string) ya da [{ text, enabled, checked }] (nesne).
// Seçili öğenin text'i `currentValue` ile okunur.
Column {
    id: control

    property var model: []
    readonly property string currentValue: bg.checkedButton ? bg.checkedButton.text : ""

    spacing: Theme.spacing.sm

    C.ButtonGroup { id: bg }

    Repeater {
        model: control.model
        onItemAdded: function(index, obj) { bg.addButton(obj) }
        delegate: RadioButton {
            required property var modelData
            text: modelData.text !== undefined ? modelData.text : modelData
            enabled: modelData.enabled !== undefined ? modelData.enabled : true
            checked: modelData.checked === true
        }
    }
}
