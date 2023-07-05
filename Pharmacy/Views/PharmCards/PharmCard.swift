//
//  PharmCard.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 5.07.23.
//

import SwiftUI

struct PharmCard: View {
    var item : ResultSalePharm
    @State var isPresented = false
    @ObservedObject var vm: MainVM
    var id: String?
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack {
                AsyncImage(url: URL(string: item.logo)) { logo in
                        ZStack{
                            Rectangle()
                                .frame (maxWidth: 80,  maxHeight: 80)
                                .cornerRadius(9)
                                .foregroundColor(.white)
                                
                            logo
                                .resizable()
                                .scaledToFit()
                                .padding(8)
                                .frame (maxWidth: 80,  maxHeight: 80)
                                .cornerRadius(9)
                        
                        }
                    }
                    placeholder: {
                        Image(Constants.pharmPlaceholder)
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .frame (maxWidth: 80,  maxHeight: 80)
                    }
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .inset(by: 0.5)
                        .stroke(.green)
                    )
                      .padding(.leading, 8)
                      .padding(.vertical, 8)
                      
                VStack(alignment: .leading) {
                    Text(item.title.capitalized)
                        .font(.system(size: 18))
                        .bold()
                    HStack {
                        VStack {
                            if let oldPrice = item.oldPrice {
                                Group {
                                        Text(String(format: "%.2f", oldPrice)) + Text("r.")
                                      }
                                    
                                    .strikethrough()
                            }
                                Group {
                                        Text(String(format: "%.2f", item.price)) + Text("r.")
                                      
                                }
                                    .font(.system(size: 20))
                                    .bold()
                                  
                              }
                                Spacer()
                                Button {
                                    vm.addOrDeleteItemInCart(item: item)
                                } label: {
                             
                                    Image(systemName:  vm.checkInCart(item: item) ? "minus" : "plus")
                                      .foregroundColor(.green)
                                      .font(.system(size: 25))
                                      .frame(width: 40, height: 40)
                                      .background(.green.opacity(0.2))
                                      .mask(Circle())
                              }
   
                          }
                          
                      }
                      Spacer()
                
            }
        }

        .foregroundColor(Color(UIColor.label))
        .sheet(isPresented: $isPresented, content: {
            FullPharmCard(item: item, vm: vm)
        })
        .frame(maxWidth: .infinity)
        .frame(height:  110)
        .background(.thinMaterial)
        .cornerRadius(9)
        .padding(.horizontal)
       
    }
}



struct PharmCard_Previews: PreviewProvider {
    static var previews: some View {
        PharmCard(item: (ResultSalePharm(objectID: "", title: "АУГМЕНТИН ЕС", logo: "https://static5.asna.ru/imgprx/9EGtLnHETZb5k2wg_VvV0fPY_UKzJQ4ZXlV9ARw82DQ/rs:fit:800:800:1/g:no/aHR0cHM6Ly9pbWdzLmFzbmEucnUvaWJsb2NrLzAyMS8wMjExMDM5NGY4OWRiMjA1M2E4NmFkMGI4YjY1YTBlMi84NzEwNDc5LmpwZw.jpg", price: 5.45, oldPrice: 50, description: "ПОР. Д/ПРИГ. 100МЛ СУСП. Д/ПРИЕМА ВНУТРЬ 600МГ+42,9МГ/5МЛ ФЛ. №1 GLAXO WELLCOME PRODUCTION-ФРАНЦИЯ", createdAt: "", updatedAt: "")), vm: MainVM())
    
    }
}
