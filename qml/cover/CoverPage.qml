import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground
{
    Image
    {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: isLightTheme ? "../../images/coverbg-light.png" : "../../images/coverbg.png"
        opacity: 0.6
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }
}

