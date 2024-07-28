import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BingoViewModel()
    @State private var isEditingName = false

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.currentBoard.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(radius: 10)
                    )
                    .padding()

                BingoBoardView()
                    .environmentObject(viewModel)

                Spacer()
            }
            .background(Color.gray.opacity(0.1))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
