import SwiftUI

struct BoardSelectionView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false
    @State private var boardToDelete: BingoBoard?

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
                        viewModel.switchBoard(to: board.id, editMode: false) // Default to play mode
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(board.name)
                    }
                    Spacer()
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        boardToDelete = board
                        showAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button {
                        viewModel.switchBoard(to: board.id, editMode: true) // Switch to edit mode
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete Board"),
                message: Text("Are you sure you want to delete this board?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let board = boardToDelete, let index = viewModel.bingoBoards.firstIndex(of: board) {
                        viewModel.deleteBoard(at: IndexSet(integer: index))
                    }
                    boardToDelete = nil
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("Select Board")
    }
}
