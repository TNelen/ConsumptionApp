# Consumption

Consumption tracker app

## Getting Started

### Install the necessary dependencies
    flutter pub get


### Run the application locally
    flutter run -d chrome --web-port=7357

This forces the application to be ran on with Chrome brower, and on web port 7357;
This url (http://localhost:7357) is set as a whitelisted Javascript origin domain for Google Authentication API


### Database configuration
Please ask Timo Nelen to be added to the firebase project

### Deploying the app
> This is only possible if you have access to the firebase

#### Install firebase CLI 
    npm install -g firebase-tools

#### Deploying to firebase hosting
    firebase deploy


All the deployment configuration is preconfigured in the firebase.json file.