import SwiftUI

struct AddPlayerPrompt: View {
    @ObservedObject var viewModel: BingoViewModel
    @State private var selectedUserIndex = 0

    var body: some View {
        VStack {
            Text("Add a new player:")
                .font(.headline)
                .padding()

            Picker("Player", selection: $selectedUserIndex) {
                ForEach(0..<viewModel.users.count, id: \.self) { index in
                    Text(viewModel.users[index]).tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Button("Add Player") {
                if selectedUserIndex < viewModel.users.count {
                    viewModel.addPlayerToCurrentBoard(playerName: viewModel.users[selectedUserIndex])
                }
            }
            .padding()
        }
        .navigationBarTitle("Add Player", displayMode: .inline)
    }
}
