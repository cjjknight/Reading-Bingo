import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BingoViewModel()
    @State private var isEditingName = false
    @State private var showUserNamePrompt = false
    @State private var userName = "User"
    @State private var selectedSquare: SquareIdentifier?

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
                        let progress = calculateProgress()
                        if progress == 1.0 {
                            Text("BINGO!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        } else {
                            Text(getProgressMessage(for: progress))
                                .font(.headline)
                                .padding()
                            ProgressView(value: progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .padding()
                        }
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
                ToolbarItem(placement: .principal) {
                    Text("Book Bingo")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationLink(destination: BoardSelectionView().environmentObject(viewModel)) {
                            Image(systemName: "square.grid.2x2.fill")
                                .imageScale(.large)
                                .padding()
                        }
                        if viewModel.currentBoard.owner == viewModel.currentUserName {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showUserNamePrompt.toggle()
                    }) {
                        Image(systemName: "person.circle")
                            .imageScale(.large)
                            .padding()
                    }
                }
            }
            .sheet(isPresented: $showUserNamePrompt) {
                UserNamePrompt(userName: $userName, viewModel: viewModel)
            }
        }
    }

    private func calculateProgress() -> Double {
        let board = viewModel.currentBoard.markers
        var closestLineProgress = 0.0

        // Check rows
        for row in 0..<5 {
            let rowProgress = Double(board[row].filter { $0 }.count) / 5.0
            closestLineProgress = max(closestLineProgress, rowProgress)
        }

        // Check columns
        for col in 0..<5 {
            let colProgress = Double((0..<5).filter { board[$0][col] }.count) / 5.0
            closestLineProgress = max(closestLineProgress, colProgress)
        }

        // Check diagonals
        let diag1Progress = Double((0..<5).filter { board[$0][$0] }.count) / 5.0
        closestLineProgress = max(closestLineProgress, diag1Progress)

        let diag2Progress = Double((0..<5).filter { board[$0][4 - $0] }.count) / 5.0
        closestLineProgress = max(closestLineProgress, diag2Progress)

        return closestLineProgress
    }

    private func getProgressMessage(for progress: Double) -> String {
        switch progress {
        case 0.0:
            return "\(userName), you haven't started yet."
        case 0.2:
            return "\(userName), you're 20% there. Keep going!"
        case 0.4:
            return "\(userName), you're 40% there. Keep up the good work!"
        case 0.6:
            return "\(userName), you're 60% there. Almost there!"
        case 0.8:
            return "\(userName), you're 80% there. Just a bit more!"
        default:
            return "\(userName), you're getting closer!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UserNamePrompt: View {
    @Binding var userName: String
    @Environment(\.presentationMode) var presentationMode
    var viewModel: BingoViewModel

    var body: some View {
        VStack {
            Text("Enter your name:")
                .font(.headline)
                .padding()

            TextField("Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                viewModel.currentUserName = userName
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
}
