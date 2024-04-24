import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Sign In") {
                signIn()
            }
            .padding()
            
            NavigationLink(
                destination: ProfileView(name: name, email: email, isLoggedIn: $isLoggedIn),
                isActive: $isLoggedIn,
                label: {
                    EmptyView() // Placeholder for NavigationLink
                })
            .hidden()
        }
    }
    
    func signIn() {
        // Add your authentication logic here
        // For demo purposes, assume successful login
        isLoggedIn = true
    }
}

struct ProfileView: View {
    @State private var name: String
    @State private var email: String
    @State private var isEditing: Bool = false
    @Binding var isLoggedIn: Bool
    
    init(name: String, email: String, isLoggedIn: Binding<Bool>) {
        self._name = State(initialValue: name)
        self._email = State(initialValue: email)
        self._isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        VStack {
            if isEditing {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Save") {
                    // Add logic to save changes
                    isEditing.toggle()
                }
                .padding()
            } else {
                Text("Welcome, \(name)!")
                    .font(.title)
                    .padding()
                
                Text("Email: \(email)")
                    .padding()
                
                Spacer()
            }
            
            Button("Sign Out") {
                // Add logic to sign out
                isLoggedIn = false
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(8)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button("Edit") {
            isEditing.toggle()
        })
    }
}
