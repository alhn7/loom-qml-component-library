# Loom — v1 Plan Dokümanı (rev. 2)

> Modern, minimal bir QML UI component kütüphanesi. Web'deki **shadcn/ui · Radix · MUI**'nin QML/Qt karşılığı: insanlar kendi Qt projelerine kolayca dahil edip hazır, güzel görünen, tutarlı componentleri kullanabilsin.

**Durum:** Planlama + 3 turlu tasarım incelemesi + ekosistem uyumluluk kontrolü tamam, implementasyon bekliyor.
**Tarih:** 2026-06-12 · **rev. 2:** 26 karar netleşti (3 agent doğrulama turu "buildable" onayı + ekosistem karşılaştırması — bkz. §15, §16).
**Min Qt:** 6.5 · **Build:** CMake · **Dil:** %100 QML (v1'de sıfır C++)

---

## 1. Hedefler ve Kapsam Dışı

### Hedefler
- `import Loom as Loom` deyip `Loom.Button {}` gibi hazır componentleri kullanabilmek.
- Tek satırla yeniden markalama (rebrand): `Loom.Theme.accent = "#ff5a5f"`.
- Light / dark mod, kutudan çıkar çıkmaz tutarlı görünüm; çalışma zamanında canlı tema değişimi.
- Tüketicinin projesine **kolay dahil etme** (FetchContent veya submodule drop-in).

### Kapsam dışı (v1)
- C++ tipleri (bilinçli olarak hayır — bkz. §3).
- Karmaşık componentler (Dialog, Menu, Tabs, DataTable...) → v2.
- Garantili RTL desteği (mirroring-uyumlu yazılır ama test/garanti edilmez — §8.7).
- Bundled font / ikon seti → v2.
- Per-subtree theming (alt-ağaca ayrı tema/colorSet). v1 = tek global `Loom.Theme`; Kirigami/Material'ın attached-Theme cascade'i v2 (§16).

---

## 2. Locked Kararlar (özet)

| Karar | Sonuç |
|---|---|
| Ad / URI | `Loom` → **`import Loom as Loom`** (nitelikli) |
| v1 kuralı | **Sıfır C++** — saf QML |
| Component temeli | `import QtQuick.Templates as T` (headless davranış + custom görsel) |
| Görsel dil | Modern minimal (shadcn/Radix) |
| Dağıtım | **FetchContent** (link satırı dahil) · ayrıca submodule drop-in (ayrı qmldir) |
| Theme | Tohum token + semantik token (semantikler **yazılabilir**, override edilince donar) |
| Min Qt | 6.5 |
| Mod. VERSION / tag | **1.0** / **v1.0.0** |
| v1 componentler | Button · TextField · Card · CheckBox · Switch · Badge |

---

## 3. Neden Sıfır C++ (en kritik karar)

Saf QML kalırsak **üç dağıtım yolu birden** açık kalır (FetchContent, submodule drop-in, find_package). İlk derlenen C++ tipini eklediğimiz an: submodule drop-in ölür ve platform × Qt-sürümü başına **binary derleme matrisi** çıkar (bakım kâbusu). Design-token tabanlı theme'in C++'a ihtiyacı **yok**. → **v1'de C++ eklemiyoruz.**

---

## 4. Dağıtım Modeli

Saf QML olduğu için tek yöntem dayatmıyoruz.

### 4.1 FetchContent (önerilen — "mutlu yol")
```cmake
include(FetchContent)
FetchContent_Declare(
    Loom
    GIT_REPOSITORY https://github.com/<user>/loom.git
    GIT_TAG        v1.0.0
)
FetchContent_MakeAvailable(Loom)

# ZORUNLU: modülün resource'ları (qmldir vb.) binary'ye gömülsün diye linkle.
# Bu satır olmadan runtime'da 'module "Loom" is not installed' hatası alınır.
# Not: backing target adı 'LoomModule' (URI 'Loom'dan farklı — Qt build-folder çakışması önlemi).
target_link_libraries(myapp PRIVATE LoomModule)
```
QML tarafında: `import Loom as Loom`.

### 4.2 Git submodule / drop-in (CMake istemeyenler)
- **Tek `qmldir` vardır:** `qt_add_qml_module`'ün otomatik ürettiği dosya. Elle bakımlı ayrı qmldir YOK (çift bakım/çakışma derdi yok).
- Bir CMake **install/stage** adımı, modülü (otomatik `qmldir` + `Theme.qml` ve tüm tip `.qml`'leri) tek bir klasöre — `dist/Loom/` — toplar. Bu paket release'de üretilip repoya commit'lenir / release'e eklenir.
- CMake'siz kullanıcı sadece `dist/Loom/`'u kopyalar ve QML import path'e ekler (`QML_IMPORT_PATH` / `-I`). qmldir, .qml'lerle aynı dizinde olduğu için tip satırları doğru çözülür.

### 4.3 install + find_package (ileride, opsiyonel)

> **Tooling notu:** FetchContent + QML modülünün **runtime'ı sağlam**, ama *tooling* tarafında (qmllint, Qt Creator autocomplete) bilinen pürüzleri var. Bunu repo içindeki gallery app ile by-pass ediyoruz.

---

## 5. Theme / Token Sistemi — **asıl değer önerisi**

Tek yazılabilir singleton: `Loom.Theme`. Tüketici "tohum" token'ları set eder; semantik token'lar bunlara/`appearance`'a bağlı **yazılabilir** property'lerdir (default'ları binding).

### 5.1 Tohum token'lar (önerilen override yüzeyi)
| Token | Varsayılan | Açıklama |
|---|---|---|
| `appearance` | `Theme.Light` | `Theme.Light` / `Theme.Dark` |
| `accent` | `#6366f1` | Marka / vurgu rengi |
| `radius` | `8` | Köşe yarıçapı ölçek tabanı (px) |
| `fontFamily` | sistem fontu | Boşsa platform default fontu kullanılır |

### 5.2 Semantik renkler — **yazılabilir** (default'ları `appearance`'a bağlı binding)
| Token | Light | Dark |
|---|---|---|
| `background` | `#ffffff` | `#0a0a0a` |
| `foreground` | `#0a0a0a` | `#fafafa` |
| `card` | `#ffffff` | `#0f0f10` |
| `cardForeground` | `#0a0a0a` | `#fafafa` |
| `muted` | `#f4f4f5` | `#262626` |
| `mutedForeground` | `#71717a` | `#a1a1aa` |
| `border` | `#e4e4e7` | `#27272a` |
| `input` | `#e4e4e7` | `#3f3f46` |
| `ring` | `accent` (alpha) | `accent` (alpha) |
| `accent` | `#6366f1` (tohum) | (tohum) |
| `accentForeground` | **accent parlaklığından otomatik** (siyah/beyaz) | otomatik |
| `destructive` | `#ef4444` | `#dc2626` |
| `destructiveForeground` | `#ffffff` | `#ffffff` |
| `success` | `#22c55e` | `#16a34a` |
| `successForeground` | `#ffffff` | `#ffffff` |

> `filled` TextField dolgusu ayrı token istemez → mevcut `muted` kullanılır.

### 5.3 Override çözüm kuralı (kritik)
- Her semantik renk **yazılabilir** bir property'dir; **default değeri** `isDark ? dark : light` binding'idir.
- Tüketici bir semantik renge değer atarsa, QML kuralı gereği **binding kopar** → o renk `appearance` flip'inde **donar** (atanan değerde kalır). Bu, "kendi riskinle override et" davranışıdır.
- **accentForeground**: default'u `accent` luminance'ından otomatik siyah/beyaz seçilir (sadece accent değiştiren yaygın senaryoda kontrast bozulmaz); yine de override edilebilir.
- **Önerilen kullanım:** sadece tohum token'ları override et. Semantik renkleri override etmek light/dark flip'i o renk için durdurur — dokümanda uyarılır.

### 5.4 Çalışma zamanı tema değişimi — **destekleniyor**
Property **binding'leri** (`color: Loom.Theme.accent`) tema değişiminde canlı güncellenir. Tek gerçek tuzak: **imperatif atama** (`x.color = Loom.Theme.accent`) — binding'i kopardığı için güncellenmez. Componentlerin hepsi binding kullanır; gallery'de light/dark + accent canlı değişir.

### 5.5 Ölçek token'ları
- **Radius:** `radiusSm = radius*0.5`, `radiusMd = radius`, `radiusLg = radius*1.5`, `radiusFull = 9999`.
- **Spacing** (4px tabanı): `xs=4, sm=8, md=12, lg=16, xl=24, xxl=32` (en büyük `xxl`; `2xl` geçersiz QML identifier).
- **Typography:** boyutlar `xs=12, sm=13, base=14, lg=16, xl=18, xxl=24`; ağırlıklar `regular=400, medium=500, semibold=600`.
- **Elevation/gölge:** `none / sm / md / lg` → `QtQuick.Effects.MultiEffect` (blur, yOffset, opacity).
- **Motion:** süreler `fast=120, base=180, slow=240` ms; easing `Easing.OutCubic`. **Spinner için ayrı:** sürekli dönüş `RotationAnimator { loops: Animation.Infinite; easing.type: Easing.Linear }` (token süreleri sonlu olduğu için spinner ayrı tutulur).

### 5.6 Override API örneği
```qml
import Loom as Loom

Component.onCompleted: {
    Loom.Theme.accent = "#ff5a5f"        // önerilen
    Loom.Theme.radius = 12
    Loom.Theme.appearance = Loom.Theme.Dark
    // Loom.Theme.border = "#333"        // mümkün ama flip'te donar — uyarılır
}
```

---

## 6. Component Temeli (pattern)

- Etkileşimli componentler **`import QtQuick.Templates as T`** üstüne → focus / klavye / hovered-pressed-checked state'leri bedava; görseli biz çizeriz.
- Saf görsel olanlar (Badge) düz `Rectangle` / `Item`. Card, named slot'lar için container.
- **disabled görünüm:** tüm componentlerde tutarlı → kök item `opacity: enabled ? 1.0 : 0.5` + uygun imleç. Ayrı disabled token yok.
- **Public yardımcılar:** `FocusRing` ve `Elevation` bilinçli olarak **public** tiptir (`Loom.FocusRing`, `Loom.Elevation`) — dokümante edilir, API kararlılığı sözü verilir.
- **a11y:** etkileşimlilere `Accessible.role` / `Accessible.name`; Card/Badge'e minimal. (Templates default'larına ek.)
- **RTL:** anchor/Layout'lar `LayoutMirroring`-uyumlu yazılır ama v1'de test/garanti edilmez.

---

## 7. Proje Yapısı

```
ComponentLibrary/
├─ CMakeLists.txt              # qt_standard_project_setup(REQUIRES 6.5)
├─ CMakePresets.json
├─ PLAN.md / README.md
├─ src/Loom/
│  ├─ CMakeLists.txt           # qt_add_qml_module(LoomModule URI Loom VERSION 1.0 ...)
│  ├─ Theme.qml                # singleton (set_source_files_properties ... QT_QML_SINGLETON_TYPE TRUE, qt_add_qml_module'dan ÖNCE)
│  ├─ Button.qml  TextField.qml  Card.qml  CheckBox.qml  Switch.qml  Badge.qml
│  ├─ FocusRing.qml  Elevation.qml      # public yardımcılar
│  └─ (otomatik qmldir, build tree'de)
├─ dist/Loom/                  # release'de stage edilen drop-in paketi (otomatik qmldir + tüm .qml)
├─ examples/gallery/           # showcase / "Storybook"
│  ├─ CMakeLists.txt
│  └─ Main.qml
└─ .github/workflows/ci.yml    # qmllint + matris build (Qt 6.5 & 6.9)
```

---

## 8. v1 Component Spesifikasyonları

### 8.1 Button (`T.Button`)
- **variant:** `primary` · `secondary` · `outline` · `ghost` · `destructive`
- **size:** `sm` · `md` · `lg`
- **state:** default · hover · pressed · focus (ring) · disabled
- **props:** `text`, `variant`, `size`, `enabled`, `icon` (image source: url/string), `loading` (bool)
- **dizilim:** `[icon | spinner] text`. `loading` iken spinner icon yerini alır, text kalır. Spinner = sonsuz `RotationAnimator` (Linear).

### 8.2 TextField (`T.TextField`)
- **variant:** `outline` (varsayılan) · `filled` (dolgu = `muted`)
- **size:** `sm` · `md` · `lg`
- **state:** default · hover · focus (ring) · disabled · error
- **props:** `text`, `placeholderText`, `label` (üst etiket), `helperText`, `error` (bool), `errorText`, `enabled`, `echoMode`
- error iken kenarlık `destructive` + `errorText` gösterilir (varsa `helperText` yerine).

### 8.3 Card (container, named slot'lar)
- **slot'lar:** `header`, `content`, `footer` → **`Component` property + iç `Loader`** (lazy).
- Arka plan `card`, `border`, `radiusLg`, iç `padding`, opsiyonel `elevation` (gölge).
- **props:** `header`, `content`, `footer` (Component), `padding`, `elevation`

### 8.4 CheckBox (`T.CheckBox`)
- **state:** unchecked · checked · **indeterminate** · hover · focus · disabled
- **props:** `text` (etiket **sağda**, tıklanabilir), `checked`, `tristate`, `enabled`

### 8.5 Switch (`T.Switch`)
- **state:** off · on · hover · focus · disabled (thumb geçişi motion token)
- **props:** `checked`, `enabled`, `text` (etiket **sağda**)

### 8.6 Badge (saf görsel)
- **variant:** `default` (accent) · `secondary` · `outline` · `destructive` · `success`
- Pill (radiusFull), küçük tipografi.
- **props:** `text`, `variant`

### 8.7 Ortak
- disabled → §6 global kuralı. a11y → §6. RTL → §6 (uyumlu yazılır, test edilmez).

---

## 9. Gallery / Showcase App
`examples/gallery` — tüm componentleri light/dark + tüm state'lerde gösterir. Üstte light/dark toggle + accent renk seçici → canlı tema override kanıtı. Üç işlev: canlı önizleme (Storybook), tooling pürüzü by-pass, tüketici vitrini.

**Tasarım (rev.):** Tek-uzun-scroll yerine **sidebar navigasyonlu, kategorize** showcase (design-system docs estetiği). Shell `Main.qml` (sidebar `ListView` + header + `StackLayout`); sayfalar ayrı dosyalar: `OverviewPage/ThemePage/ButtonPage/CardPage/InputsPage/BadgePage.qml`. Monospace etiketler (Menlo), accent'li aktif gösterge, noktalı arka plan (`Canvas`), staggered sayfa geçişleri. Galeri kendi component'lerini kullanıyor (dogfooding: Dark toggle = `Loom.Button`). qmllint tuzağı: Repeater delegate'inden kök id (`win`) erişimi "unqualified" sayılır → nav `ListView` + `ListView.isCurrentItem`/`ListView.view` ile çözüldü.

**i18n + kod örnekleri:** `I18n.qml` singleton (en/de/es/tr; `lang` değişince `t(key)` ile tüm metinler canlı güncellenir), sidebar'da dil seçici. Her sayfada açıklayıcı intro + grup başlıkları çevrili. `CodeBlock.qml` — katlanır ("</> Code"/"Hide", `open` prop ile varsayılan açık) + **kopyalanabilir** (saf-QML pano: readonly `TextEdit.selectAll()`+`copy()`). Component adları / variant değerleri / state demo etiketleri (Unchecked/Off...) İngilizce bırakıldı (API terimleri).

---

## 10. Yol Haritası (fazlar + kabul kriteri)

| Faz | İş | Kabul kriteri |
|---|---|---|
| **1. İskelet ✅** | CMake + `Loom` modülü + `Theme` singleton + gallery | ✓ TAMAM: temiz build, `import Loom as Loom` + `Loom.Theme` çalışıyor, qmllint 0 uyarı, offscreen run hatasız |
| **2. Theme API ✅** | Token seti + light/dark + override + auto accentForeground | ✓ TAMAM: gallery'de 15 semantik renk swatch'ı + radius/spacing/typography ölçekleri + accent paleti; canlı light/dark, auto accentForeground kontrastı ve §5.3 override-freeze demosu çalışıyor; qmllint 0 uyarı |
| **3. Button + Card ✅** | İlk 2 component + Elevation/FocusRing helper'ları | ✓ TAMAM: Button 5 variant×3 size + icon/loading-spinner/disabled/focus; Card named slot'lar (header/content/footer) + MultiEffect elevation (0/2/3); gallery'de görsel doğrulandı; qmllint 0 uyarı |
| **4. Kalan 4 ✅** | TextField, CheckBox, Switch, Badge | ✓ TAMAM: TextField (label/helper/error/filled/disabled), CheckBox (unchecked/checked/indeterminate/disabled), Switch (off/on/disabled, animasyonlu), Badge (5 variant); gallery'de görsel doğrulandı; qmllint 0 uyarı. **v1'in 6 component'i tamam.** |
| **5. Dağıtım kanıtı ✅** | Ayrı tüketici proje, FetchContent + link satırı | ✓ TAMAM: ayrı `loom-consumer-test/` projesi FetchContent(SOURCE_DIR) + `target_link_libraries(LoomModule)` ile `import Loom as Loom` → Button/TextField/Switch/Badge render etti (grab ile doğrulandı, `module not installed` hatası yok). Drop-in/install-stage (dist/Loom) → Faz 6. |
| **6. CI + sürümleme** | qmllint + matris CI (6.5/6.9) + README + tag v1.0.0 | CI yeşil; README reçeteleri birebir çalışır |

---

## 11. Teknik Kısıtlar ve Tuzaklar

- **Singleton:** `pragma Singleton` + CMake'te `set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)` — bu çağrı **`qt_add_qml_module`'dan ÖNCE** gelmeli, yoksa singleton kaydolmaz.
- **CMake policy:** `qt_standard_project_setup(REQUIRES 6.5)` → `QTP0001` NEW, `RESOURCE_PREFIX` `/qt/qml`, modül `qrc:/qt/qml/Loom` altına düşer.
- **Target adı ≠ URI:** backing target `LoomModule`, URI `Loom`. Qt: "module URI should be different from the target name to avoid build-folder clashes." `import` yine `Loom`; tüketici `LoomModule`'a linkler.
- **FetchContent link:** tüketici `target_link_libraries(app PRIVATE Loom)` yapmazsa `module "Loom" is not installed` alır (§4.1).
- **Tek qmldir:** sadece auto-gen qmldir var; drop-in paketi (`dist/Loom/`) bir install/stage adımıyla bu qmldir'i + tüm `.qml`'leri aynı dizine toplar (§4.2).
- **Templates importu:** etkileşimlilerde `import QtQuick.Templates as T`, `QtQuick.Controls` DEĞİL.
- **Gölge:** `QtQuick.Effects.MultiEffect` (Qt 6.5+); statik gölgeyi cache'le, blurMax küçük, animasyonlu source'tan kaçın. Faz 3'te ölç.
- **Override binding:** semantik renge imperatif atama binding'i koparır → flip'te donar (§5.3, bilinçli).
- **Spinner:** motion token'ları sonlu; sürekli dönüş ayrı `RotationAnimator` (Linear, Infinite).

---

## 12. v2'ye Ertelenenler
Dialog · Menu · Tooltip · Slider · Tabs · ComboBox · RadioButton · ProgressBar · Toast · ikon seti · bundled font · garantili RTL · find_package kurulumu · QML TestCase davranış testleri · **per-subtree theming (attached Theme / colorSet)** (CI'da v1'de davranış testi yok, sadece qmllint + build).

---

## 13. Açık Sorular
- GitHub repo/kullanıcı adı (FetchContent URL'i) — README yazılırken netleşecek.
- (Hepsi tasarım incelemesinde kapandı — bkz. §15.)

---

## 14. Verification Bulguları (tasarım incelemesi)
- `QT_QML_SINGLETON_TYPE TRUE` gereği — **DOĞRU** (ve `qt_add_qml_module`'dan önce çağrılmalı).
- `MultiEffect` (Qt 6.5) — **DOĞRU** (blur/shadow en ağır efekt; perf önlemleri §11).
- `qt_standard_project_setup(REQUIRES 6.5)` → QTP0001/RESOURCE_PREFIX — **DOĞRU**.
- §4.1 FetchContent eski reçetesi — **EKSİKTİ**, `target_link_libraries` eklendi.
- §4.2 submodule "qmldir otomatik çalışır" — **YANLIŞTI**, ayrı elle qmldir eklendi.
- import ergonomisi — **TUTARSIZDI**, nitelikli `import Loom as Loom`'a sabitlendi.

---

## 15. Tasarım İncelemesi Kararları (22 — izlenebilirlik)

**Raund 1–5 (17):**
1. Import nitelikli: `import Loom as Loom`.
2. Dağıtım: FetchContent'e link satırı + submodule için ayrı qmldir; her iki yol korunur.
3. Tema override: semantik renkler yazılabilir + "tohumda kal" uyarısı + auto accentForeground.
4. Disabled: global `opacity 0.5` + imleç.
5. Runtime tema: destekleniyor; "bozulur" notu kaldırıldı; imperatif atama tuzağı dokümante.
6. Card: named slot'lar (header/content/footer).
7. Button: `icon` = image source; `loading` IN (spinner).
8. TextField: error + errorText/helperText + label + filled variant.
9. CheckBox/Switch: etiket sağda; tristate IN.
10. Font: sistem fontu + opsiyonel `fontFamily` override.
11. Gölge: MultiEffect default, Faz 3'te ölç.
12. Badge: temaya `success`/`successForeground` token eklendi.
13. Versiyon: VERSION 1.0 + tag v1.0.0.
14. Test/CI: qmllint + matris build (6.5 & 6.9) + Faz 5 FetchContent tüketici derlemesi.
15. FocusRing/Elevation: bilinçli public API.
16. a11y: Templates default + temel role/name.
17. RTL: mirroring-uyumlu yazılır, v1'de garanti/test edilmez.

**Raund 6–7 (5):**
18. Override çözümü: override donar (binding kopar); §5.2'den `readonly` kaldırıldı → yazılabilir binding default'lar.
19. qmldir: tek auto-gen qmldir; ayrı elle qmldir yok (bkz. #23).
20. Card slot tipi: `Component` property + iç `Loader`.
21. Button spinner: `[icon|spinner] text`; loading icon yerini alır, text kalır; ayrı `RotationAnimator` (Infinite, Linear).
22. TextField filled dolgu: mevcut `muted` token'ı yeniden kullanılır.

**Raund 8 (2) — terminal doğrulama:**
23. Drop-in paketleme: CMake install/stage adımı modülü (otomatik qmldir + tüm `.qml`) `dist/Loom/`'a toplar; bu paket release'de commit'lenir → CMake'siz kullanıcı klasörü kopyalar. (Ayrı elle qmldir fikri iptal.)
24. Boyut token adı: en büyük ölçek `xxl` (spacing + typography); `2xl` rakamla başladığı için geçersiz QML identifier.

**Raund 9 (2) — ekosistem uyumluluğu (§16):**
25. CMake target adı `LoomModule` (URI `Loom`'dan farklı) — Qt build-folder çakışması önlemi.
26. v1 theming = tek global `Loom.Theme` singleton (bilinçli); per-subtree attached-Theme/colorSet cascade → v2.

---

## 16. Ekosistem Uyumluluğu (kurulu QML kütüphaneleriyle karşılaştırma)

Tasarım, gerçek QML kütüphaneleriyle karşılaştırıldı; mantık **idiomatik ve uyumlu**:

| Eksen | Ekosistem (Kirigami / Fluid / QQC2 / Qt) | Loom | Durum |
|---|---|---|---|
| Nitelikli import | `import org.kde.kirigami as Kirigami` / `... as Apk` → `Apk.Button` | `import Loom as Loom` → `Loom.Button` | ✅ |
| Prefix'li type adları | `Apk.Button`, `Apk.CheckBox` (QQC2 adları kendi prefix'inde) | `Loom.Button`, `Loom.CheckBox` | ✅ |
| Theme = singleton | "singleton QtObject holding all colors/values" yaygın | `Loom.Theme` | ✅ |
| Component temeli | QQC2 / `QtQuick.Templates` (Qt stilleri) | `QtQuick.Templates as T` | ✅ |
| Dağıtım | install+find_package (Fluid/Kirigami); FetchContent modern Qt önerisi | FetchContent + drop-in | ✅ |
| Interop | modüller kendi URI'sinde izole | nitelikli `Loom.*` | ✅ |

**İki düzeltme/karar (yukarıda #25, #26):**
- **#25 Target ≠ URI:** Qt resmi kuralı; target `LoomModule`, URI `Loom`.
- **#26 Theming kapsamı:** Kirigami `Kirigami.Theme` + `colorSet` ve Material attached `Material.theme` **per-subtree** temalama sağlar (alt-ağaç ayrı tema). Loom v1 **global tek singleton** — daha basit, shadcn'in global CSS-vars modeliyle aynı ruhta; per-subtree esneklik v2'ye bilinçli ertelendi.

---

## 17. İmplementasyon Notları (Faz 1'de keşfedilen)

- **macOS SDK 26 + AGL:** Qt 6.9 kaldırılmış `AGL` framework'üne link-referansı veriyor. Kök `CMakeLists.txt` configure'da boş bir `AGL.framework` stub'ı üretip linker'ı oraya yönlendiriyor (`build/agl-stub`). Stub derlemesi `-isysroot ${CMAKE_OSX_SYSROOT}` ister (Xcode `c++` doğrudan çağrılınca libc++'ı sysroot'suz bulamıyor).
- **Target adı ≠ URI (case-insensitive de):** #25 sadece Loom'a değil, gallery'ye de uygulandı — exe `galleryapp` / URI `Gallery`, exe `LoomModule` / URI `Loom`. Aksi halde macOS'un case-insensitive FS'inde `Gallery/` modül dizini ile `gallery` exe çakışıyor (EISDIR).
- **`QT_QML_OUTPUT_DIRECTORY`:** Tüm QML modülleri `build/qml/` altına çıkıyor → qmllint/qmlls ve runtime kardeş modülü (`Loom`) tutarlı buluyor. Bu olmadan qmllint "Failed to import Loom" verip her erişimi sahte "unqualified" sayıyordu.
- **Token grupları inline component:** `spacing`/`font`/`motion` anonim `QtObject` yerine file-local `component SpacingScale/TypeScale/MotionScale` → qmllint üyeleri statik çözüyor (0 uyarı), gruplu erişim (`Theme.spacing.lg`) korunuyor, ekstra public type yok.
- **Build/run:** `~/Qt/Tools/CMake/.../cmake --preset default` + `--build build`. GUI'siz doğrulama: `QT_QPA_PLATFORM=offscreen perl -e 'alarm 5; exec @ARGV' build/examples/gallery/galleryapp` (exit 142 = sağlıklı). qmllint: `--build build --target all_qmllint`.

### Faz 3 (Button + Card) notları
- **Modül-içi singleton:** Aynı modülün dosyaları `Theme`'e `import Loom` olmadan, unqualified `Theme.x` ile erişiyor (test edildi, qmllint+runtime temiz). Sibling tipler de (FocusRing/Elevation/Button) unqualified.
- **Button & FINAL `icon`:** `T.Button`'da zaten FINAL bir `icon` grup property'si var → kendi `property url icon` EKLENEMEZ ("Cannot override FINAL property"). QQC2'nin hazır grubunu kullan: tüketici `icon.source: ...`, component içinde `control.icon.source`.
- **Göreli image URL:** İkon kaynağı tüketici dosyasında verilirken `Qt.resolvedUrl("star.svg")` ile mutlaklaştır; düz string verince component'in (Button.qml) dizinine göre çözülüp bulunamıyor.
- **Elevation/MultiEffect:** Gölge kaynağı Rectangle `layer.enabled: true` olmalı (texture provider); `visible:false` ile de çalıştı ama kaynak görünür + üstteki opak `card` bg ile örtülü tutmak en güvenli. Perf: kart başına 1 MultiEffect, az kart için kabul (yoğun liste/grid'de ölç). Gölge token'ları (op/blur/yoff) `Elevation.qml` içinde level'a göre.
- **Görsel doğrulama aracı:** `LOOM_SHOT=/path build/.../galleryapp` (offscreen) pencereyi PNG'ye grab eder (`win->grabWindow()`); ekran-kayıt izni gerekmez, CI görsel kontrolü için de kullanılır. Not: MultiEffect gölgesi offscreen grab'da da yakalanıyor. Belirli bölge için `sips -c H W --cropOffset Y X in.png --out out.png` ile kırp.

### Faz 4 (TextField/CheckBox/Switch/Badge) notları
- **CheckBox/Switch indicator konumu:** indicator'da `anchors.verticalCenter: parent` KULLANMA — control'ün implicit yüksekliğini bozar, Column içinde tüm itemlar y=0'da üst üste biner. QQC2 pattern'i: indicator `y: (control.height - height) / 2` + control root'ta `implicitWidth: contentItem.implicitWidth`, `implicitHeight: Math.max(indicator.implicitHeight, contentItem.implicitHeight)`.
- **TextField composite:** `T.TextField` sadece input'tur; üst label + helper/error için Loom.TextField bir `ColumnLayout` sarmalayıcıdır (`text`/`placeholderText`/`echoMode` alias ile dışa açılır). `enabled` propagation çocuk input'a iniyor, ayrıca alias gerekmez.

### Faz 5 (dağıtım kanıtı) notları
- **Kanıt projesi:** `/Users/csstu/Desktop/Projeler/Qt/loom-consumer-test/` (Loom repo'sunun DIŞINDA, ayrı proje). `FetchContent_Declare(Loom SOURCE_DIR <loom>)` + `MakeAvailable` + `target_link_libraries(app PRIVATE LoomModule)` + `import Loom as Loom`. Gerçekte tek fark `SOURCE_DIR` yerine `GIT_REPOSITORY`+`GIT_TAG v1.0.0`.
- **İyi bağımlılık hijyeni:** Loom kök CMakeLists'inde `examples/gallery` ve `QT_QML_OUTPUT_DIRECTORY` artık `if(PROJECT_IS_TOP_LEVEL)` ile sarılı → tüketildiğinde gallery derlenmez, tüketici kendi QML output dizinini belirler. AGL stub bloğu ungated kalır (LOOM_AGL_STUB_DIR tüketiciyle paylaşılır; bu macOS'ta her Qt tüketicisi AGL sorununa düşer).
- **Tüketicide AGL:** `target_link_options(app PRIVATE -F${LOOM_AGL_STUB_DIR})` — Loom'un ürettiği stub dizinini kullanır.
- **Kalan (Faz 6):** CMake `install`/stage ile drop-in paketi (`dist/Loom/`) — CMake'siz tüketiciler için.
