import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import mydatatransfer.scripts 1.0
import "../components"

Page
{
    id: firstpage
    focus: true
    MyDataTransfer { id: mydatatransfer }


    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - firstpage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, firstpage.height);
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

        if (event.key === Qt.Key_A) {
            pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
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
    Notification {
        id: notifyrestore
        previewBody: qsTr("Restore completed")
        remoteActions: [ {
            "name": "default",
            "service": "org.nemomobile.mydatatransfer",
            "path": "/done",
            "iface": "org.nemomobile.mydatatransfer",
            "method": "restoreDone"
        } ]
    }
    Notification {
        id: notifytransfer
        previewBody: qsTr("Transfer completed")
        remoteActions: [ {
            "name": "default",
            "service": "org.nemomobile.mydatatransfer",
            "path": "/done",
            "iface": "org.nemomobile.mydatatransfer",
            "method": "transferDone"
        } ]
    }
    property alias appsBackup: itsappsbackup.checked
    property alias documentsBackup: itsdocumentsbackup.checked
    property alias downloadsBackup: itsdownloadsbackup.checked
    property alias musicBackup: itsmusicbackup.checked
    property alias picturesBackup: itspicturesbackup.checked
    property alias videosBackup: itsvideosbackup.checked
    property alias appsRestore: itsappsrestore.checked
    property alias documentsRestore: itsdocumentsrestore.checked
    property alias downloadsRestore: itsdownloadsrestore.checked
    property alias musicRestore: itsmusicrestore.checked
    property alias picturesRestore: itspicturesrestore.checked
    property alias videosRestore: itsvideosrestore.checked
    property alias appsTransfer: itsappstransfer.checked
    property alias documentsTransfer: itsdocumentstransfer.checked
    property alias downloadsTransfer: itsdownloadstransfer.checked
    property alias musicTransfer: itsmusictransfer.checked
    property alias picturesTransfer: itspicturestransfer.checked
    property alias videosTransfer: itsvideostransfer.checked
    property string selectedBackupFile
    property string selectedBackupFilePath

    Connections
    {
        target: mydatatransfer
        onBackupDone: {
            busyindicator.running = false;
            notifybackup.publish();
        }
        onRestoreDone: {
            busyindicator.running = false;
            notifyrestore.publish();
        }
        onTransferDone: {
            busyindicator.running = false;
            notifytransfer.publish();
        }
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent
        anchors.bottomMargin: Theme.paddingLarge
        contentHeight: content.height
        enabled: !busyindicator.running
        opacity: busyindicator.running ? 0.3 : 1.0


        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

           PageHeader { title: qsTr("My Data Transfer") }

           SectionHeader { text: qsTr("Backup") }

           LabelText {
               text: qsTr("Choose what to backup. The save file will be stored into your <i>home</i> directory.")
           }

            IconTextSwitch {
                id: itsappsbackup
                checked: true
                automaticCheck: true
                text: qsTr("App data")
                onClicked: { appsBackup = itsappsbackup.checked }
            }

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
               enabled: (appsBackup || documentsBackup || downloadsBackup || musicBackup || picturesBackup || videosBackup)
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Backup")
               onClicked: {
                   remorsepopup.execute(qsTr("Backuping"), function() {
                       busyindicator.running = true;
                       mydatatransfer.backup(appsBackup, documentsBackup, downloadsBackup, musicBackup, picturesBackup, videosBackup);
                   });
               }
           }

           SectionHeader { text: qsTr("Restore") }

           LabelText {
               text: qsTr("Select a save file and choose what to restore.")
           }

           ValueButton {
               label: qsTr("File")
               value: selectedBackupFile ? selectedBackupFile : qsTr("None")
               onClicked: pageStack.push(backupFilePickerPage)
           }

           Component {
               id: backupFilePickerPage
               FilePickerPage {
                   nameFilters: [ '*.mydatatransfer' ]
                   title: qsTr("Select backup")
                   onSelectedContentPropertiesChanged: {
                       firstpage.selectedBackupFile = selectedContentProperties.fileName
                       firstpage.selectedBackupFilePath = selectedContentProperties.filePath
                   }
               }
           }

            IconTextSwitch {
                id: itsappsrestore
                checked: true
                automaticCheck: true
                text: qsTr("App data")
                onClicked: { appsRestore = itsappsrestore.checked }
            }

            IconTextSwitch {
                id: itsdocumentsrestore
                checked: true
                automaticCheck: true
                text: qsTr("Documents")
                onClicked: { documentsRestore = itsdocumentsrestore.checked }
            }

            IconTextSwitch {
                id: itsdownloadsrestore
                checked: true
                automaticCheck: true
                text: qsTr("Downloads")
                onClicked: { downloadsRestore = itsdownloadsrestore.checked }
            }

            IconTextSwitch {
                id: itsmusicrestore
                checked: true
                automaticCheck: true
                text: qsTr("Music")
                onClicked: { musicRestore = itsmusicrestore.checked }
            }

            IconTextSwitch {
                id: itspicturesrestore
                checked: true
                automaticCheck: true
                text: qsTr("Pictures")
                onClicked: { picturesRestore = itspicturesrestore.checked }
            }

            IconTextSwitch {
                id: itsvideosrestore
                checked: true
                automaticCheck: true
                text: qsTr("Videos")
                onClicked: { videosRestore = itsvideosrestore.checked }
            }

           Button {
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Restore")
               enabled: (selectedBackupFile) && (appsRestore || documentsRestore || downloadsRestore || musicRestore || picturesRestore || videosRestore)
               onClicked: {
                   remorsepopup.execute(qsTr("Restoring backup"), function() {
                       busyindicator.running = true;
                       mydatatransfer.restore(firstpage.selectedBackupFilePath, appsRestore, documentsRestore, downloadsRestore, musicRestore, picturesRestore, videosRestore);
                   });
               }
           }

           SectionHeader { text: qsTr("Transfer to a new device") }

           LabelText {
               text: qsTr("Insert your new device IP address and password, then choose what to transfer. Both of your devices need to be on the same WLAN network.")
           }

           LabelText {
               text: qsTr("NOTE: you need the developer mode active and a root password set on your new device in order to be able to use this option.")
           }

           TextField {
               id: ipAddress
               placeholderText: qsTr("IP address")
               label: qsTr("IP address")
               width: parent.width
               validator: RegExpValidator {
                   regExp: /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
               }
               EnterKey.enabled: acceptableInput
               inputMethodHints: Qt.ImhNoPredictiveText
               EnterKey.iconSource: "image://theme/icon-m-enter-next"
               EnterKey.onClicked: passwordField.focus = true
           }

           PasswordField {
               id: passwordField
               placeholderText: qsTr("Password")
               label: qsTr("Password")
               width: parent.width
               EnterKey.enabled: text.length > 0
               EnterKey.iconSource: "image://theme/icon-m-enter-close"
               EnterKey.onClicked: focus = false
           }

            IconTextSwitch {
                id: itsappstransfer
                checked: true
                automaticCheck: true
                text: qsTr("App data")
                onClicked: { appsTransfer = itsappstransfer.checked }
            }

            IconTextSwitch {
                id: itsdocumentstransfer
                checked: true
                automaticCheck: true
                text: qsTr("Documents")
                onClicked: { documentsTransfer = itsdocumentstransfer.checked }
            }

            IconTextSwitch {
                id: itsdownloadstransfer
                checked: true
                automaticCheck: true
                text: qsTr("Downloads")
                onClicked: { downloadsTransfer = itsdownloadstransfer.checked }
            }

            IconTextSwitch {
                id: itsmusictransfer
                checked: true
                automaticCheck: true
                text: qsTr("Music")
                onClicked: { musicTransfer = itsmusictransfer.checked }
            }

            IconTextSwitch {
                id: itspicturestransfer
                checked: true
                automaticCheck: true
                text: qsTr("Pictures")
                onClicked: { picturesTransfer = itspicturestransfer.checked }
            }

            IconTextSwitch {
                id: itsvideostransfer
                checked: true
                automaticCheck: true
                text: qsTr("Videos")
                onClicked: { videosTransfer = itsvideostransfer.checked }
            }

           Button {
               enabled: ( ipAddress.acceptableInput ) && ( passwordField.text.length > 0 ) && (appsTransfer || documentsTransfer || downloadsTransfer || musicTransfer || picturesTransfer || videosTransfer)
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Transfer")
               onClicked: {
                   remorsepopup.execute(qsTr("Transferring"), function() {
                       busyindicator.running = true;
                       mydatatransfer.transfer(ipAddress.text, passwordField.text, appsTransfer, documentsTransfer, downloadsTransfer, musicTransfer, picturesTransfer, videosTransfer);
                   });
               }
           }



        }

        VerticalScrollDecorator { }
    }
}
