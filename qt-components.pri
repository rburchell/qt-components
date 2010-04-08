INCLUDEPATH += $$PWD/src
LIBRARYPATH += $$PWD/lib
QMAKE_RPATHDIR = $$OUT_PWD/lib

QMAKE_INCDIR += $$INCLUDEPATH
QMAKE_LIBDIR += $$LIBRARYPATH
LIBS += -L../../lib -lcomponents
LIBS += -L../lib -lcomponents

win32:DEFINES += Q_COMPONENTS_EXPORT=__declspec(dllimport)
unix:DEFINES += Q_COMPONENTS_EXPORT=""
