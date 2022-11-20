# Swift Concurrency Network Manager

This project utilises Swift Concurrency to create a network manager. This project using swift actors to avoid data races, with careful checks for reentrancy bugs and using async/await for making network requests. 

This is what the network manager can do using swift actors and async/await:
- Log where username and password are coming in the form of `form-data`
- `HTTP GET`
- `HTTP POST`
- `HTTP PATCH`
- `HTTP PUT`
- `HTTP DELETE`
- In an event where a `401` is returned. Initial assumption is that the token has expired. The request is re-tried with new token

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
 
 I've included some comments inside some files to give more of an overview. 
 
 Note: the login and logout screen were pretty basic, there is no validation check to see if email address is correct format etc. This was only created to test the network manager.
 
| Login Screen  |  Logout Screen |
|---|---|
| ![login](https://user-images.githubusercontent.com/80204376/202900321-5667b0d9-85d2-42b2-8aa2-116e3a7f12a8.png)  |  ![logout](https://user-images.githubusercontent.com/80204376/202900325-82cf539b-6e2f-4178-ae5b-2dd2f6e6b507.png) |


# Future work:
- Write unit tests for network manager (maybe mocking?)
- Some refactor work is needed 
- Not the best errors were thrown in certain scenarios.
- Add REGEX check to see if valid email adress. Basically more checks on login screen.
  

