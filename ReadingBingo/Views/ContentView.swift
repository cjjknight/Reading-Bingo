import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BingoViewModel()

    var body: some View {
        NavigationView {
            VStack {
                BingoBoardView()
                    .environmentObject(viewModel)
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.currentBoard.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
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
