import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BingoViewModel()
    @State private var isEditingName = false
    @State private var showAddPlayerPrompt = false
    @State private var selectedSquare: SquareIdentifier?
    @State private var selectedUserIndex = 0

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
                        if viewModel.currentBoard.owner == viewModel.currentUserName || viewModel.currentUserName == "Admin" {
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
                    HStack {
                        Button(action: {
                            showAddPlayerPrompt.toggle()
                        }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .padding()
                        }
                        Picker("User", selection: $selectedUserIndex) {
                            Text("Create new user").tag(0)
                            ForEach(1..<viewModel.users.count + 1, id: \.self) { index in
                                Text(viewModel.users[index - 1]).tag(index)
                            }
                        }
                        .onChange(of: selectedUserIndex) { index in
                            if index == 0 {
                                viewModel.currentUserName = "User"
                            } else {
                                viewModel.currentUserName = viewModel.users[index - 1]
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
            }
            .sheet(isPresented: $showAddPlayerPrompt) {
                AddPlayerPrompt(viewModel: viewModel)
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
            return "\(viewModel.currentUserName), you haven't started yet."
        case 0.2:
            return "\(viewModel.currentUserName), you're 20% there. Keep going!"
        case 0.4:
            return "\(viewModel.currentUserName), you're 40% there. Keep up the good work!"
        case 0.6:
            return "\(viewModel.currentUserName), you're 60% there. Almost there!"
        case 0.8:
            return "\(viewModel.currentUserName), you're 80% there. Just a bit more!"
        default:
            return "\(viewModel.currentUserName), you're getting closer!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AddPlayerPrompt: View {
    @State private var selectedUserIndex = 0
    @Environment(\.presentationMode) var presentationMode
    var viewModel: BingoViewModel

    var body: some View {
        VStack {
            Text("Add a new player:")
                .font(.headline)
                .padding()

            Picker("Player", selection: $selectedUserIndex) {
                ForEach(0..<viewModel.users.count, id: \.self) { index in
                    Text(viewModel.users[index]).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Button("Add Player") {
                if selectedUserIndex < viewModel.users.count {
                    viewModel.addPlayerToCurrentBoard(playerName: viewModel.users[selectedUserIndex])
                }
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
}
