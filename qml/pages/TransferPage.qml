import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import Sailfish.Pickers 1.0
import mydatatransfer.scripts 1.0
import "../components"
import "../common"

Page
{
    id: transferpage
    focus: true
    backNavigation: !settings.isRunning
    showNavigationIndicator: !settings.isRunning
    MyDataTransfer { id: mydatatransfer }

    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - transferpage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, transferpage.height);
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

        if (event.key === Qt.Key_S) {
            pageStack.push(Qt.resolvedUrl("BackupPage.qml"));
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
    property int transferMode: -1
    property alias appsTransfer: itsappstransfer.checked
    property alias appdataTransfer: itsappdatatransfer.checked
    property alias documentsTransfer: itsdocumentstransfer.checked
    property alias downloadsTransfer: itsdownloadstransfer.checked
    property alias musicTransfer: itsmusictransfer.checked
    property alias picturesTransfer: itspicturestransfer.checked
    property alias videosTransfer: itsvideostransfer.checked
    property alias callsTransfer: itscallstransfer.checked
    property alias messagesTransfer: itsmessagestransfer.checked

    Connections
    {
        target: mydatatransfer
        onTransferDone: {
            settings.isRunning = false;
            notifytransfer.publish();
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

           PageHeader { title: qsTr("Transfer") }

              SectionHeader { text: qsTr("Transfer mode") }

           ComboBox {
               id: cbxtransfermode
               width: parent.width
               label: qsTr("Mode")
               description: switch(transferMode) {
                   default:
                       return qsTr("Select whether transferring from or to another device.");
                   case 0:
                       return qsTr("Transfer settings and files to a another device.");
                   case 1:
                       return qsTr("Transfer settings and files from a another device.");
               }
               currentIndex: transferMode

               menu: ContextMenu {
                   MenuItem {
                       text: qsTr("to another device");
                       onClicked: {transferMode = 0 }
                   }
                   MenuItem {
                       text: qsTr("from another device");
                       onClicked: {transferMode = 1 }
                   }
               }
           }

           LabelText {
               visible: transferMode === 0
               text: qsTr("Insert your new device IP address and password, then choose what to transfer. Make sure you have enough free space on the internal memory and that both of your devices are on the same WLAN network.")
           }

           LabelText {
               visible: transferMode === 0
               text: qsTr("NOTE: you need the developer mode active and an ssh password set on both of your devices in order to be able to use this option. App transferring requires an internet connection and may take a while.")
           }

           LabelText {
               visible: transferMode === 0 && !mydatatransfer.hasSshpassInstalled()
               color: Theme.secondaryHighlightColor
               text: qsTr("WARNING: sshpass is not installed, hence data transferring will not work. Install it either from <a href='https://openrepos.net/content/nieldk/sshpass'>here</a> or via Storeman if you want to use this feature, then restart My Data Transfer.")
           }

           TextField {
               visible: transferMode === 0
               enabled: mydatatransfer.hasSshpassInstalled()
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
               visible: transferMode === 0
               enabled: mydatatransfer.hasSshpassInstalled()
               id: passwordField
               placeholderText: qsTr("Password")
               label: qsTr("Password")
               width: parent.width
               EnterKey.enabled: text.length > 0
               EnterKey.iconSource: "image://theme/icon-m-enter-close"
               EnterKey.onClicked: focus = false
           }

              SectionHeader { text: qsTr("Applications"); enabled: mydatatransfer.hasSshpassInstalled() }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itsappstransfer
                checked: true
                automaticCheck: true
                text: qsTr("Apps")
                onClicked: { appsTransfer = itsappstransfer.checked }
            }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itsappdatatransfer
                checked: true
                automaticCheck: true
                text: qsTr("App data")
                onClicked: { appdataTransfer = itsappdatatransfer.checked }
            }

              SectionHeader { text: qsTr("Comunication"); enabled: mydatatransfer.hasSshpassInstalled() }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itscallstransfer
                checked: true
                automaticCheck: true
                text: qsTr("Call history")
                onClicked: { callsTransfer = itscallstransfer.checked }
            }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itsmessagestransfer
                checked: true
                automaticCheck: true
                text: qsTr("Messages")
                onClicked: { messagesTransfer = itsmessagestransfer.checked }
            }

              SectionHeader { text: qsTr("Files"); enabled: mydatatransfer.hasSshpassInstalled() }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itsdocumentstransfer
                checked: true
                automaticCheck: true
                text: qsTr("Documents")
                onClicked: { documentsTransfer = itsdocumentstransfer.checked }
            }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itsdownloadstransfer
                checked: true
                automaticCheck: true
                text: qsTr("Downloads")
                onClicked: { downloadsTransfer = itsdownloadstransfer.checked }
            }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itsmusictransfer
                checked: true
                automaticCheck: true
                text: qsTr("Music")
                onClicked: { musicTransfer = itsmusictransfer.checked }
            }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itspicturestransfer
                checked: true
                automaticCheck: true
                text: qsTr("Pictures")
                onClicked: { picturesTransfer = itspicturestransfer.checked }
            }

            IconTextSwitch {
                visible: transferMode === 0
                enabled: mydatatransfer.hasSshpassInstalled()
                id: itsvideostransfer
                checked: true
                automaticCheck: true
                text: qsTr("Videos")
                onClicked: { videosTransfer = itsvideostransfer.checked }
            }

           Button {
               visible: transferMode === 0
               enabled: ( mydatatransfer.hasSshpassInstalled() && ipAddress.acceptableInput ) && ( passwordField.text.length > 0 ) && (appsTransfer || appdataTransfer ||  callsTransfer || messagesTransfer || documentsTransfer || downloadsTransfer || musicTransfer || picturesTransfer || videosTransfer)
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Transfer")
               onClicked: {
                   remorsepopup.execute(qsTr("Transferring"), function() {
                       settings.isRunning = true;
                       mydatatransfer.transfer(ipAddress.text, passwordField.text, appsTransfer, appdataTransfer, callsTransfer, messagesTransfer, documentsTransfer, downloadsTransfer, musicTransfer, picturesTransfer, videosTransfer);
                   });
               }
           }

           ViewPlaceholder {
               enabled: transferMode === 1
               text: qsTr("Follow the instructions")
               hintText: qsTr("on the device you are transferring from")
           }

        }

        VerticalScrollDecorator { }
    }
}
