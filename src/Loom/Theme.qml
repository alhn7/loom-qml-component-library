pragma Singleton
import QtQuick

// Loom design-token sistemi (PLAN.md §5).
// Tohum token'ları (accent/radius/fontFamily/appearance) tüketici override eder;
// semantik renkler yazılabilir, default'ları appearance'a bağlı binding'dir —
// birine değer atanırsa binding kopar ve o renk flip'te DONAR (bilinçli, §5.3).
QtObject {
    id: theme

    enum Appearance { Light, Dark }

    // --- Ölçek grupları için inline component tipleri ---
    // (file-local + statik tipli → qmllint/qmlls üyeleri çözebilir)
    component SpacingScale: QtObject {
        readonly property real xs: 4
        readonly property real sm: 8
        readonly property real md: 12
        readonly property real lg: 16
        readonly property real xl: 24
        readonly property real xxl: 32
    }
    component TypeScale: QtObject {
        property string family: ""
        readonly property int xs: 12
        readonly property int sm: 13
        readonly property int base: 14
        readonly property int lg: 16
        readonly property int xl: 18
        readonly property int xxl: 24
        readonly property int regular:  Font.Normal
        readonly property int medium:   Font.Medium
        readonly property int semibold: Font.DemiBold
    }
    component MotionScale: QtObject {
        readonly property int fast: 120
        readonly property int base: 180
        readonly property int slow: 240
        readonly property int easing: Easing.OutCubic
    }

    // --- Tohum token'lar (önerilen override yüzeyi) ---
    property int appearance: Theme.Light
    readonly property bool isDark: appearance === Theme.Dark
    property color accent: "#6366f1"
    property real radius: 8
    property string fontFamily: ""   // boş → platform sistem fontu

    // --- Semantik renkler (yazılabilir; default'lar appearance binding'i) ---
    property color background:      isDark ? "#0a0a0a" : "#ffffff"
    property color foreground:      isDark ? "#fafafa" : "#0a0a0a"
    property color card:            isDark ? "#0f0f10" : "#ffffff"
    property color cardForeground:  isDark ? "#fafafa" : "#0a0a0a"
    property color muted:           isDark ? "#262626" : "#f4f4f5"
    property color mutedForeground: isDark ? "#a1a1aa" : "#71717a"
    property color border:          isDark ? "#27272a" : "#e4e4e7"
    property color input:           isDark ? "#3f3f46" : "#e4e4e7"
    property color ring:            Qt.rgba(accent.r, accent.g, accent.b, 0.5)
    // accentForeground default'u accent parlaklığından otomatik (overridable, §5.3)
    property color accentForeground:      theme.contrastOn(accent)
    property color destructive:           isDark ? "#dc2626" : "#ef4444"
    property color destructiveForeground: "#ffffff"
    property color success:               isDark ? "#16a34a" : "#22c55e"
    property color successForeground:     "#ffffff"

    // --- Radius ölçeği (tohum radius'tan türetilir) ---
    readonly property real radiusSm:   radius * 0.5
    readonly property real radiusMd:   radius
    readonly property real radiusLg:   radius * 1.5
    readonly property real radiusFull: 9999

    // --- Ölçek grupları (inline component tipleriyle) ---
    readonly property SpacingScale spacing: SpacingScale {}
    readonly property TypeScale    font:    TypeScale { family: theme.fontFamily }
    readonly property MotionScale  motion:  MotionScale {}

    // sRGB relative luminance → en iyi kontrast için siyah/beyaz seç
    function contrastOn(c) {
        var lum = 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b
        return lum > 0.55 ? "#0a0a0a" : "#ffffff"
    }
}
