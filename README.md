# AdviceBee-Web


AdviceBee-Web, otherwise known as the Admin Panel, is a Flutter Web application. In this website, an Admin user will be able to log into the site and view & control various aspects of the application. These include reviewing and acting on user reported Posts, updating the daily number of post per rank values, and view overview metrics of the AdviceBee application.

## Installation

This application uses Flutter Web, in order to install and run this program you must do the following:

0. Pull down the repo to your local machine.
1. Install [Chrome](https://www.google.com/chrome/).
2. Install [Visual Studio Code](https://code.visualstudio.com/download).
3. Install the [Flutter Plugin](https://flutter.dev/docs/development/tools/vs-code) on Visual Studio Code.
4. Install [Flutter](https://flutter.dev/docs/get-started/install) on your local machine.
5. Update the Flutter SDK for [Flutter Web](https://flutter.dev/docs/get-started/web)
6. Install [npm](https://www.npmjs.com/get-npm)
7. User Terminal to `cd` into the `AdviceBee-Web/admin-panel`  directory of the local cloned repo.
8. Run `flutter pub get`
9. Run `npm install`

## Running
Once all the steps in the Installation section have been completed, its time to run the app.

### Using Terminal
1. User Terminal to `cd` into the `AdviceBee-Web/admin-panel`  directory of the local cloned repo.
2. run `flutter run -d chrome`

### Using Visual Studio Code (Preferred)
1. Open the project using Visual Studio Code.
2. Open a `.dart` file in the `AdviceBee-Web/admin-panel/lib` directory.
3. Visual Studio Code should auto-detect Flutter and allow you to change the device to run the code on in the bottom toolbar on the bottom right.
4. Choose `Chrome web` as your device.
5. Hit F5 on your keyboard to run the application.

## Using
Upon successful installation and running of the application on Chome, the first screen you will see is a Login Page.
1. Use the email and password credentials of an Admin user to fill out the form.
2. Once successfully logged in, you will land on the main page, the Overview page.
3. You can Use the navigation bar to navigate the other pages, and also sign out once you are complete.
