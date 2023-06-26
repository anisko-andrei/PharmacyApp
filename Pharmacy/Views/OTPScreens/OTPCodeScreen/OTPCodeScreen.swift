//
//  OTPCodeScreen.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import SwiftUI

struct OTPCodeScreen: View {
    
   
    @FocusState var activeFieldIdx: Int?
    @ObservedObject var vm: OTPMobileNumberScreenVM
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
            Text(String.localizedStringWithFormat(NSLocalizedString("Enter the OTP sent to", comment: ""), vm.mobileNumberText))                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
            
            HStack() {

                ForEach(0..<vm.otpLength, id: \.self) { index in
                    OTPInputField(text: $vm.fields[index], isFocused: activeFieldIdx == index)
                        .focused($activeFieldIdx, equals: index)
                        .onChange(of: vm.fields[index]) { newValue in
                           activeFieldIdx = vm.checkOtp(index: index, newValue: newValue)
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
                vm.verifyAndSend()
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
            OTPCodeScreen(vm: OTPMobileNumberScreenVM())
        }
    }

