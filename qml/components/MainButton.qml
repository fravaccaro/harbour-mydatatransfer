import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    Rectangle {
        color: "green"

        MouseArea {
            anchors.fill: parent
            onClicked: { parent.color = 'red'
            }
        }
    }
}
