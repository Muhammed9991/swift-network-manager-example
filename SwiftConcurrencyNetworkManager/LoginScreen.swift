//  LoginScreen.swift
//  Created by Muhammed Mahmood on 05/11/2022.

import SwiftUI
import NetworkManager

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginScreen: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var authenticationDidFail: Bool = false
    @State private var authenticationDidSucceed: Bool = false
    @FocusState private var dimissKeyboard: Bool
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    WelcomeText()
                    UserImage()
                    
                    UsernameTextField(username: $username, dismissKeyboard: $dimissKeyboard)
                    PasswordSecureField(password: $password, dismissKeyboard: $dimissKeyboard)
                    
                    if authenticationDidFail {
                        Text("Information not correct. Try again.")
                            .offset(y: -10)
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink(
                        destination: LogOutView(
                            authenticationDidSucceed: $authenticationDidSucceed
                        ),
                        isActive: $authenticationDidSucceed
                    ) { EmptyView() }
                    
                    LoginButton(
                        username: $username,
                        password: $password,
                        authenticationDidFail: $authenticationDidFail,
                        authenticationDidSucceed: $authenticationDidSucceed
                    )
                }
                .padding()
                
                if authenticationDidSucceed {
                    LoginSucceededPopUp()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        dimissKeyboard = false
                    }
                    Spacer()
                }
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

struct LoginButton: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var authenticationDidFail: Bool
    @Binding var authenticationDidSucceed: Bool
    @FocusState private var dimissKeyboard: Bool
    
    var body: some View {
        Button {
            print("Login Button tapped")
            Task {
                do {
                    let accessToken = try await NetworkManager.shared.login(
                        username: username.lowercased(),
                        password: password
                    )
                    
                    authenticationDidSucceed = true
                    
                    let accessTokenData = Data(accessToken.utf8)
                    let userNameData = Data(username.utf8)
                    let passwordData = Data(password.utf8)

                    try await LoginAuth.shared.saveToken(accessTokenData) // Storing in keychain
                    try await LoginAuth.shared.saveUsername(userNameData) // Storing in keychain
                    try await LoginAuth.shared.savePassword(passwordData) // Storing in keychain 
                    
                    username = ""
                    password = ""
            
                } catch {
                    authenticationDidFail = true
                    print("ERROR:", error)
                }
            }
            dimissKeyboard = true
        } label: {
            GenericButton(buttonText: "LOGIN")
        }
        .disabled(username == "" || password == "") // Really simple check
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("Welcome")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UserImage: View {
    var body: some View {
        Image("Apple_logo_black")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
        
    }
}

struct GenericButton: View {
    let buttonText: String
    var body: some View {
        Text(buttonText)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct UsernameTextField: View {
    @Binding var username: String
    var dismissKeyboard: FocusState<Bool>.Binding
    
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .focused(dismissKeyboard)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    var dismissKeyboard: FocusState<Bool>.Binding
    
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .focused(dismissKeyboard)
    }
}

struct LoginSucceededPopUp: View {
    var body: some View {
        Text("Login succeeded!")
            .font(.headline)
            .frame(width: 250, height: 80)
            .background(Color.green)
            .cornerRadius(20.0)
            .foregroundColor(.white)
            .animation(.easeIn(duration: 2), value: 1.0)
    }
}
