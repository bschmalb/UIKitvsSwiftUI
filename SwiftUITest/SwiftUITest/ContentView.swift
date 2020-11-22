//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Bastian Schmalbach on 22.11.20.
//

import SwiftUI

func impact (style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

class Filter: Identifiable, ObservableObject {
    var id: UUID
    var icon: String
    var name: String
    @Published var isSelected: Bool
    
    init(id: UUID, icon: String, name: String, isSelected: Bool) {
        self.id = id
        self.icon = icon
        self.name = name
        self.isSelected = isSelected
    }
}


struct ContentView: View {
    
    @State var tipps: [Tipp] = []
    @State var user: User = User(_id: "", phoneId: "", name: "Bastian", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @State var filter = [
        Filter(id: UUID(), icon: "blackFruits", name: "Ernährung", isSelected: true),
        Filter(id: UUID(), icon: "blackTransport", name: "Transport", isSelected: true),
        Filter(id: UUID(), icon: "Haushalt", name: "Haushalt", isSelected: true),
        Filter(id: UUID(), icon: "blackRessourcen", name: "Ressourcen", isSelected: true),
        Filter(id: UUID(), icon: "blackStar", name: "Leicht", isSelected: true),
        Filter(id: UUID(), icon: "blackHalfStar", name: "Mittel", isSelected: true),
        Filter(id: UUID(), icon: "blackStarFilled", name: "Schwer", isSelected: true),
        Filter(id: UUID(), icon: "blackVerified", name: "Offiziell", isSelected: true),
        Filter(id: UUID(), icon: "blackCommunity", name: "Community", isSelected: true)
    ]
    
    var body: some View {
        VStack{
            HStack {
                Text("Tipps für Dich")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Spacer()
                Button(action: {
                    //self.showAddTipps.toggle()
                    impact(style: .medium)
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .padding(10)
                        .padding(.trailing, 15)
                }
            }
            .padding(.top, 60)
            
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack {
                    ForEach(self.filter.indices, id: \.self) { index in
                        FilterView(
                            isSelected: self.$filter[index].isSelected,
                            filter: self.filter[index])
                            .onTapGesture {
                                self.filter[index].isSelected.toggle()
                            }
                    }
                }
                .padding(.horizontal, 20)
            }.frame(height: 50)
            
            ScrollView (.horizontal, showsIndicators: false){
                LazyHStack {
                    ForEach(self.tipps.indices, id: \.self) { index in
                        HStack {
                            Spacer()
                            TippCard(user: user, isChecked: $tipps[index].isChecked, isBookmarked: $tipps[index].isChecked, tipp: tipps[index], color: "cardgreen2")
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width)
                    }
                }
            }.frame(height: UIScreen.main.bounds.height / 2.1 + 20)
            
            Spacer()
            
        }.accentColor(.black)
        .onAppear(){
            Api().fetchTipps { (tipps) in
                self.tipps = tipps
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
