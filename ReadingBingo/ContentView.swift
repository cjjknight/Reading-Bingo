import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BingoViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Board", selection: Binding(
                    get: { viewModel.currentBoard.id },
                    set: { viewModel.switchBoard(to: $0) }
                )) {
                    ForEach(viewModel.bingoBoards) { board in
                        Text(board.name).tag(board.id)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                BingoBoardView()
                    .environmentObject(viewModel)

                Spacer()
            }
            .navigationTitle("Reading Bingo")
        }
    }
}
