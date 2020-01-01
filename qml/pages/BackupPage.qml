import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import Sailfish.Pickers 1.0
import mydatatransfer.scripts 1.0
import "../components"
import "../common"

Page
{
    id: backuppage
    focus: true
    backNavigation: !settings.isRunning
    showNavigationIndicator: !settings.isRunning
    MyDataTransfer { id: mydatatransfer }

    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - backuppage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, backuppage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_PageDown) {
            flickable.scrollToBottom();
            event.accepted = true;
        }

        if (event.key === Qt.Key_PageUp) {
            flickable.scrollToTop();
            event.accepted = true;
        }

        if (event.key === Qt.Key_B) {
            pageStack.navigateBack();
            event.accepted = true;
        }

        if (event.key === Qt.Key_H) {
            pageStack.replaceAbove(null, Qt.resolvedUrl("MainPage.qml"));
            event.accepted = true;
        }

        if (event.key === Qt.Key_A) {
            pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
            event.accepted = true;
        }

        if (event.key === Qt.Key_R) {
            pageStack.push(Qt.resolvedUrl("RestorePage.qml"));
            event.accepted = true;
        }

        if (event.key === Qt.Key_T) {
            pageStack.push(Qt.resolvedUrl("TransferPage.qml"));
            event.accepted = true;
        }
    }

    BusyState { id: busyindicator; }
    RemorsePopup { id: remorsepopup }
    Notification {
        id: notifybackup
        previewBody: qsTr("Backup completed")
        remoteActions: [ {
            "name": "default",
            "service": "org.nemomobile.mydatatransfer",
            "path": "/done",
            "iface": "org.nemomobile.mydatatransfer",
            "method": "backupDone"
        } ]
    }
    property int backupDestination: 0
    property alias appsBackup: itsappsbackup.checked
    property alias appdataBackup: itsappdatabackup.checked
    property alias documentsBackup: itsdocumentsbackup.checked
    property alias downloadsBackup: itsdownloadsbackup.checked
    property alias musicBackup: itsmusicbackup.checked
    property alias picturesBackup: itspicturesbackup.checked
    property alias videosBackup: itsvideosbackup.checked
    property alias callsBackup: itscallsbackup.checked
    property alias messagesBackup: itsmessagesbackup.checked

    Connections
    {
        target: mydatatransfer
        onBackupDone: {
            settings.isRunning = false;
            notifybackup.publish();
        }
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent
        anchors.bottomMargin: Theme.paddingLarge
        contentHeight: content.height
        enabled: !settings.isRunning
        opacity: settings.isRunning ? 0.2 : 1.0

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

           PageHeader { title: qsTr("Backup") }

           LabelText {
               text: qsTr("What do you want to backup?")
           }

              SectionHeader { text: qsTr("Position") }

           ComboBox {
               id: cbxmemory
               width: parent.width
               label: qsTr("Save in")
               description: switch(backupDestination) {
                   case 0:
                       return qsTr("The backup file will be saved in the internal memory.");
                   case 1:
                       return qsTr("The backup file will be saved in the SD card.");
               }
               currentIndex: backupDestination

               menu: ContextMenu {
                   MenuItem {
                       text: qsTr("internal memory");
                       onClicked: {backupDestination = 0 }
                   }
                   MenuItem {
                       visible: mydatatransfer.hasSDCard()
                       text: qsTr("SD card");
                       onClicked: {backupDestination = 1 }
                   }
               }
           }

              SectionHeader { text: qsTr("Applications") }

            IconTextSwitch {
                id: itsappsbackup
                checked: true
                automaticCheck: true
                text: qsTr("Apps")
                onClicked: { appsBackup = itsappsbackup.checked }
            }

            IconTextSwitch {
                id: itsappsbackup
                checked: true
                automaticCheck: true
                text: qsTr("App data")
                onClicked: { appdataBackup = itsappsbackup.checked }
            }

              SectionHeader { text: qsTr("Comunication") }

            IconTextSwitch {
                id: itscallsbackup
                checked: true
                automaticCheck: true
                text: qsTr("Call history")
                onClicked: { callsBackup = itscallsbackup.checked }
            }

            IconTextSwitch {
                id: itsmessagesbackup
                checked: true
                automaticCheck: true
                text: qsTr("Messages")
                onClicked: { messagesBackup = itsmessagesbackup.checked }
            }

              SectionHeader { text: qsTr("Files") }

            IconTextSwitch {
                id: itsdocumentsbackup
                checked: true
                automaticCheck: true
                text: qsTr("Documents")
                onClicked: { documentsBackup = itsdocumentsbackup.checked }
            }

            IconTextSwitch {
                id: itsdownloadsbackup
                checked: true
                automaticCheck: true
                text: qsTr("Downloads")
                onClicked: { downloadsBackup = itsdownloadsbackup.checked }
            }

            IconTextSwitch {
                id: itsmusicbackup
                checked: true
                automaticCheck: true
                text: qsTr("Music")
                onClicked: { musicBackup = itsmusicbackup.checked }
            }

            IconTextSwitch {
                id: itspicturesbackup
                checked: true
                automaticCheck: true
                text: qsTr("Pictures")
                onClicked: { picturesBackup = itspicturesbackup.checked }
            }

            IconTextSwitch {
                id: itsvideosbackup
                checked: true
                automaticCheck: true
                text: qsTr("Videos")
                onClicked: { videosBackup = itsvideosbackup.checked }
            }

           Button {
               enabled: (appsBackup || appdataBackup || callsBackup || messagesBackup || documentsBackup || downloadsBackup || musicBackup || picturesBackup || videosBackup)
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Backup")
               onClicked: {
                   remorsepopup.execute(qsTr("Backuping"), function() {
                       settings.isRunning = true;
                       mydatatransfer.backup(backupDestination, appsBackup, appdataBackup, callsBackup, messagesBackup, documentsBackup, downloadsBackup, musicBackup, picturesBackup, videosBackup);
                   });
               }
           }
        }

        VerticalScrollDecorator { }
    }
}
