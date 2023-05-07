import SwiftUI

struct BreadListView: View {
    @StateObject private var viewModel = BreadsViewModel()
    @State private var showCreateBreadView = false

    var body: some View {
        NavigationView {
            List(viewModel.breads) { bread in
                NavigationLink(destination: BreadDetailView(bread: bread, viewModel: viewModel)) {
                    HStack {
                        URLImage(url: bread.image)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading) {
                            Text(bread.name)
                                .font(.headline)
                            Text("Baker: \(bread.baker)")
                                .font(.subheadline)
                            Text("Contains Gluten: \(bread.hasGluten ? "Yes" : "No")")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Breads")
            .navigationBarItems(trailing: Button(action: {
                self.showCreateBreadView.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showCreateBreadView) {
                CreateBreadView(viewModel: viewModel)
            }
            .onAppear(perform: viewModel.fetchBreads)
        }
        
    }
}

struct BreadListView_Previews: PreviewProvider {
    static var previews: some View {
        BreadListView()
    }
}
