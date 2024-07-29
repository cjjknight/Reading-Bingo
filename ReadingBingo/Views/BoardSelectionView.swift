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
            
            ForEach(viewModel.bingoBoards.filter { $0.owner == viewModel.currentUserName || $0.players.contains(viewModel.currentUserName) || viewModel.currentUserName == "Admin" }) { board in
                HStack {
                    Button(action: {
                        viewModel.switchBoard(to: board.id)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(board.name)
                    }
                    Spacer()
                    if board.owner == viewModel.currentUserName || viewModel.currentUserName == "Admin" {
                        Button(action: {
                            viewModel.switchBoard(to: board.id, editMode: true)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "pencil")
                        }
                    }
                }
                .swipeActions {
                    if board.owner == viewModel.currentUserName || viewModel.currentUserName == "Admin" {
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
        }
        .navigationTitle("Select Board")
    }
}
