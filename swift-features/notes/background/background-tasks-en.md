App running in background when its not running in foreground.

Can be entered by 2 ways 
- Be requested by an app. e g downloads, periodic updates
- Be triggered by an event. e g some data emerged, user entered area 

When using background running its important to take into account 3 things 
- Power
App's usage drains battery. Its need to save time system gives to an app. e g notify task is ended with completion handler

- Performance
Several apps can share cpu resourse so its required bakground tasks are complient to API usage limits.

- Privacy.


There are several purposes of running app in background.

- The simpliest one - background task completion. It gives the app or extension additional runtime before it being suspended.
So, when implementing some continuous operation which should be finished if user backgrounds an app, protect it with backround task api started on the user action (dont wait until enteredbackground)

- VoIP pushes (CallKit didrecieveCall is required)

- Background pushes. Alert the app (not the user) that data is available. App starts muthed thread handling new data. New data can be downloaded in background ot when app re-enters foreground. apns-priority = 5, apns-push-type=background 

- Discretionary background URL session. defer some download work, schedule it.

- Background Task scheduling. Procesiing tasks (Core ML learing, inference), refreshing tasks (system gives a time to app to get itself up-to-date. system will learn users apps usage patterns and start refresh task before user launch the app ).

- Task requests are being submitted in BGTaskScheduler which monitors battery usage, network status, system load. When conditions are met it creates a task instance and delivers it to the app. App can be launched for performing several tasks at once. Need to handle expiration and setTaskCompleted. 

- Location updates in background. https://developer.apple.com/documentation/corelocation/handling-location-updates-in-the-background

After scheduling the task, we can mock/force a system call to activate our scheduled task via the debugger with:
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"TASK_IDENTIFIER"]

https://developer.apple.com/videos/play/wwdc2019/707
https://developer.apple.com/documentation/backgroundtasks/choosing-background-strategies-for-your-app
https://uynguyen.github.io/2020/09/26/Best-practice-iOS-background-processing-Background-App-Refresh-Task/

