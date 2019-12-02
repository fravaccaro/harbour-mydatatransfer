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

void MyDataTransfer::backup() const
{
    Spawner::execute("/usr/share/harbour-mydatatransfer/scripts/backup.sh", [this]() { emit actionDone(); });
}

void MyDataTransfer::restore(const QString& filename)
{
    Spawner::execute("/usr/share/harbour-mydatatransfer/scripts/restore.sh", SPAWN_ARGS(filename), [this]() { emit actionDone(); });
}

void MyDataTransfer::transfer(const QString& ipaddress, const QString& password)
{
    Spawner::execute("/usr/share/harbour-mydatatransfer/scripts/transfer.sh", SPAWN_ARGS(ipaddress << password), [this]() { emit actionDone(); });
}
