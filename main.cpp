#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "system.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    auto exec=new Exec();
    engine.rootContext()->setContextProperty("exec",exec);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
