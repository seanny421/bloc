# Waracle Tech Test - Flutter :technologist:

Thanks for applying to Waracle! The purpose of this test is to assess your skills and understanding of the Dart programming language, Flutter development and software engineering practices.

The provided a Flutter project is a prototype of a simple app to display a list of cakes with thumbnail images. When a cake is selected, a detail view is shown with a large image.

Unfortunately the prototype has a number of bugs and issues, and also is not particularly well engineered! Your task is to fix and refactor the app to address these concerns, and also add a pull-to-refresh feature that looks right on each platform.

Minimum Requirements
Layout issues should be fixed and the UI should adapt well to different phone sizes (don’t worry about tablet form factors!)
UI interaction should be smooth and app should not stutter
App should be performant and work reliably without crashing
At least devices running the last 3 version of iOS and or Android should be supported
You should add "pull to refresh" support to the app - i.e. when the main list is pulled down, the standard pull to refresh control for the platform should be shown and the JSON reloaded from the network.
What we are looking for
In addition to the above requirements above you should:

Improve the quality of the code / architecture
Demonstrate good software engineering practice
Update and fill out the file NOTES.md
Please also:

Use the latest non-beta version of Flutter that is available at the time of completing the test and document which version is used in NOTES.md
Do NOT use any third party libraries, but feel free to suggest any that you might have used in your NOTES.md file.
Submission process
Provide your final submission as a Zip file via email, including your .git folder to preserve any git history
If you fork the repository, please ensure your fork is private and not visible to other potential candidates.
You may change, rewrite, adapt and improve as much of the app as you like within the constraints above. There is no one right solution, so feel free to impress us!

There is no limit to how long you can take to complete the test, however we suggest it should take around 3 hours. We are not looking for perfection, so feel free to suggest a list of things you would add or improve if you had more time in your NOTES.md file.

Notes:

- Firstly, let's get to latest stable version of flutter, upgraded to 3.41.6
- Crashes on startup due to gradle properties, noticed we're using Java 1.8, let's update to recommended minimum as per play store requirements
- Deal with l10n issue and run app
- created a cake repo and cubit with bloc
- updated to use go router
- update some UI bits
- fix but with settings page where it doesn't update after dropdown clicked

Future work / recommendations:
- create an api_service so if we have multiple repositories we can abstract out common logic e.g. auth headers / token refresh 
- add a local_storage_service maybe with the hive or shared_preferences packages so that each bloc / cubit can handle their own offline functionlity with caching
- use freezed package to generate common methods e.g fromJson / toJson as well as for the CakeState class so we can use the factory pattern.
