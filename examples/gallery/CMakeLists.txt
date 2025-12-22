# Executable target adı (galleryapp) URI'den (Gallery) farklı — case-insensitive
# macOS'ta modül çıktı dizini 'Gallery' ile executable çakışmasın (PLAN.md #25).
qt_add_executable(galleryapp
    main.cpp
)

# I18n.qml saf-QML singleton → qt_add_qml_module'dan ÖNCE işaretle.
set_source_files_properties(I18n.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(galleryapp
    URI Gallery
    VERSION 1.0
    QML_FILES
        Main.qml
        I18n.qml
        CodeBlock.qml
        Swatch.qml
        TokenSection.qml
        OverviewPage.qml
        ThemePage.qml
        ButtonPage.qml
        CardPage.qml
        InputsPage.qml
        BadgePage.qml
        FeedbackPage.qml
    RESOURCES
        star.svg
)

# LoomModule'a link → 'import Loom' runtime'da çözülür (PLAN.md §4.1).
target_link_libraries(galleryapp PRIVATE
    Qt6::Quick
    LoomModule
)

# macOS AGL link-stub'ına yönlendir (root CMakeLists'te üretiliyor).
if(APPLE AND LOOM_AGL_STUB_DIR)
    target_link_options(galleryapp PRIVATE -F${LOOM_AGL_STUB_DIR})
endif()
