//
//  OTPMobileNumberScreen.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import SwiftUI
import iPhoneNumberField

struct OTPMobileNumberScreen: View {
    @StateObject var vm: OTPMobileNumberScreenVM = OTPMobileNumberScreenVM()
    @FocusState var isFocused : Bool
    var body: some View {
        ZStack {
            switch vm.appStateM {
            case .loading :
              
                    
                    ProgressView()
                
            default :
                
                
                VStack(alignment: .center){
                    Spacer()
                    Image(Constants.otpImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 230)
                        .padding(.bottom)
                    Text("OTP Verification")
                        .font(.system(size: 24))
                    Text("We will send you one-time password to you mobile number")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 8)
                    
                    
                    Text("Enter Mobile number")
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                    iPhoneNumberField("+375-29-111-11-11", text: $vm.mobileNumberText)
                        .prefixHidden(false)
                        .defaultRegion("BY")
                        .maximumDigits(9)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .focused($isFocused)
                        .padding(.horizontal,100)
                        .font(.system(size: 20))
                        .submitLabel(.done)
                        .keyboardType(.numberPad)
                      
                    Rectangle()
                        .frame(maxHeight: 1)
                        .padding(.horizontal, 90)
                        .foregroundColor(.green)
                    Spacer()
                    
                    OTPButton(title: "Get OTP") {
                        isFocused = false
                        print("send OTP to \(vm.mobileNumberText)")
                        vm.getOTPCode()
                    }
                    Spacer()
                        .alert(vm.alertBody.title, isPresented: $vm.alertIsPresented, presenting: vm.alertBody) { _ in
                            Button("ok", role: .cancel) {}
                        } message: { bodyM in
                            Text(bodyM.message)
                        }
                    
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    isFocused = false
                }
            
                .sheet(item: $vm.sheetToShow) { item in
                    switch item {
                    case .otpCodeScreen:
                        OTPCodeScreen(vm: vm)
                    case .registration:
                        RegistrationView(vm: vm)
                        
                    }
                }
            }
        }
        .onAppear{
            isFocused = true
        }
    }
}

struct OTPButton: View {
    var title: LocalizedStringKey
    var action: ()->Void
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color.green)
                .cornerRadius(14)
                .padding(.horizontal, 16)
                
        }
    }
}


struct OTPMobileNumberScreen_Previews: PreviewProvider {
    static var previews: some View {
        OTPMobileNumberScreen()
    }
}
