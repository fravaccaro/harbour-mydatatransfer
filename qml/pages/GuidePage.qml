import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page
{
    id: guidepage
    focus: true

    RemorsePopup { id: remorsepopup }
    BusyState { id: busyindicator }

    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - guidepage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, guidepage.height);
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

        if (event.key === Qt.Key_H && settings.wizardDone === true) {
            pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"));
            event.accepted = true;
        }

        if (event.key === Qt.Key_A) {
            pageStack.replace(Qt.resolvedUrl("AboutPage.qml"));
            event.accepted = true;
        }
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent
        contentHeight: content.height

        VerticalScrollDecorator { }

        Column
        {
            id: content
            width: parent.width

            PageHeader { title: qsTr("Usage guide") }

            Item {
                height: appicon.height + Theme.paddingMedium
                width: parent.width
                Image { id: appicon; anchors.horizontalCenter: parent.horizontalCenter; source: "../../images/appinfo.png" }
            }

            LabelText {
                text: qsTr("UI Themer lets you customize icons, fonts and pixel density in Sailfish OS.")
            }

            LabelText {
                text: qsTr("Remember to unapply themes and display density customizations before updating your system. In case you forgot, you may need to use the options provided in the <i>Recovery</i> page or uninstall and reinstall Theme pack support e UI Themer.")
            }

            SectionHeader { text: qsTr("Themes") }

            LabelText {
                text: qsTr("The <i>Themes</i> page lets you customize icons and fonts via thirdy party themes. The page lists the themes you have currently installed (e.g. from OpenRepos). To apply them, tap on a theme of your choice and then select what you want to use from that theme - if the theme contains different font weights, you can choose the default one to use for the UI. You can also combine different themes, so for example you can use icons from a theme and fonts from another. To revert to the default settings, you can use the restore option from the pulley menu.")
            }


            LabelText {
                text: qsTr("If you have Storeman installed, you can quickly look for compatible themes by using the <i>Download</i> icon in the main page.")
            }


            SectionHeader { text: qsTr("One-click restore") }

            LabelText {
                text: qsTr("UI Themer customizations must be reverted before performing a system update. With <i>One-click restore</i> you can automate this process and restore icons, fonts and display density settings with just one click.")
            }

            SectionHeader { text: qsTr("Keyboard shortcuts") }

            LabelText {
                text: qsTr("UI Themer can be navigated via a physical keyboard, using convenient shortcuts.")
            }

            LabelText {
                text: qsTr("Press <b>H</b> for the home page.")
            }

            LabelText {
                text: qsTr("Press <b>O</b> for the options page.")
            }

            LabelText {
                text: qsTr("Press <b>G</b> for the usage guide.")
            }

            LabelText {
                text: qsTr("Press <b>A</b> for the about page.")
            }

            LabelText {
                text: qsTr("Press <b>B</b> to go back to the previous page.")
            }

            LabelText {
                text: qsTr("You can quickly restart the homescreen after you applied a setting by pressing <b>R</b>.")
            }

            LabelText {
                text: qsTr("You can cancel a countdown or a dialog by pressing <b>C</b>.")
            }


            SectionHeader { text: qsTr("Further help") }

            LabelText {
                text: qsTr("If you still can't get the help you need, you can open an issue on") + " <a href='https://github.com/uithemer/sailfishos-uithemer/issues'>GitHub</a>."
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
        }

    }
}
