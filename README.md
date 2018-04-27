# CS 4720 - S18 - Final Project Proposal

**Device Name:** iPhone 6		

**Platform:** iOS

**Name:**  Rossi McCall		

**Computing ID:** rem8aj

**Name:**  Andrew Smith		

**Computing ID:** als53v

**App Name:** Swipe Awake

### Project Description:  
Our app will allow users to set a series of alarms via selecting a range of times rather than manually setting each alarm. Our implementation is directed towards morning use as it allows users to easily set a series of alarms easily. Users will also have username and password information to allow them to save their alarm preferences and use them on multiple devices. The user can select snooze on the screen or shake the phone to snooze the alarm. They can also select “I’m Awake” and the remainder of the alarms for that day will be turned off.


### What we propose to do is create an app that will do the following:
- The system shall allow a person to create a profile in order to share user-specific configuration settings between devices.
- The system shall remember device-specific configuration settings by default through native phone persistence (i.e. if an account isn’t signed in on a device, still track the data locally as if it was an account).
 - The system shall allow a person to set a series of alarms easily and quickly
- The system shall allow a person to snooze alarms by shaking the device or pressing a button.
- The system shall allow users to set their own alarm sounds from a pre-selected group of sounds.

### We plan to incorporate the following features:

- **Register shaking** - A person can shake the phone to snooze an alarm. 
- **Build and consume your own web service using a third-party platform** - We will store user information with Firebase so that the user can access it from multiple devices.
- **Data storage using Core Data storage** - We will store device specific references/alarms for people that don’t wish to create an account.
- **Audio management** - We will provide the person with a pre-selected set of sounds to choose for their alarm tone.


### Wireframe Description:

Our wireframe shows the basic layout we are envisioning for our app. After the launch screen appears, there will be fields to input the username and password. We added the ability for users to set their usernames and passwords by selecting the register button on the start screen. There is also a button to allow users to bypass this option and just save preferences locally. Both the login and skip buttons will take the user to the table view which is prepopulated with times on a five minute interval. The user can then select which times they want the alarm to go off by selecting the buttons next to the desired times. When the user navigates to settings, they can select the desired alarm tone as well as the interval for the time table. We combined the different tabs into one. If the user changes the interval to 10 minutes and then navigates back to the table view, they will now see half as many alarm options. 


### Platform Justification - What are the benefits to the platform you chose?
- iPhones are very heavily used in the US so developing for iPhone could help more people have access to our app.
- We both have iPhones so we could easily test our app on our devices.
- While Android phones are more heavily used worldwide, iPhone apps make [significantly more money than Android apps](https://www.neowin.net/news/apples-app-store-experienced-60-growth-google-play-app-revenue-grew-82-in-q4-2016)  in terms of net revenue.
### Major Features/Screens - Include short descriptions of each (at least 3 of these)
- **Login Screen**- the user can elect to login with a username and password or skip this step and store data locally on their phone.
- **Time Table Screen**- dynamically generated table of all the possible alarm times with corresponding buttons to set the alarm.
- **Settings Screen**- the user can select the ringtone they want to play when the alarm goes off as well as the interval for the time table.
### Optional Features - Include specific directions on how to test/demo each feature and declare the exact set that adds up to ~60 pts
- **Audio Management (20 pts)**- a ringtone plays automatically whenever an alarm goes off. 
- **Build and consume a webservice using a third party platform (15 pts)**- the app gives the user the ability to create an account and share alarms between devices. When users elect to login with an account, their alarm preferences are dynamically added to firebase as they select them. This allows users to have multiple devices running the app. It would also be useful if we wanted to implement a desktop application in the future.
- **Device Shake (10 pts)**- If the user shakes their phone while an alarm is going off it will silence the alarm. Any other alarms will still go off.
- **Data storage using Core Data (20 pts)**- if the user elects not to sign in, their user preferences will be saved locally on Core Data.
### Testing Methodologies - What did you do to test the app?
- We connected our phones to our computers and ran the app. 
- We tested various test cases including selecting multiple alarms very close together, adding duplicate data to core data, and others.
 - We tested the backend components through the consol making sure that firebase updated as we selected alarms.
### Usage - Include any special info we need to run the app (username/passwords, etc.)
- You do not need any information to run the app with Core Data.
- You can make an account and login using a custom username and password using the register button on the first page.
### Lessons Learned - What did you learn about mobile development through this process?
- Mobile app development is significantly clunkier than other forms of software development. For us, many of the methods we had to use for implementing features was not intuitive.
- It’s very useful to think carefully and at a high level about what we want our app to do and how we want to do it before we begin implementation.
- Everything that can go wrong will go wrong.
