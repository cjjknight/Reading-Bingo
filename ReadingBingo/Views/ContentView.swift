import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BingoViewModel()
    @State private var isEditingName = false

    var body: some View {
        NavigationView {
            VStack {
                if isEditingName {
                    TextField("Board Name", text: Binding(
                        get: { viewModel.currentBoard.name },
                        set: { viewModel.renameCurrentBoard(newName: $0) }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                } else {
                    Text(viewModel.currentBoard.name)
                        .font(.headline)
                        .onTapGesture {
                            isEditingName = true
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }

                BingoBoardView()
                    .environmentObject(viewModel)

                Spacer()

                Toggle(isOn: $viewModel.isEditMode) {
                    Text(viewModel.isEditMode ? "Edit Mode" : "Play Mode")
                        .font(.headline)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: BoardSelectionView().environmentObject(viewModel)) {
                        Image(systemName: "square.grid.2x2.fill")
                            .imageScale(.large)
                            .padding()
                    }
                }
            }
        }
    }
}
