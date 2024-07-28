import SwiftUI

struct BoardSelectionView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List(viewModel.bingoBoards) { board in
            Button(action: {
                viewModel.switchBoard(to: board.id)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(board.name)
            }
        }
        .navigationTitle("Select Board")
    }
}
