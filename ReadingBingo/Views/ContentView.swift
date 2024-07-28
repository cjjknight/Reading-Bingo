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
            .navigationTitle("Reading Bingo")
            .navigationBarItems(leading: NavigationLink(destination: BoardSelectionView().environmentObject(viewModel)) {
                Image(systemName: "square.grid.2x2.fill")
                    .imageScale(.large)
                    .padding()
            })
        }
    }
}
