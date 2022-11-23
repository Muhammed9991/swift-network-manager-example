# Swift Concurrency Network Manager

**To see how the network request were made. Look at the code in the SPM SwiftNetworkManager**

Example repo using Network Manager from https://github.com/Muhammed9991/SwiftNetworkManager.

As part of this project, I create a login and log out screen (see below). The API I was using in this was a locally hosted API created using FastAPI from this (highly reccomended) tutorial https://www.youtube.com/watch?v=0sOvCWFmrtA&t=33685s, written in python. 

In the API I created all endpoints were protected using a JWT token. To access any data I needed to complete some authentication, receive a JWT token and use this to access data. The login screen was created for this. These are the following responsibility of the login screen:

- Authentication
  - Succesful
     - Show "Login succeeded!" banner
     - Recieve token from API
     - Store token in keychain
     - Store username in keychain (for token refresh)
     - Store password in keychain (for token refresh)
     - Navigate to next screen, wehere two API reqeust are made:
        - To get some text from the data base (See code)
        - To get an image
  - Failure:
     - Show "Information not correct. Try again."
 
 When the user clicks on the `logout` button. These are following things that happen:
 - Username deleted from keychain
 - Password deleted from keychain
 - Token deleted from keychain
 - Navigate back to login screen
  
 Note: the login and logout screen were pretty basic, there is no validation check to see if email address is correct format etc. This was only created to test the network manager.
 
| Login Screen  |  Logout Screen |
|---|---|
| ![login](https://user-images.githubusercontent.com/80204376/202900321-5667b0d9-85d2-42b2-8aa2-116e3a7f12a8.png)  |  ![logout](https://user-images.githubusercontent.com/80204376/202900325-82cf539b-6e2f-4178-ae5b-2dd2f6e6b507.png) |


# Future work:
- Write unit tests for network manager (maybe mocking?)
- Some refactor work is needed 
- Not the best errors were thrown in certain scenarios.
- Add REGEX check to see if valid email adress. Basically more checks on login screen.
  

