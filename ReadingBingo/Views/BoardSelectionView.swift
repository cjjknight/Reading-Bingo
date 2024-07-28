import SwiftUI

struct BoardSelectionView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            Button(action: {
                viewModel.createNewBoard()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create New Board")
            }
            
            ForEach(viewModel.bingoBoards) { board in
                HStack {
                    Button(action: {
                        viewModel.switchBoard(to: board.id)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(board.name)
                    }
                    Spacer()
                    Button(action: {
                        viewModel.switchBoard(to: board.id)
                        viewModel.isEditMode = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "pencil")
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        if let index = viewModel.bingoBoards.firstIndex(of: board) {
                            viewModel.deleteBoard(at: IndexSet(integer: index))
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("Select Board")
    }
}
