//
//  OTPCodeScreen.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import SwiftUI

struct OTPCodeScreen: View {
    @Binding var phoneNumber: String
    @StateObject var vm: OTPCodeScreenVM = OTPCodeScreenVM()
    @FocusState var activeFieldIdx: Int?
    
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
            Text(String.localizedStringWithFormat(NSLocalizedString("Enter the OTP sent to", comment: ""), phoneNumber))                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
            
            HStack() {
                ForEach(0..<vm.otpLength, id: \.self) { index in
                    OTPInputField(text: $vm.fields[index], isFocused: activeFieldIdx == index)
                        .focused($activeFieldIdx, equals: index)
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
                vm.verifyAndSend(phone: phoneNumber)
            })
            .disabled(vm.checkState())
            .opacity(vm.checkState() ? 0.5 : 1.0)
            Spacer()
        }
        .onChange(of: vm.fields) { newValue in
            checkOTPFields(fields: newValue)
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
    
    func checkOTPFields(fields: [String]) {
      
        for index in 0 ..< vm.otpLength - 1 {
            if fields[index].count == 1 && activeFieldIdx == index {
                activeFieldIdx = index + 1
            }
        }
       
        for index in 1 ..< vm.otpLength  {
            if fields[index].isEmpty && !fields[index - 1].isEmpty {
                activeFieldIdx = index - 1
            }
        }
        
        for index in 0 ..< vm.otpLength {
            if fields[index].count == 6 {
                
                for (elementIndex , element) in fields[index].enumerated() {
                    vm.fields[elementIndex] = String(element)
                }
            }
             else  if fields[index].count > 1 {
                    vm.fields[index] = String(fields[index].first!)
                }
            }
        
        if !vm.checkState() {
            activeFieldIdx = nil
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
            OTPCodeScreen(phoneNumber: .constant("+375 29 111 11 11"))
        }
    }

