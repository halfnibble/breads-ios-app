import SwiftUI

struct BreadEditView: View {
    @Environment(\.presentationMode) var presentationMode
    let bread: Bread
    @ObservedObject var viewModel: BreadsViewModel
    
    @State private var name: String
    @State private var hasGluten: Bool
    @State private var image: String
    @State private var baker: String
    
    
    init(bread: Bread, viewModel: BreadsViewModel) {
        self.bread = bread
        self.viewModel = viewModel
        _name = State(initialValue: bread.name)
        _hasGluten = State(initialValue: bread.hasGluten)
        _image = State(initialValue: bread.image)
        _baker = State(initialValue: bread.baker)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bread Information")) {
                    TextField("Name", text: $name)
                    Toggle("Has Gluten", isOn: $hasGluten)
                    TextField("Image URL", text: $image)
                    Picker("Baker", selection: $baker) {
                        ForEach(Bakers, id: \.self) { baker in
                            Text(baker).tag(baker)
                        }
                    }
                }
            }
            .navigationTitle("Edit Bread")
            .navigationBarItems(trailing: Button("Submit", action: submit))
        }
    }
    
    private func submit() {
        let updatedBread = Bread(id: bread.id, name: name, hasGluten: hasGluten, image: image, baker: baker)
        API.shared.updateBread(updatedBread) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.fetchBreads()
                }
            case .failure(let error):
                print("Error updating bread: \(error.localizedDescription)")
            }
        }
    }
}

struct BreadEditView_Previews: PreviewProvider {
    static var previews: some View {
        BreadEditView(bread: Bread(id: "1", name: "Rye", hasGluten: true, image: "https://images.unsplash.com/photo-1595535873420-a599195b3f4a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80", baker: "Chandler"), viewModel: BreadsViewModel())
    }
}
