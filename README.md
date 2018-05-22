# ShakeAwake

  ## Description
  ShakeAwake is an alarm app for iOS which targets users who set many alarms. Alarms for specific times are not created, but exist by default, and are turned on/off by a user. Additionally, users must shake their phone to turn off their alarm.
  
  ## Data Persistance
  There are two ways alarm data is persisted when the app is not running. The first is native CoreData, which is utilized when a user elects to skip the registration/login process. The next is cloud Firebase storage, which is utilized when a user completes the registration/login process.
  
  ## UI/UX
  ShakeAwake uses a black/green color scheme, as it is designed for nightime use. A user will choose an alarm-selection interval which dictates how far apart (in minutes) available alarms are spaced out. Once a user has toggled all desired alarms (via the rightward buttons in the below picture), they can then start up another app and the alarm logic will run in the background. When the alarm goes off, a user must press a button AND shake the device to turn it off. This ensures they are truly awake!
  
  <p align="center">
    <img src="/pics/IMG_3489.PNG" width="340">
  </p>
  
  ## Wireframe
  
  <p align="center">
    <img src="/pics/wireframe.jpg" width="900">
  </p>
  
  ## Build Instructions
  This repository serves as an XCode project, so just clone the repo, pod install, open with XCode, and run the app.
  
 
