cmake_minimum_required(VERSION 3.21)

project(Loom VERSION 1.0 LANGUAGES CXX)

# Min Qt 6.5 (PLAN.md): QTP0001 + modern QML-module CMake policy'leri.
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

# Tüm QML modülleri tek ortak import dizinine çıksın → qmllint/qmlls ve runtime
# kardeş modülleri (Loom) tutarlı bulur (FetchContent/QML-modül tooling pürüzü
# çözümü, PLAN.md §4). add_subdirectory'lerden ÖNCE set edilmeli.
# Sadece top-level build'de; Loom bir bağımlılık olarak tüketildiğinde tüketici
# kendi QT_QML_OUTPUT_DIRECTORY'sini belirler.
if(PROJECT_IS_TOP_LEVEL)
    set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml")
endif()

# --- macOS workaround: Qt 6.9, 'AGL' framework'üne link-referansı veriyor; yeni
# macOS SDK'ları (>=26) AGL'yi SDK'dan kaldırdı (linklenecek .tbd stub yok).
# Framework runtime dyld cache'inde hâlâ var, yani SADECE link-time'da stub lazım.
# Boş bir AGL.framework üretip linker'ı oraya yönlendiriyoruz; runtime Metal/RHI.
if(APPLE)
    set(LOOM_AGL_STUB_DIR "${CMAKE_BINARY_DIR}/agl-stub" CACHE INTERNAL "")
    set(_agl_fw "${LOOM_AGL_STUB_DIR}/AGL.framework")
    if(CMAKE_OSX_ARCHITECTURES)
        set(_agl_arch "${CMAKE_OSX_ARCHITECTURES}")
    else()
        set(_agl_arch "${CMAKE_SYSTEM_PROCESSOR}")
    endif()
    file(MAKE_DIRECTORY "${_agl_fw}/Versions/A")
    file(WRITE "${CMAKE_BINARY_DIR}/_agl_stub.cpp" "void _loom_agl_stub(void){}\n")
    # -isysroot şart: Xcode derleyicisi doğrudan çağrılınca sysroot'suz libc++'ı bulamaz.
    execute_process(
        COMMAND ${CMAKE_CXX_COMPILER} -isysroot ${CMAKE_OSX_SYSROOT}
                -dynamiclib -arch ${_agl_arch}
                -Wl,-install_name,/System/Library/Frameworks/AGL.framework/Versions/A/AGL
                -o "${_agl_fw}/Versions/A/AGL"
                "${CMAKE_BINARY_DIR}/_agl_stub.cpp"
        RESULT_VARIABLE _agl_rc ERROR_VARIABLE _agl_err)
    if(NOT _agl_rc EQUAL 0)
        message(FATAL_ERROR "AGL stub derlenemedi (rc=${_agl_rc}):\n${_agl_err}")
    endif()
    file(CREATE_LINK "Versions/A/AGL" "${_agl_fw}/AGL" SYMBOLIC)
    file(CREATE_LINK "A" "${_agl_fw}/Versions/Current" SYMBOLIC)
endif()

add_subdirectory(src/Loom)

# Örnekler/gallery yalnızca Loom top-level iken derlenir (tüketici FetchContent
# ile aldığında değil).
if(PROJECT_IS_TOP_LEVEL)
    add_subdirectory(examples/gallery)
endif()
