import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import Sailfish.Pickers 1.0
import mydatatransfer.scripts 1.0
import "../components"
import "../common"

Page
{
    id: mainpage
    focus: true
    MyDataTransfer { id: mydatatransfer }

    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - mainpage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, mainpage.height);
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

        if (event.key === Qt.Key_B) {
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

    SilicaListView
    {
        id: flickable
        width: parent.width
        height: parent.height
        anchors.fill: parent
        anchors.bottomMargin: Theme.paddingLarge

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

           header: PageHeader {
               // title: mydatatransfer.whoami()
               title: qsTr("My Data Transfer")
           }

           model: ListModel {
               ListElement {
                   page: "BackupPage.qml"
                   title: qsTr("Backup")
                   subtitle: "Search page shows how to implement in-application search"
               }
               ListElement {
                   page: "RestorePage.qml"
                   title: qsTr("Restore")
                   subtitle: "Search page shows how to implement in-application search"
               }
               ListElement {
                   page: "TransferPage.qml"
                   title: qsTr("Transfer")
                   subtitle: "Search page shows how to implement in-application search"
               }
           }
                delegate: BackgroundItem {
                    width: parent.width
                    Label {
                        text: model.title
                        color: highlighted ? Theme.highlightColor : Theme.primaryColor
                        anchors.verticalCenter: parent.verticalCenter
                        x: Theme.horizontalPageMargin
                    }
                    onClicked: pageStack.push(Qt.resolvedUrl(page))
                }

                VerticalScrollDecorator {}
    }

}
