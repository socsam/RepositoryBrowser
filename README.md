The application was build with SOLID principles in mind. 
* Factory pattern was used to encapsulate logic of creating objects and injecting dependencies.
* Generics were used to facilitate adding new features to the app (other repository hostings aside from GitHub - Bitbucket, SourceForge...)
* After search application only loads images for visible cells and continue loading images if user is scrolling. If user start a new search then all currently running network requests are canceled before initiating a new search.
* Following development best practices I separated configuration from code. Config.xcconfig contains GitHub related constants.
* Project uses localization to make it easier adding new languages to the app
* Unit tests implemented for models
* UI creation and layout was done programmatically because when working in teams it’s easier to merge code rather than .xib/.storyboard files
* Even though majority user already upgraded to iOS13 It’s a good practice to support previous version of iOS 12 to facilitate this necessary changes were made in AppDelegate.swift and SceneDelegate.swift
* No third party library are used
* Proxy server was used to observe behavior of the app on slow/unreliable internet connection
* json data is cached using URLSessionConfiguration 
* user avatars are cached using NSCache
* Implemented authentication (Basic) to get more results before reaching API limits. Usually credentials or OAuth tokens are saved in KeyChain but I haven’t implemented it for this test project
* Infinite scrolling working for the first screen, using UITableView pre-fetch api

Some ways to improve the app
* Accessibility features for people with physical limitations
* Implement UI tests (XCUITest + accessibilityIdentifier)
* Add more documentation to the code (explaining classes and methods)
