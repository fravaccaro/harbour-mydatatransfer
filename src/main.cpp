#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <sys/types.h>
#include <unistd.h>
#include <QDebug>
#include <QObject>
#include <QString>
#include <QQuickView>
#include <QQmlContext>
#include <QGuiApplication>
#include <QFileSystemWatcher>
#include "mydatatransfer.h"

int main(int argc, char *argv[])
{

    QGuiApplication *app = SailfishApp::application(argc,argv);
    QQuickView *view = SailfishApp::createView();
    QString qml = QString("qml/harbour-mydatatransfer.qml");

    qmlRegisterType<MyDataTransfer>("mydatatransfer.scripts", 1, 0, "MyDataTransfer");

    view->setSource(SailfishApp::pathTo(qml));
    view->show();
    return app->exec();
}
