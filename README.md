# BigBrother

BigBrother was the final project for our FIT5140 unit. BigBrother is an iOS application for an IoT surveillence system with motion detection and facial recognition.

## What I learned
* Programme a Flask web server in python to view Raspberry Pi camera feed on the iOS application.
*	Programme a Raspberry Pi server in python for motion detection and image capturing.
*	Develope a Google firebase serverless backend for storing and processing motion sensing data in real-time.
*	Integrate Amazon S3 buckets and AWS machine learning SDK with the raspberry pi server and iOS for facial recognition


### Onboarding Screen:

![](Images/Intro.gif)

The onboarding screen is only shown when the user first installs the app. The intro gives the user some details about the functionality of the app. Then it gives the option to scan the bar code that is attached on the box to register the device. Once the device is registered, the user will never see this screen again unless they reinstall the app. The device ID is stored using User Defaults to make it persistent. Picture of a sample barcode is given below.

![](Images/Sample_BarCode.png)

### Login Screen: 

![](Images/Login.png) ![](Images/Register.png)

Once the device is registered, the user is taken to the login screen where they can log in using their credentials. if they does not have an account they can register for a new account. Used Email/Password authentication in Firebase for this feature

### Home Screen:

![](Images/Home.gif)

Once the user has logged in, They are taken to the Home screen from where they have access to all the functionality of the app. Under recent visitor, it will list the last 5 faces detected by the system. When they click on view all, they can go though all the entires. Clicking on any entry will take them to the detail screen. The user can also use the bottom animated menu to access the live stream and also gives them the option to log out

### Adding a new face:

![](Images/Unrecognized.png)

If the face detected is unknown, the user will get the option to add that face to the collection

![](Images/Add_new.png)

The user just have to enter a valid name to add the new face to the collection.

![](Images/Recognized.png)

Once the face it added, the system would recognize the face the next time it detects that face. The facial recognition is done using Amazon Rekognition.

* The color palette for this project was inspired by https://dribbble.com/shots/7867164-Vortex-a-new-way-of-messaging  
* The icons and logo for this project are taken from icon8 https://icons8.com/
* Backend using Firebase: https://firebase.google.com/
* Facial Recognition using Amazon Rekognition: https://aws.amazon.com/rekognition/

