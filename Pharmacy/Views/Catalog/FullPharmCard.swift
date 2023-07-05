//
//  FullPharmCard.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import SwiftUI
import RealmSwift

struct FullPharmCard: View {
    var item : ResultSalePharm
    @ObservedObject var vm : MainVM
        // @ObservedResults(CartItem.self) var realmDB
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.logo)) { logo in
                logo
                    .resizable()
                    .scaledToFit()
                    .frame (maxWidth: 200,  maxHeight: 200)
                    .cornerRadius(9)
            } placeholder: {
                Image(Constants.pharmPlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame (maxWidth: 200,  maxHeight: 200)
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
            
            Text(item.title)
                .font(.system(size: 26))
                .multilineTextAlignment(.center)
            
            Text(item.description)
                .padding()
            Spacer()
            HStack {
                HStack {
                    VStack {
                        if let oldPrice = item.oldPrice {
                            Text(String(format: "%.2f", oldPrice))
                                .strikethrough()
                        }
                        Text(String(format: "%.2f", item.price))
                            .font(.system(size: 25))
                            .foregroundColor(.red)
                    }
                    .padding()
                    Spacer()
                    
                    Button {
                        vm.addOrDeleteItemInCart(item: item)
                    } label: {
                        Image(systemName: vm.checkInCart(item: item)  ? "minus" : "plus")
                            .padding(8)
                            .foregroundColor(.green)
                            .background(.thinMaterial)
                            .font(.system(size: 25))
                            .mask(Circle())
                    }
                    .padding(.trailing, 8)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height:  110)
            .background(.thinMaterial)
            .cornerRadius(9)
            .padding(.horizontal)
        }
       
    }
    
}

struct FullPharmCard_Previews: PreviewProvider {
    static var previews: some View {
        FullPharmCard(item: (ResultSalePharm(objectID: "", title: "АУГМЕНТИН ЕС", logo: "https://static5.asna.ru/imgprx/9EGtLnHETZb5k2wg_VvV0fPY_UKzJQ4ZXlV9ARw82DQ/rs:fit:800:800:1/g:no/aHR0cHM6Ly9pbWdzLmFzbmEucnUvaWJsb2NrLzAyMS8wMjExMDM5NGY4OWRiMjA1M2E4NmFkMGI4YjY1YTBlMi84NzEwNDc5LmpwZw.jpg", price: 5.45, oldPrice: nil, description: "ПОР. Д/ПРИГ. 100МЛ СУСП. Д/ПРИЕМА ВНУТРЬ 600МГ+42,9МГ/5МЛ ФЛ. №1 GLAXO WELLCOME PRODUCTION-ФРАНЦИЯ", createdAt: "", updatedAt: "")), vm: MainVM())
    }
}
