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
        }
    }
}
