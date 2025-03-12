App-based lifecycle states

1. Not running - app isnt yet started, not allocated in memory. First step of app. This state can be achived from Background and Suspended states.
Suspended -> Not running.
Background -> Not running.
applicationWillTerminate(_ application: UIApplication)

2. Foreground inactive (FI).
Not running > FI

FA -> FI (temporary interruptions e. g. call, alerts); applicationWillResignActive(_:)

Background -> FI; (calls applicationWillEnterForeground(_:))
Save user data to disk and close any open files
Suspend dispatch and operation queues
Need to invalidate any active timers
Don’t schedule any new tasks 
https://developer.apple.com/documentation/uikit/preparing-your-ui-to-run-in-the-foreground

Suspended -> FI.

3. Foreground active (FA).
FI -> FA.

4. Background.
Not running -> Background.
FI -> Background applicationDidEnterBackground(_:)
Save data and quiet your app’s behavior
Finish crucial tasks, free up as much memory as possible, and prepare for your app snapshot. 
https://developer.apple.com/documentation/uikit/preparing-your-ui-to-run-in-the-background

5. Suspended. Not running -> Suspended. Background -> suspended.


Scene-based states

Same but state is unattached (instead of "isnt running" for app).

Launch

During the launch initialize all services the app needs / make configurations / load data (do not block main thread) / restore app state.

The process is described in https://developer.apple.com/documentation/uikit/about-the-app-launch-sequence

Prewarming - launch non-running app to reuce amount of time up to app is usable.
https://developer.apple.com/videos/play/wwdc2017/413

It is possible to preserve/restore state of application / state of controllers. The process is customizable.
https://developer.apple.com/documentation/uikit/preserving-your-app-s-ui-across-launches


https://developer.apple.com/documentation/uikit/managing-your-app-s-life-cycle

