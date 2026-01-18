# Theme.qml saf-QML singleton: pragma Singleton TEK BAŞINA yetmez —
# bu property qt_add_qml_module'dan ÖNCE set edilmeli (PLAN.md §11).
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

# Backing target adı (LoomModule) URI'den (Loom) farklı — Qt build-folder
# çakışma kuralı (PLAN.md #25). import yine 'Loom'.
qt_add_qml_module(LoomModule
    URI Loom
    VERSION 1.0
    QML_FILES
        Theme.qml
        FocusRing.qml
        Elevation.qml
        Button.qml
        Card.qml
        TextField.qml
        ComboBox.qml
        CheckBox.qml
        Switch.qml
        Slider.qml
        RadioButton.qml
        RadioGroup.qml
        Badge.qml
        ProgressBar.qml
        Alert.qml
        Toast.qml
        ToastArea.qml
        Tooltip.qml
)
