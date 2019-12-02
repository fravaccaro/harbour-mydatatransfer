import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0

Notification
{
     id: notification
     category: "x-nemo.mydatatransfer"
     appName: "UI Themer"
     appIcon: "/usr/share/icons/hicolor/86x86/apps/harbour-mydatatransfer.png"
     previewSummary: "UI Themer"
     previewBody: qsTr("Settings applied.")
     itemCount: 1
     expireTimeout: 5000
     remoteActions: [ {
         "name": "default",
         "service": "org.nemomobile.mydatatransfer",
         "path": "/done",
         "iface": "org.nemomobile.mydatatransfer",
         "method": "actionDone"
     } ]
 }
