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
                        viewModel.switchBoard(to: board.id, editMode: false) // Default to play mode
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(board.name)
                    }
                    Spacer()
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        if let index = viewModel.bingoBoards.firstIndex(of: board) {
                            viewModel.deleteBoard(at: IndexSet(integer: index))
                        }
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
        .navigationTitle("Select Board")
    }
}
