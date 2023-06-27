//
//  OTPCodeScreen.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import SwiftUI

struct OTPCodeScreen: View {
    
   
    @FocusState var activeFieldIdx: Bool
    @ObservedObject var vm: OTPMobileNumberScreenVM
    var body: some View {
        VStack{
            Spacer()
            Image(Constants.otpImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 230)
                .padding(.bottom)
            Text("OTP Verification")
                .font(.system(size: 24))
            Text(String.localizedStringWithFormat(NSLocalizedString("Enter the OTP sent to", comment: ""), vm.mobileNumberText))                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
            ZStack {
                
                    
                HStack() {
                    ForEach($vm.fields, id: \.self) { field in
                        OTPInputField(text: field)
                    }
                }
                .onTapGesture {
                    activeFieldIdx.toggle()
                }
                .padding(.horizontal, 16)
                
                TextField("", text: $vm.otpText)
                    .focused($activeFieldIdx)
                    .opacity(0)
                    .foregroundColor(.white)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(maxWidth: .infinity)
                    .onChange(of: vm.otpText) { newValue in
                        vm.showOTP()
                    }
            }
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
        .frame(maxWidth: .infinity)
        .onAppear {
           
                activeFieldIdx = true
           
        }
        .onTapGesture {
            activeFieldIdx = false
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
        var body: some View {
            VStack(spacing: 8) {
                Text(text)
                Rectangle()
                    .fill(!text.isEmpty ? .blue : .gray)
                    .frame(height: 4)
            }
            .frame(height: 40)
        }
    }
    
    struct OTPCodeScreen_Previews: PreviewProvider {
        static var previews: some View {
            OTPCodeScreen(vm: OTPMobileNumberScreenVM())
          //  OTPInputField(text: .constant(""))
        }
    }

