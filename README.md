# FlutterDragDrop

A basic drag and drop flutter application.

## Description
This simple demo allows you to sign up and log in via [Firebase Authentication](https://firebase.google.com/products/auth) 
to a personal space on [Firestore cloud](https://firebase.google.com/products/firestore).
Once logged in, you can generate random shapes by pressing the *Add* button in the right corner.
Drag and drop the shapes in different positions of the grid.
Your progress is saved in the cloud in real time.

### Sign up
Choose a nickname, email and password to register. You will be informed if the email is not available.

### Log in
The login is through authentication with email and password. Passwords must be at least 6 characters.

## Cloud Firestore
Upon registration, every user is added to a Firestore collection called `users`, that saves a document
for each of them. The user document contains profile information. It also tracks every movement in 
the user grid, by updating a personal field `shapes` that maps the objects onto the grid.
