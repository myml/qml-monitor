TEMPLATE = app

QT += qml quick gui-private
CONFIG += c++17

SOURCES += main.cpp plasma-shell-client-protocol.c

RESOURCES += qml.qrc

LIBS += -lwayland-client

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri)

DISTFILES += \
    REMODE.md

HEADERS += \
    system.h \
    plasma-shell-client-protocol.h
