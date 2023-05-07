import SwiftUI

struct BreadDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let bread: Bread
    @ObservedObject var viewModel: BreadsViewModel

    @State private var showEditView = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    URLImage(url: bread.image)
                        .frame(height: 200)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                    
                    Text("Baker: \(bread.baker)")
                        .font(.title2)
                        .padding(.top)
                    
                    Text("Contains Gluten: \(bread.hasGluten ? "Yes" : "No")")
                        .font(.title2)
                }
                .padding()
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    showEditView = true
                }) {
                    Text("Edit")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showEditView) {
                    BreadEditView(bread: bread, viewModel: viewModel)
                }
                
                Button(action: {
                    API.shared.deleteBread(bread) { result in
                        switch result {
                        case .success:
                            print("Bread deleted successfully")
                            presentationMode.wrappedValue.dismiss()
                            viewModel.fetchBreads()
                        case .failure(let error):
                            print("Error deleting bread: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(bread.name)
    }
}

struct BreadDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BreadDetailView(bread: Bread(id: "1", name: "Rye", hasGluten: true, image: "https://images.unsplash.com/photo-1595535873420-a599195b3f4a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80", baker: "Chandler"), viewModel: BreadsViewModel())
    }
}
