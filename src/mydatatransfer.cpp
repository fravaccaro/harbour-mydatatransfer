#include "mydatatransfer.h"
#include "spawner.h"
#include <unistd.h>
#include <QFileInfo>
#include <QDebug>

MyDataTransfer::MyDataTransfer(QObject* parent): QObject(parent)
{

}

QString MyDataTransfer::whoami() const
{
    return Spawner::executeSync("whoami");
}

bool MyDataTransfer::hasSshpassInstalled() const
{
    bool res = QFileInfo("/usr/bin/sshpass").exists();

   qDebug("%d\n", res);
   return res;
}

void MyDataTransfer::backup(bool apps, bool documents, bool downloads, bool music, bool pictures, bool videos) const
{
    Spawner::execute("/usr/share/harbour-mydatatransfer/scripts/backup.sh", SPAWN_ARGS(QString::number(apps) << QString::number(documents) << QString::number(downloads) << QString::number(music) << QString::number(pictures) << QString::number(videos)), [this]() { emit backupDone(); });
}

void MyDataTransfer::restore(const QString& filename, bool apps, bool documents, bool downloads, bool music, bool pictures, bool videos) const
{
    Spawner::execute("/usr/share/harbour-mydatatransfer/scripts/restore.sh", SPAWN_ARGS(filename << QString::number(apps) << QString::number(documents) << QString::number(downloads) << QString::number(music) << QString::number(pictures) << QString::number(videos)), [this]() { emit restoreDone(); });
}

void MyDataTransfer::transfer(const QString& ipaddress, const QString& password, bool apps, bool documents, bool downloads, bool music, bool pictures, bool videos) const
{
    Spawner::execute("/usr/share/harbour-mydatatransfer/scripts/transfer.sh", SPAWN_ARGS(ipaddress << password << QString::number(apps) << QString::number(documents) << QString::number(downloads) << QString::number(music) << QString::number(pictures) << QString::number(videos)), [this]() { emit transferDone(); });
}

