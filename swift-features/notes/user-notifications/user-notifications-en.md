User notifications  

To show notifications to the user, ask for a permission.

try? await center.requestAuthorization(options: [.alert, .sound, .badge])

Local notifications 

Notifications can be sent locally being triggered by some condition (date, time, location).

let center = UNUserNotificationCenter.current()
let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
try? center.add(request)

Request can be cancelled if its no need to make a push.

https://developer.apple.com/documentation/usernotifications/scheduling-a-notification-locally-from-your-app

Remote notifications

- Get device token identifier
- Establish a token-based(JWT) connection (HTTP/2, TLS 1.2) with code or CLI.
- Create a payload.
- Send POST to APN. Fill out all necessary headers.

https://developer.apple.com/documentation/usernotifications/sending-notification-requests-to-apns

Notification types

alert - Shows a message with specified content.

background - Starts a background task https://developer.apple.com/documentation/usernotifications/pushing-background-updates-to-your-app

controls - https://developer.apple.com/documentation/WidgetKit/Updating-controls-locally-and-remotely

location - app's location extension is activated when recieved push notification and then, user's location can be handled.https://developer.apple.com/documentation/CoreLocation/creating-a-location-push-service-extension

voip - https://developer.apple.com/documentation/PushKit/responding-to-voip-notifications-from-pushkit

complication - Complications display relewant data on Apple Watch. https://developer.apple.com/documentation/ClockKit/keeping-your-complications-up-to-date

fileprovider - Fileprovider allows to get access to files being synced with remote server. https://developer.apple.com/documentation/fileprovider. Use pushes to notify file provider extension (e g to update local files).

mdm - Mobile device management - allows to manage and configure enrolled devices remotely. (Push tells a device to contact mdm server). https://developer.apple.com/documentation/DeviceManagement

liveactivity - https://developer.apple.com/documentation/ActivityKit/starting-and-updating-live-activities-with-activitykit-push-notifications

pushtotalk - Notify when audio transmission begins or ends, and when a person joins or leaves a channel. https://developer.apple.com/documentation/pushtotalk/creating-a-push-to-talk-app


You can monitor the status of your push notifications, after APNs accepts your request, using Metrics.

https://developer.apple.com/documentation/usernotifications/viewing-the-status-of-push-notifications-using-metrics-and-apns


Actionable notifications
https://developer.apple.com/documentation/usernotifications/declaring-your-actionable-notification-types


https://developer.apple.com/documentation/usernotifications
