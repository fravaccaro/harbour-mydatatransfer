#ifndef MYDATATRANSFER_H
#define MYDATATRANSFER_H

#include <QObject>

class MyDataTransfer : public QObject
{
    Q_OBJECT

    public:
        explicit MyDataTransfer(QObject* parent = 0);

    public slots:
        QString whoami() const;                         // function to test what user runs app
        bool hasSDCard() const;
        bool hasSshpassInstalled() const;
        void backup(bool apps, bool documents, bool downloads, bool music, bool pictures, bool videos, bool calls, bool messages, bool destination) const;
        void restore(const QString& filename, bool apps, bool documents, bool downloads, bool music, bool pictures, bool videos, bool calls, bool messages) const;
        void transfer(const QString& ipaddress, const QString& password, bool apps, bool documents, bool downloads, bool music, bool pictures, bool videos, bool calls, bool messages) const;

    signals:
        void backupDone();
        void restoreDone();
        void transferDone();
};

#endif // MYDATATRANSFER_H

