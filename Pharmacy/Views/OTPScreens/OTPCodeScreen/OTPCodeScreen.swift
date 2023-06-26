//
//  OTPCodeScreen.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import SwiftUI

struct OTPCodeScreen: View {
    
    @StateObject var vm: OTPCodeScreenVM = OTPCodeScreenVM()
    @FocusState var activeFieldIdx: Int?
    @ObservedObject var oVM: OTPMobileNumberScreenVM
    var body: some View {
        VStack{
            Spacer()
            Image("OTPImage")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 230)
                .padding(.bottom)
            Text("OTP Verification")
                .font(.system(size: 24))
            Text(String.localizedStringWithFormat(NSLocalizedString("Enter the OTP sent to", comment: ""), oVM.mobileNumberText))                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
            
            HStack() {
                ForEach(0..<vm.otpLength, id: \.self) { index in
                    OTPInputField(text: $vm.fields[index], isFocused: activeFieldIdx == index)
                        .focused($activeFieldIdx, equals: index)
                        .onChange(of: vm.fields[index]) { newValue in
                            if newValue.count == 6 {
                                vm.fields =  newValue.map{String($0)}
                            }
                            if !newValue.isEmpty {
                                if newValue.count >= 1 {
                                    vm.fields[index] = String(newValue.first ?? " ")
                                    activeFieldIdx = index + 1
                                }
                            }
                            if !vm.checkState() {
                                activeFieldIdx = nil
                            }
                            if index > 0, !vm.fields[index - 1].isEmpty, vm.fields[index].isEmpty{
                                activeFieldIdx = index - 1
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            HStack {
                Text("Didn’t you receive the OTP?")
                    .foregroundColor(.gray)
                Button("Resend OTP") {
                    print("resent")
                }
            }
            
            Spacer()
            
            OTPButton(title: "Send OTP", action: {
                
                switch oVM.profileLoginStatus {
                case .alradyExistProfile :
                    vm.verifyAndSend(phone: oVM.mobileNumberText)
                case .newProfile :
                    vm.verifyAndSend(phone: oVM.mobileNumberText, name: oVM.name, lastName: oVM.lastName)
                case .none:
                    vm.alertBody = AppAlert(message: "Erorr")
                }
                
            })
            .disabled(vm.checkState())
            .opacity(vm.checkState() ? 0.5 : 1.0)
            Spacer()
        }
        .fullScreenCover(isPresented: $vm.showTabBar) {
            TabBarNavigationView()
        }
        .alert("error", isPresented: $vm.alertIsPresented, presenting: vm.alertBody) { _ in
            Button("ok", role: .cancel) {}
        } message: { bodyM in
            Text(bodyM.message)
        }
    }
}
    
    struct OTPInputField: View {
        @Binding var text: String
        var isFocused: Bool
        var body: some View {
            VStack(spacing: 8) {
                TextField("", text: $text)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .multilineTextAlignment(.center)
                
                Rectangle()
                    .fill(isFocused ? .blue : .gray)
                    .frame(height: 4)
            }
            .frame(height: 40)
        }
    }
    
    struct OTPCodeScreen_Previews: PreviewProvider {
        static var previews: some View {
            OTPCodeScreen(oVM: OTPMobileNumberScreenVM())
        }
    }

