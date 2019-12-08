import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground
{
    Rectangle {
        anchors.fill: parent
        color: "transparent"

    Image {
        id: coverimg
        fillMode: Image.PreserveAspectFit
        source: isLightTheme ? "../../images/coverbg-light.png" : "../../images/coverbg.png"
        opacity: {
            if (settings.isRunning)
               0.1
            else
               (settings.coverActiveTheme) && ((settings.activeIconPack !== 'default') || (settings.activeFontPack !== 'default') || (settings.activeSoundPack !== 'default')) ? 0.1 : 0.3
        }
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: sourceSize.height * width / sourceSize.width
    }

    Image {
        id: refreshimg
        enabled: settings.isRunning
        visible: settings.isRunning
        source: "image://theme/graphic-busyindicator-large"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        width: Theme.itemSizeLarge
        height: Theme.itemSizeLarge
        opacity: 0.6
        RotationAnimation on rotation {
            duration: 2000;
            loops: Animation.Infinite;
            running: settings.isRunning
            from: 0; to: 360
        }
    }
    }
}

