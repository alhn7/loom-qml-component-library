#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QTimer>
#include <QImage>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Dev/CI aracı: LOOM_SHOT=path set ise pencereyi PNG'ye grab edip çıkar
    // (offscreen render ile çalışır, ekran-kayıt izni gerekmez).
    const QByteArray shotPath = qgetenv("LOOM_SHOT");
    if (!shotPath.isEmpty()) {
        QObject::connect(
            &engine, &QQmlApplicationEngine::objectCreated, &app,
            [shotPath](QObject *obj, const QUrl &) {
                if (auto *win = qobject_cast<QQuickWindow *>(obj)) {
                    QTimer::singleShot(1200, win, [win, shotPath]() {
                        const QImage img = win->grabWindow();
                        img.save(QString::fromUtf8(shotPath));
                        QCoreApplication::quit();
                    });
                }
            },
            Qt::QueuedConnection);
    }

    engine.loadFromModule("Gallery", "Main");

    return app.exec();
}
