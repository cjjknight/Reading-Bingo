import SwiftUI

struct UserSelectionView: View {
    @ObservedObject var viewModel: BingoViewModel
    @State private var selectedUserIndex = 0

    var body: some View {
        VStack {
            Picker("Select User", selection: $selectedUserIndex) {
                ForEach(0..<viewModel.users.count, id: \.self) { index in
                    Text(viewModel.users[index]).tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Button("Select User") {
                if selectedUserIndex < viewModel.users.count {
                    viewModel.currentUserName = viewModel.users[selectedUserIndex]
                }
            }
            .padding()

            NavigationLink(destination: AddUserView(viewModel: viewModel)) {
                Text("Create New User")
            }
            .padding()
        }
        .navigationBarTitle("Select User", displayMode: .inline)
    }
}
