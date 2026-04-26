//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "Bar/services"

ShellRoot {
    id: rootqs

    property ListModel notifications: ListModel {}

    NotificationServer {
        keepOnReload: false
        onNotification: notif => {
            notif.tracked = true
            notifPopup.notify(notif.summary, notif.body, notif.appName, notif.appId)
            rootqs.notifications.append({ "notif": notif })
            notif.closed.connect(() => {
                for (let i = 0; i < rootqs.notifications.count; i++) {
                    if (rootqs.notifications.get(i).notif === notif) {
                        rootqs.notifications.remove(i)
                        break
                    }
                }
            })
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
