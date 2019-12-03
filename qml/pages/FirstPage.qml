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
    }

    BusyState { id: busyindicator; }
    RemorsePopup { id: remorsepopup }
    Notification { id: notification }
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
        function notify() {
            busyindicator.running = false;
            notification.publish();
        }

        target: mydatatransfer
        onActionDone: notify()
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent
        anchors.bottomMargin: Theme.paddingLarge
        contentHeight: content.height
        enabled: !busyindicator.running
        opacity: busyindicator.running ? 0.3 : 1.0

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

           PageHeader { title: qsTr("My Data Transfer") }


           SectionHeader { text: qsTr("Backup") }

           LabelText {
               text: qsTr("Save all your app data and restore them later on. The save file will be saved into your <i>home</i> directory.")
           }

           LabelSpacer { }

            IconTextSwitch {
                id: itsappsbackup
                automaticCheck: true
                text: qsTr("Apps")
                onClicked: { appsBackup = itsappsbackup.checked }
            }

            IconTextSwitch {
                id: itsappsbackup
                automaticCheck: true
                text: qsTr("Apps")
                onClicked: { appsBackup = itsappsbackup.checked }
            }

            IconTextSwitch {
                id: itsdocumentsbackup
                automaticCheck: true
                text: qsTr("Documents")
                onClicked: { documentsBackup = itsdocumentsbackup.checked }
            }

            IconTextSwitch {
                id: itsdownloadsbackup
                automaticCheck: true
                text: qsTr("Downloads")
                onClicked: { downloadsBackup = itsdownloadsbackup.checked }
            }

            IconTextSwitch {
                id: itsmusicbackup
                automaticCheck: true
                text: qsTr("Music")
                onClicked: { musicBackup = itsmusicbackup.checked }
            }

            IconTextSwitch {
                id: itspicturesbackup
                automaticCheck: true
                text: qsTr("Pictures")
                onClicked: { picturesBackup = itspicturesbackup.checked }
            }

            IconTextSwitch {
                id: itsvideosbackup
                automaticCheck: true
                text: qsTr("Videos")
                onClicked: { videosBackup = itsvideosbackup.checked }
            }

           Button {
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

           ValueButton {
               label: qsTr("File")
               description: qsTr("Select and restore an app data backup previously saved.")
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
                automaticCheck: true
                text: qsTr("Apps")
                onClicked: { appsRestore = itsappsrestore.checked }
            }

            IconTextSwitch {
                id: itsdocumentsrestore
                automaticCheck: true
                text: qsTr("Documents")
                onClicked: { documentsRestore = itsdocumentsrestore.checked }
            }

            IconTextSwitch {
                id: itsdownloadsrestore
                automaticCheck: true
                text: qsTr("Downloads")
                onClicked: { downloadsRestore = itsdownloadsrestore.checked }
            }

            IconTextSwitch {
                id: itsmusicrestore
                automaticCheck: true
                text: qsTr("Music")
                onClicked: { musicRestore = itsmusicrestore.checked }
            }

            IconTextSwitch {
                id: itspicturesrestore
                automaticCheck: true
                text: qsTr("Pictures")
                onClicked: { picturesRestore = itspicturesrestore.checked }
            }

            IconTextSwitch {
                id: itsvideosrestore
                automaticCheck: true
                text: qsTr("Videos")
                onClicked: { videosRestore = itsvideosrestore.checked }
            }

           Button {
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Restore")
               enabled: selectedBackupFile ? true : false
               onClicked: {
                   remorsepopup.execute(qsTr("Restoring backup"), function() {
                       busyindicator.running = true;
                       mydatatransfer.restore(firstpage.selectedBackupFilePath, appsRestore, documentsRestore, downloadsRestore, musicRestore, picturesRestore, videosRestore);
                   });
               }
           }

           SectionHeader { text: qsTr("Transfer to a new device") }

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
               EnterKey.iconSource: "image://theme/icon-m-enter-accept"
               onClicked: {
                   remorsepopup.execute(qsTr("Transfering"), function() {
                       busyindicator.running = true;
                       mydatatransfer.transfer(ipAddress.text, passwordField.text, appsTransfer, documentsTransfer, downloadsTransfer, musicTransfer, picturesTransfer, videosTransfer);
                   });
               }
           }

            IconTextSwitch {
                id: itsappstransfer
                automaticCheck: true
                text: qsTr("Apps")
                onClicked: { appsTransfer = itsappstransfer.checked }
            }

            IconTextSwitch {
                id: itsappstransfer
                automaticCheck: true
                text: qsTr("Apps")
                onClicked: { appsTransfer = itsappstransfer.checked }
            }

            IconTextSwitch {
                id: itsdocumentstransfer
                automaticCheck: true
                text: qsTr("Documents")
                onClicked: { documentsTransfer = itsdocumentstransfer.checked }
            }

            IconTextSwitch {
                id: itsdownloadstransfer
                automaticCheck: true
                text: qsTr("Downloads")
                onClicked: { downloadsTransfer = itsdownloadstransfer.checked }
            }

            IconTextSwitch {
                id: itsmusictransfer
                automaticCheck: true
                text: qsTr("Music")
                onClicked: { musicTransfer = itsmusictransfer.checked }
            }

            IconTextSwitch {
                id: itspicturestransfer
                automaticCheck: true
                text: qsTr("Pictures")
                onClicked: { picturesTransfer = itspicturestransfer.checked }
            }

            IconTextSwitch {
                id: itsvideostransfer
                automaticCheck: true
                text: qsTr("Videos")
                onClicked: { videosTransfer = itsvideostransfer.checked }
            }

           Button {
               enabled: ( ipAddress.acceptableInput ) && ( passwordField.text.length > 0 )
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Transfer")
               onClicked: {
                   remorsepopup.execute(qsTr("Transfering"), function() {
                       busyindicator.running = true;
                       mydatatransfer.transfer(ipAddress.text, passwordField.text, appsTransfer, documentsTransfer, downloadsTransfer, musicTransfer, picturesTransfer, videosTransfer);
                   });
               }
           }



        }

        VerticalScrollDecorator { }
    }
}
