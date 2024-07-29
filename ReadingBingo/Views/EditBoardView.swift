import SwiftUI

struct EditBoardView: View {
    @EnvironmentObject var viewModel: BingoViewModel

    var body: some View {
        VStack {
            Text("Edit Mode")
                .font(.largeTitle)
                .padding()

            // Add any additional editing controls here
            BingoBoardView()
                .environmentObject(viewModel)
        }
        .padding()
    }
}

struct EditBoardView_Previews: PreviewProvider {
    static var previews: some View {
        EditBoardView()
            .environmentObject(BingoViewModel())
    }
}
