# ISS Utility

### Architecture

- The VIPER architecture has been implemented throughout this project. The abstraction and modularity afforded by this clean design pattern allows for extensive reusability & testability.

### Functionality

[ISS Flyover Times] - Displays the ISS flyover times for the user's current location.
[ISS Current Location] - Displays the current location of the ISS.
[ISS Compass Location] - Displays the location of the ISS relative to the location of the user.

### Testing

- Testing expertise has been demonstrated on the Home and Flyover modules, as well as the API layer. Whilst the tests on these elements are extensive, in the interest of time they are not all-encompassing.

### Future Enhancements

With more time, there are many potential avenues for improvements - some of greater importance and significance than others.

Examples of items which may warrant consideration include:

- [Functionality] Caching of flyover times, which would greatly improve the offline experience.
- [Functionality] Allow user to specify a location (vs using their own), and even view times for specific date range, etc.
- [Functionality] Allow user to share flyover times.
- [Functionality] Rotation of the ISS could also have been achieved through application of CGAffineTransforms.
- [Testing/Arch] Encapsulation of CLGeocoder to increase geocoding testability.
- [Testing] Tests for our LocationProvider are a necessity.
- [General] Abstraction of logging functionality into independent, injectable layer for a more DRY, testable solution.
- [General] Abstraction of reachability functionality into independent, injectable layer for a more DRY, testable solution.
- [General] Wider cost/benefit trade-off of using a third-party Reachability library long-term should be assessed.
- [General] Images and strings are accessed or declared using non-localized raw values, an approach which is prone to human error. A tool like SwiftGen would greatly improve confidence through generated paths.
- [General] The ability to reload the datasources for the views without going back/forth - for generally better UX & iOS best-practice.
- [General] Opportunities for concurrent request handling on the FlyoversPresenter should be considered.
- [Location Management] Notifications handlers can be used to listen for changes in privacy settings, which would offer a smoother experience for users coming back into the app after updating their settings.

### Notes

- A Reachability library was implemented to allow time to focus on the API integration. This is an intermediary layer on the SCNetworkReachability interface, which allows an application to determine the status of a system's current network configuration and the reachability.
- Despite explicitly requesting 5 flyover times, at times Open Notify's API intermittently seems to erroneously return 1 less result than specified. This behaviour can be experienced agnostic of the client - Postman, Browser, etc.

### Acknowledgements

- App Icon made by Freepik from www.flaticon.com.
