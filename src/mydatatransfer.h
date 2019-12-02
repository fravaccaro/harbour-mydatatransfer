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
        void backup() const;
        void restore(const QString& filename);
        void transfer(const QString& ipaddress, const QString& password);

    signals:
        void actionDone();
};

#endif // MYDATATRANSFER_H

