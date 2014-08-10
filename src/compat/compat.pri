# -------------------------------------------------------------------
# Compatability hacks to build against Qt5 without changing the
# sources too much. Tries to mask over the differences between
# QtQuick1 and QtQuick2.
# -------------------------------------------------------------------

SOURCES += \
    $$PWD/qgraphicsitem.cpp

HEADERS += \
    $$PWD/qgraphicsitem.h \
    $$PWD/qgraphicsobject.h \
    $$PWD/qdeclarativeitem.h \
    $$PWD/qdeclarativeview.h \
    $$PWD/qgraphicsscene.h

INCLUDEPATH += $$PWD

QT += quick

# Prevent symbol clashes in case QtWidget is loaded
DEFINES += \
    QGraphicsItem=CompatQGraphicsItem \
    QGraphicsObject=CompatQGraphicsObject \
    QGraphicsScene=CompatQGraphicsScene \
    QDeclarativeComponent=QQmlComponent \
    QDeclarativeEngine=QQmlEngine \
    QDeclarativeExtensionPlugin=QQmlExtensionPlugin \
    QDeclarativeImageProvider=QQmlImageProvider \
    QDeclarativeItem=CompatQDeclarativeItem \
    QDeclarativePropertyMap=QQmlPropertyMap \
    QDeclarativeView=CompatQDeclarativeView

equals(QMAKE_HOST.os, Darwin): CONFIG += building_on_mac

