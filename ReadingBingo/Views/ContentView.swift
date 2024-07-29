import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BingoViewModel()
    @State private var isEditingName = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isEditMode {
                    TextField("Board Name", text: Binding(
                        get: { viewModel.currentBoard.name },
                        set: { viewModel.renameCurrentBoard(newName: $0) }
                    ))
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
                } else {
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
                }

                BingoBoardView()
                    .environmentObject(viewModel)

                Spacer()

                // Status Area
                VStack {
                    if viewModel.isEditMode {
                        Text("Edit Mode")
                            .font(.headline)
                            .padding()
                    } else {
                        ProgressView(value: calculateProgress())
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .padding()
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.isEditMode.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .imageScale(.large)
                            .padding()
                    }
                }
            }
        }
    }

    private func calculateProgress() -> Double {
        let totalSquares = 25
        let markedSquares = viewModel.currentBoard.markers.flatMap { $0 }.filter { $0 }.count
        return Double(markedSquares) / Double(totalSquares)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
