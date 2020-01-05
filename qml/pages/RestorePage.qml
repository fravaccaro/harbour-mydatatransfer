import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import Sailfish.Pickers 1.0
import mydatatransfer.scripts 1.0
import "../components"
import "../common"

Page
{
    id: restorepage
    focus: true
    backNavigation: !settings.isRunning
    showNavigationIndicator: !settings.isRunning
    MyDataTransfer { id: mydatatransfer }


    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - restorepage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, restorepage.height);
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

        if (event.key === Qt.Key_C) {
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

        if (event.key === Qt.Key_B) {
            pageStack.push(Qt.resolvedUrl("BackupPage.qml"));
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
    property alias appsRestore: itsappsrestore.checked
    property alias apporderRestore: itsapporderrestore.checked
    property alias appdataRestore: itsappdatarestore.checked
    property alias documentsRestore: itsdocumentsrestore.checked
    property alias downloadsRestore: itsdownloadsrestore.checked
    property alias musicRestore: itsmusicrestore.checked
    property alias picturesRestore: itspicturesrestore.checked
    property alias videosRestore: itsvideosrestore.checked
    property alias callsRestore: itscallsrestore.checked
    property alias messagesRestore: itsmessagesrestore.checked
    property string selectedBackupFile
    property string selectedBackupFilePath

    Connections
    {
        target: mydatatransfer
        onRestoreDone: {
            settings.isRunning = false;
            notifyrestore.publish();
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

        PullDownMenu {
            MenuItem {
               text: qsTr("Deselect all")
               enabled: selectedBackupFile && (appsRestore || apporderRestore || appdataRestore || callsRestore || messagesRestore || documentsRestore || downloadsRestore || musicRestore || picturesRestore || videosRestore)
               onClicked: {
                   appsRestore = false
                   apporderRestore = false
                   appdataRestore = false
                   callsRestore = false
                   messagesRestore = false
                   documentsRestore = false
                   downloadsRestore = false
                   musicRestore = false
                   picturesRestore = false
                   videosRestore = false
               }
            }

            MenuItem {
               text: qsTr("Select all")
               enabled: selectedBackupFile && (!appsRestore || !apporderRestore || !appdataRestore || !callsRestore || !messagesRestore || !documentsRestore || !downloadsRestore || !musicRestore || !picturesRestore || !videosRestore)
               onClicked: {
                   appsRestore = true
                   apporderRestore = true
                   appdataRestore = true
                   callsRestore = true
                   messagesRestore = true
                   documentsRestore = true
                   downloadsRestore = true
                   musicRestore = true
                   picturesRestore = true
                   videosRestore = true
               }
            }
        }

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

           PageHeader { title: qsTr("Restore") }

           LabelText {
               text: qsTr("What do you want to restore?")
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
                       selectedBackupFile = selectedContentProperties.fileName
                       selectedBackupFilePath = selectedContentProperties.filePath
                   }
               }
           }

              SectionHeader { text: qsTr("Applications") }

            IconTextSwitch {
                visible: false
                id: itsappsrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Apps")
                onClicked: { appsRestore = itsappsrestore.checked }
            }

            IconTextSwitch {
                id: itsappdatarestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("App data")
                onClicked: { appdataRestore = itsappdatarestore.checked }
            }

            IconTextSwitch {
                id: itsapporderrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("App order")
                onClicked: { apporderRestore = itsapporderrestore.checked }
            }

              SectionHeader { text: qsTr("Communication") }

            IconTextSwitch {
                id: itscallsrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Call history")
                onClicked: { callsRestore = itscallsrestore.checked }
            }

            IconTextSwitch {
                id: itsmessagesrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Messages")
                onClicked: { messagesRestore = itsmessagesrestore.checked }
            }

              SectionHeader { text: qsTr("Files") }

            IconTextSwitch {
                id: itsdocumentsrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Documents")
                onClicked: { documentsRestore = itsdocumentsrestore.checked }
            }

            IconTextSwitch {
                id: itsdownloadsrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Downloads")
                onClicked: { downloadsRestore = itsdownloadsrestore.checked }
            }

            SectionHeader { text: qsTr("Media") }

            IconTextSwitch {
                id: itsmusicrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Music")
                onClicked: { musicRestore = itsmusicrestore.checked }
            }

            IconTextSwitch {
                id: itspicturesrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Pictures")
                onClicked: { picturesRestore = itspicturesrestore.checked }
            }

            IconTextSwitch {
                id: itsvideosrestore
                checked: true
                automaticCheck: true
                enabled: selectedBackupFile
                text: qsTr("Videos")
                onClicked: { videosRestore = itsvideosrestore.checked }
            }

           LabelText {
               visible: false
               text: qsTr("NOTE: app restoring requires an internet connection and may take a while.")
           }

           Button {
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Restore")
               enabled: (selectedBackupFile) && (appsRestore || apporderRestore || appdataRestore || callsRestore || messagesRestore || downloadsRestore || musicRestore || picturesRestore || videosRestore)
               onClicked: {
                   remorsepopup.execute(qsTr("Restoring backup"), function() {
                       settings.isRunning = true;
                       mydatatransfer.restore(selectedBackupFilePath, appsRestore, apporderRestore, appdataRestore, callsRestore, messagesRestore, documentsRestore, downloadsRestore, musicRestore, picturesRestore, videosRestore);
                   });
               }
           }

        }

        VerticalScrollDecorator { }
    }
}
