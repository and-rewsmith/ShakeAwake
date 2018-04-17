# final-project-final-smithmccall
final-project-final-smithmccall created by GitHub Classroom

__USE THE XCWORKSPACE AND NOT THE XCPROJECT__

What we did:

A lot of the work over the past week was spent configuring environments/firebase/backend.

1. We created a model for how the backend components will work together. We connected our app to a firebase endpoint so that it can remotely save user-specific alarm data in a realtime json database. Also, we integrated this into alarm-interval-settings such that when a user selects frequency of available alarms, our view rendering will retrieve any previously set alarms from firebase and will create the rest locally. Furthermore, when a user sets an alarm our app will communicate with firebase to add the specified alarm to the storage under the user's entry. Most of this is not implemented in the front end yet, but the backend+model works 100%.
2. We set up a table view that will use an instance of our model to render a list of alarms. We also added a settings page and entry-point page.
3. We added functionality so that if there is audio playing, it will stop when the phone shakes. 
