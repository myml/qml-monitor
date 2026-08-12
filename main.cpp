#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QtGui/qguiapplication_platform.h>
#include <QtGui/qpa/qplatformnativeinterface.h>
#include <wayland-client.h>
#include <cstring>

#include "plasma-shell-client-protocol.h"
#include "system.h"

static struct org_kde_plasma_shell *g_plasmaShell = nullptr;

static void registryHandleGlobal(void *data, wl_registry *registry, uint32_t name,
                                 const char *interface, uint32_t version)
{
    Q_UNUSED(data);
    if (std::strcmp(interface, org_kde_plasma_shell_interface.name) == 0) {
        g_plasmaShell = static_cast<struct org_kde_plasma_shell *>(
            wl_registry_bind(registry, name, &org_kde_plasma_shell_interface,
                             qMin(version, 8u)));
    }
}

static void registryHandleGlobalRemove(void *data, wl_registry *registry, uint32_t name)
{
    Q_UNUSED(data);
    Q_UNUSED(registry);
    Q_UNUSED(name);
}

static const wl_registry_listener registryListener = {
    registryHandleGlobal,
    registryHandleGlobalRemove
};

static void bindPlasmaShell()
{
    auto *waylandApp = qGuiApp->nativeInterface<QNativeInterface::QWaylandApplication>();
    if (!waylandApp)
        return;
    wl_display *display = waylandApp->display();
    if (!display)
        return;
    wl_registry *registry = wl_display_get_registry(display);
    wl_registry_add_listener(registry, &registryListener, nullptr);
    wl_display_roundtrip(display);
    wl_registry_destroy(registry);
}

static void hideFromTaskbar(QWindow *window)
{
    if (!g_plasmaShell || !window)
        return;
    auto *native = QGuiApplication::platformNativeInterface();
    auto *surface = static_cast<wl_surface *>(
        native->nativeResourceForWindow(QByteArrayLiteral("surface"), window));
    if (!surface)
        return;
    struct org_kde_plasma_surface *ps = org_kde_plasma_shell_get_surface(g_plasmaShell, surface);
    org_kde_plasma_surface_set_skip_taskbar(ps, 1);
}

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QGuiApplication app(argc, argv);
    app.setOrganizationName("myml");
    app.setOrganizationDomain("myml.ml");

    bindPlasmaShell();

    QQmlApplicationEngine engine;
    auto exec = new Exec();

    engine.rootContext()->setContextProperty("exec",exec);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (!engine.rootObjects().isEmpty())
        hideFromTaskbar(qobject_cast<QWindow *>(engine.rootObjects().first()));

    return app.exec();
}
