//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "Bar/services"

ShellRoot {
    id: rootqs

    NotificationServer {
        keepOnReload: false
        onNotification: notif => {
            notif.tracked = true
            notifPopup.notify(notif.summary, notif.body, notif.appName, notif.appId)
        }
    }

    Instantiator {
        model: Quickshell.screens

        delegate: Loader {
            active: true
            source: "./Bar/Bar.qml"
            onLoaded: item.targetScreen = modelData
        }
    }

    NotifPopup { id: notifPopup }
}
