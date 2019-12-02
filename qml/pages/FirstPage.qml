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

           Button {
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Backup")
               onClicked: {
                   remorsepopup.execute(qsTr("Backuping"), function() {
                       busyindicator.running = true;
                       mydatatransfer.backup();
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

           Button {
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Restore")
               enabled: selectedBackupFile ? true : false
               onClicked: {
                   remorsepopup.execute(qsTr("Restoring backup"), function() {
                       busyindicator.running = true;
                       mydatatransfer.restore(firstpage.selectedBackupFilePath);
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
                       mydatatransfer.transfer(ipAddress.text, passwordField.text);
                   });
               }
           }

           Button {
               enabled: ( ipAddress.acceptableInput ) && ( passwordField.text.length > 0 )
               anchors.horizontalCenter: parent.horizontalCenter
               text: qsTr("Transfer")
               onClicked: {
                   remorsepopup.execute(qsTr("Transfering"), function() {
                       busyindicator.running = true;
                       mydatatransfer.transfer(ipAddress.text, passwordField.text);
                   });
               }
           }



        }

        VerticalScrollDecorator { }
    }
}
