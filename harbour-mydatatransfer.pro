TARGET = harbour-mydatatransfer

scripts.files = scripts/*
scripts.path = $$PREFIX/share/$$TARGET/scripts

images.files = images/*
images.path = $$PREFIX/share/$$TARGET/images

appicons.files = appicons/*
appicons.path = /usr/share/icons/hicolor/

INSTALLS += scripts images appicons

CONFIG += sailfishapp c++11

SOURCES += \
    src/spawner.cpp \
    src/mydatatransfer.cpp \
    src/main.cpp

OTHER_FILES += \
    qml/harbour-mydatatransfer.qml \
    qml/components/*.qml \
    qml/cover/*.qml \
    qml/pages/*.qml \
    rpm/* \
    harbour-mydatatransfer.desktop \

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n

TRANSLATIONS +=  translations/*.ts

HEADERS += \
    src/spawner.h \
    src/mydatatransfer.h
