import QtQuick 2.0
import Sailfish.Silica 1.0
    
    Label {
        id: confirmheader
        width: parent.width - (x * 2)
        x: Theme.paddingLarge
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Theme.fontSizeExtraLarge
        truncationMode: TruncationMode.Fade
        wrapMode: Text.WordWrap
    }
