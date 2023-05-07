import SwiftUI

struct CreateBreadView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BreadsViewModel
    
    @State private var name: String = ""
    @State private var baker: String = "Rachel"
    @State private var hasGluten: Bool = true
    @State private var image: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    Picker("Baker", selection: $baker) {
                        ForEach(Bakers, id: \.self) { baker in
                            Text(baker).tag(baker)
                        }
                    }
                    Toggle("Has Gluten", isOn: $hasGluten)
                    TextField("Image URL", text: $image)
                }
                
                Button(action: submit) {
                    Text("Submit")
                }
            }
            .navigationTitle("Create Bread")
        }
    }
    
    private func submit() {
        let newBread = Bread(id: UUID().uuidString, name: name, hasGluten: hasGluten, image: image, baker: baker)
        API.shared.createBread(newBread) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.fetchBreads()
                }
            case .failure(let error):
                print("Error creating bread: \(error.localizedDescription)")
            }
        }
    }
}

struct CreateBreadView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBreadView(viewModel: BreadsViewModel())
    }
}
