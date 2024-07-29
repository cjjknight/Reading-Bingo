import SwiftUI

struct AddUserView: View {
    @ObservedObject var viewModel: BingoViewModel
    @State private var newUserName = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Enter new user name:")
                .font(.headline)
                .padding()

            TextField("New User Name", text: $newUserName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add User") {
                if !newUserName.isEmpty {
                    viewModel.addUser(userName: newUserName)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .navigationBarTitle("Add New User", displayMode: .inline)
    }
}
