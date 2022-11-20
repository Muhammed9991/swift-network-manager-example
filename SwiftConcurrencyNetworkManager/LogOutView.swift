//  LogOutView.swift
//  Created by Muhammed Mahmood on 20/11/2022.

import SwiftUI
import NetworkManager

struct Post: Codable {
    let title, content: String
    let published: Bool
    let id: Int
    let createdAt: String
    let ownerID: Int
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case title, content, published, id
        case createdAt = "created_at"
        case ownerID = "owner_id"
        case owner
    }
}

struct Owner: Codable {
    let id: Int
    let email, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
    }
}

struct LogOutView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var id: Int = 1
    @State private var createdAt: String = ""
    @Binding var authenticationDidSucceed: Bool
    
    
    var body: some View {
        VStack {
            
            Text(title)
                .font(.title)
                .padding()
            VStack{
                Text(content)
                Text(createdAt)
            }
            
            GetImage(
                urlString: "https://developer.apple.com/news/images/og/swiftui-og.png",
                errorPlaceHolder: Color.red,
                placeholder: Color.blue
            )
            
            Spacer()
            
            Button {
                Task {
                    do {
                         let tokenLocation = "access-token"
                         let usernameLocation = "username"
                         let passwordLocation = "password"
                        
                        try await AuthManager.shared.deleteItemFromKeychain(service: tokenLocation)
                        try await AuthManager.shared.deleteItemFromKeychain(service: usernameLocation)
                        try await AuthManager.shared.deleteItemFromKeychain(service: passwordLocation)
                        let _ = print("------------------------------------------")

                        let _ = print("User succesfully logged out and details deleted from keychain")
                        let _ = print("------------------------------------------")

                    
                        authenticationDidSucceed = false
                
                    } catch {
                        print("Unable to Log out:", error)
                    }
                }
            } label: {
                GenericButton(buttonText: "LogOut")
            }

            
            
        }
        .padding()
        .task {
            do {
                let data: Post = try await NetworkManager.shared.get(
                    with: PostApi.getSinglePost(userID: 1).path
                )
                title = data.title
                content = data.content
                id = data.id
                
                let _ = print("------------------------------------------")
                let _ = print("Complete Data Object:", data)
                let _ = print("------------------------------------------")
                title = "User with the id \(data.id) just published"
                content = data.content
                createdAt = data.createdAt
                
            } catch ServerError.missingToken {
                title = "ERROR: \(ServerError.missingToken)"
            } catch {
                title = "ERROR: \(error)"
            }
        }
    }
}

struct LogOutView_Previews: PreviewProvider {
    static var previews: some View {
        LogOutView(
            authenticationDidSucceed: .constant(true)
        )
    }
}

struct GetImage: View {
    let urlString: String
    let errorPlaceHolder: Color
    let placeholder: Color
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image.resizable() // Displays the loaded image.
            } else if phase.error != nil {
                errorPlaceHolder // Indicates an error.
            } else {
                placeholder // Acts as a placeholder.
            }
        }
        .frame(width: 600, height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

