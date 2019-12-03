import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page
{
    id: aboutpage
    focus: true

    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - aboutpage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, aboutpage.height);
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
            pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"));
            event.accepted = true;
        }

        if (event.key === Qt.Key_G) {
            pageStack.push(Qt.resolvedUrl("GuidePage.qml"));
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

            PageHeader { title: qsTr("About My Data Transfer") }

            Item {
                height: appicon.height + Theme.paddingMedium
                width: parent.width
                Image { id: appicon; anchors.horizontalCenter: parent.horizontalCenter; source: "../../images/appinfo.png" }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                text: "My Data Transfer 0.0.1" }

            LabelText {
                text: qsTr("Backup and transfer app data, documents, music, pictures and videos.")
            }

            LabelText {
                text: qsTr("Released under the <a href='https://www.gnu.org/licenses/gpl-3.0'>GNU GPLv3</a> license.")
            }

            LabelSpacer { }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Sources")
                onClicked: Qt.openUrlExternally("https://fravaccaro.github.io/harbour-mydatatransfer")
            }

              SectionHeader { text: qsTr("Feedback") }

              LabelText {
                  text: qsTr("If you want to provide feedback or report an issue, please use GitHub.")
              }

            LabelSpacer { }

              Button {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: qsTr("Issues")
                  onClicked: Qt.openUrlExternally("https://github.com/fravaccaro/harbour-mydatatransfer/issues")
              }

              SectionHeader { text: qsTr("Support") }

              LabelText {
                  text: qsTr("If you like my work and want to buy me a beer, feel free to do it!")
              }

            LabelSpacer { }

              Button {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: qsTr("Donate")
                  onClicked: Qt.openUrlExternally("https://www.paypal.me/fravaccaro")
              }

              SectionHeader { text: qsTr("Credits") }

              LabelText {
                  text: qsTr("Part of this app is based on <a href='https://github.com/RikudouSage/sailfish-iconpacksupport-gui'>Icon pack support GUI</a> by RikudouSennin.")
               }

              LabelText {
                  text: qsTr("Keyboard navigation based on <a href='https://github.com/Wunderfitz/harbour-piepmatz'>Piepmatz</a> by Sebastian Wolf.")
               }

              LabelText {
                  text: qsTr("App icon by") + " <a href='http://www.freevectors.com/blue-painting-roller/'>Free Vectors</a>."
               }

              LabelText {
                  text: qsTr("Iconography by") + " <a href='https://www.flaticon.com/authors/retinaicons'>Retinaicons</a>."
               }

              LabelText {
                  text: qsTr("Thanks to Dax89 for helping with C++ and QML code, this app would not exist without him.")
               }

              LabelText {
                  text: qsTr("Thanks to Eugenio_g7 for helping with the <i>One-click restore</i> service.")
               }

              LabelText {
                  text: qsTr("Thanks to LQS for helping with the Android DPI on the Xperia XA2.")
               }

              LabelText {
                  text: qsTr("Thanks to all the testers for being brave and patient.")
               }

              SectionHeader { text: qsTr("Translations") }

              DetailItem {
                  label: "Italiano"
                  value: "Francesco Vaccaro"
              }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
        }

    }
}
