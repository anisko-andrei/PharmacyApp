//
//  SavedAdresses.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 28.06.23.
//

import SwiftUI
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
                                    vm.cancelButtonTaped()
                                    
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
