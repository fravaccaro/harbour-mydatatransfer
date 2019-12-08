import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "common"

ApplicationWindow
{
    property bool isLightTheme: (Theme.colorScheme === Theme.LightOnDark) ? false : true
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    _defaultPageOrientations: defaultAllowedOrientations
    
    Settings { id: settings }
}
