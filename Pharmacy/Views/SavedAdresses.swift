//
//  SavedAdresses.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 28.06.23.
//

import SwiftUI
import Alamofire
struct SavedAddresses: View {
    @StateObject var vm: SavedAddressesVM = SavedAddressesVM()
    @State var isEditing: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                if vm.addresses.results.isEmpty {
                    VStack {
                        Image(systemName: "location.slash")
                            .font(.system(size: 30))
                            .foregroundColor(.green)
                        Text("You don't save any address")
                    }
                }
                else {
                    List {
                        ForEach($vm.addresses.results, id: \.objectID) { address in
                            Text(address.address.wrappedValue ?? "")
                        }
                        .onDelete { index in
                            
                            vm.delete(at: index)
                        }
                        
                    }
                    .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
                }
                if vm.newAddressAdd {
                    ZStack{
                        BlurView(style: .systemChromeMaterialDark)
                            .ignoresSafeArea()
                        
                        VStack {
                            Text("Enter your new address")
                                .font(.system(size: 24))
                            HStack {
                                Image(systemName: "location")
                                    .padding(16)
                                TextField("Enter address", text: $vm.newAddress)
                                // .padding(.vertical,16)
                            }
                            .background(.background)
                            .cornerRadius(12)
                            .padding(8)
                            
                            
                            
                            
                            
                            HStack {
                                OTPButton(title: "Save") {
                                    vm.addNew(newAddress: vm.newAddress)
                                }
                                .padding(.horizontal, -8)
                                OTPButton(title: "Cancel") {
                                    vm.newAddressAdd.toggle()
                                    
                                }
                                .padding(.horizontal, -8)
                            }
                        }
                        .padding(16)
                        .background()
                        .cornerRadius(12)
                        .padding(16)
                    }
                }
            }
        }
        .task  {
           vm.loadAdres()
        }
        .navigationTitle("Saved addresses")
        .navigationBarBackButtonHidden(true)
        .toolbar(content: { if !vm.addresses.results.isEmpty {
            Button {
                isEditing.toggle()
            } label: {
                Image(systemName: isEditing ? "trash.fill" : "trash")
                    .foregroundColor(.green)
                
            } }

            Button {
                vm.newAddressAdd.toggle()
        } label: {
                Image(systemName: "plus")
                    .foregroundColor(.green)
                
        }
            
        })
        
        .navigationBarItems(
                        leading: NavigationCustomBackButton())

    }
}

struct NavigationCustomBackButton : View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.green)
                
                Text("Back")
                    .foregroundColor(.green)
            }
        }
    }
}


struct SavedAddresses_Previews: PreviewProvider {
    static var previews: some View {
        SavedAddresses()
    }
}


class SavedAddressesVM : ObservableObject {
    @Published var addresses: Addresses = Addresses(results: [])
    @Published var newAddress: String = ""
    @Published var newAddressAdd: Bool = false
    func delete(at offsets: IndexSet) {

        Task {
            do {
                let _ = try await deleteAddressAtServer(addressId: addresses.results[offsets.first ?? 0].objectID)
                await MainActor.run(body: {
                    addresses.results.remove(atOffsets: offsets)
                })
            }
            catch {
                print("ne ydalilos'")
            }
        }
       
        }
    func deleteAddressAtServer (addressId: String) async throws -> String? {
         return try await AF.request("https://parseapi.back4app.com/classes/MyAddresses/\(addressId)",
                             method: .delete,
                         headers: ["X-Parse-Application-Id" : "jdvDvQao8tePsPKJuw3VVeU6xjZkIKzzvK1ry46N",
                                   "X-Parse-REST-API-Key" : "BQ7HWLuwvUfyiD2SoqPTaHoEsCPeXptaOyOreAvw"]).serializingString().value
    }
    
  
    
    func getSaved() async throws -> Addresses {
        return try await AF.request("https://parseapi.back4app.com/classes/MyAddresses",
                                        method: .get,
                                    headers: ["X-Parse-Application-Id" : "jdvDvQao8tePsPKJuw3VVeU6xjZkIKzzvK1ry46N",
                                        "X-Parse-REST-API-Key" : "BQ7HWLuwvUfyiD2SoqPTaHoEsCPeXptaOyOreAvw"])
                                .serializingDecodable(Addresses.self).value
        
    }
    
    func addAddress(newAddress: String) async throws  {
       let _ = try await AF.request("https://parseapi.back4app.com/classes/MyAddresses",
                             method: .post,
                             parameters: ["address":newAddress],
                             encoding: JSONEncoding.default,
                             headers: ["X-Parse-Application-Id" : "jdvDvQao8tePsPKJuw3VVeU6xjZkIKzzvK1ry46N",
                                       "X-Parse-REST-API-Key" : "BQ7HWLuwvUfyiD2SoqPTaHoEsCPeXptaOyOreAvw"]).serializingDecodable(Result.self).value
    }
    
    func addNew(newAddress: String) {
        Task {
            do {
                try await addAddress(newAddress: newAddress)
                let newV = try await getSaved()
                await MainActor.run(body: {
                    addresses = newV
                    newAddressAdd.toggle()
                })
            }
            catch{
                print("eerrr")
            }
        }
    }
    func loadAdres() {
        Task {
            do{
                let result = try await getSaved()
                await MainActor.run(body: {
                    addresses = result
                })
                print(addresses)
            }
            catch {
                print("eror")
            }
        }
    }
}


struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }

}
