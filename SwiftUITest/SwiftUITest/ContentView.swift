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
    var name: String
    @Published var isSelected: Bool
    
    init(id: UUID, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}


struct ContentView: View {
    
    @State var objectLoaded: Bool = false
    
    var screen = UIScreen.main.bounds
    @State var offsetCapsule: CGFloat = 0
    @State var widthCapsule: CGFloat = 25
    @State var tabViewSelected = 0
    
    @State var tipps: [Tipp] = []
    @State var user: User = User(_id: "", phoneId: "", name: "Bastian", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @State var filterString = ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Leicht", "Mittel", "Schwer", "Offiziell", "Community"]
    
    @ObservedObject var filter = FilterData2()
    
    var cardColors: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
    ]
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea(.all)
            VStack (spacing: 0){
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
                        ForEach(filter.filter.indices, id: \.self) { index in
                            FilterView(
                                isSelected: $filter.filter[index].isSelected,
                                filter: filter.filter[index])
                                .onTapGesture {
                                    impact(style: .medium)
                                    filter.filter[index].isSelected.toggle()
                                    filterTipps2(index: index)
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }.frame(height: 55)
                .animation(.spring())
                
                ScrollView (.horizontal, showsIndicators: false){
                    LazyHStack {
                        ForEach(self.tipps.indices, id: \.self) { index in
                            if ([self.tipps[index].category, self.tipps[index].level, self.tipps[index].official].allSatisfy(self.filterString.contains)){
                                HStack {
                                    Spacer()
                                    TippCard(user: user, isChecked: $tipps[index].isChecked, isBookmarked: $tipps[index].isBookmarked, tipp: tipps[index], color: cardColors[index % cardColors.count])
                                    Spacer()
                                }.frame(width: UIScreen.main.bounds.width)
                            }
                        }
                    }
                }.frame(height: UIScreen.main.bounds.height / 2.1 + 20)
                .padding(.bottom, 12)
                
                
                VStack (spacing: 10) {
                    HStack {
                        Button(action: {
                        }) {
                            ButtonLabel(icon: "plus.circle", text: "Eigenen Tipp hinzufügen")
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width - 30, height: 45)
                        .background(Color(.white))
                        .cornerRadius(15)
                        .shadow(color: Color(.black).opacity(0.05), radius: 5, x: 4, y: 4)
                    }
                    HStack {
                        Button(action: {
                        }) {
                            ButtonLabel(icon: "hand.thumbsup", text: "Tipps von Nutzern bewerten")
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width - 30, height: 45)
                        .background(Color(.white))
                        .cornerRadius(15)
                        .shadow(color: Color(.black).opacity(0.05), radius: 5, x: 4, y: 4)
                    }
                }.offset(y: -UIScreen.main.bounds.height / 81)
                
                Spacer()
                
                VStack {
                    Spacer()
                    ZStack {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "lightbulb", setTab: 0)
                            Spacer()
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "doc.plaintext", setTab: 1)
                            Spacer()
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "book", setTab: 2)
                            Spacer()
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "person", setTab: 3)
                            Spacer()
                                .frame(width: screen.width / 13)
                        }
                        .accentColor(Color(.black))
                        .offset(y: -2)
                        Capsule()
                            .fill(Color(.black))
                            .frame(width: widthCapsule, height: 2)
                            .offset(x: offsetCapsule - (screen.width/2), y: 17)
                    }
                    .frame(width: screen.width - 30, height: 25 + screen.height / 26, alignment: .center)
                    .background(Color(.white))
                    .cornerRadius(20)
                    .shadow(color: Color(.black).opacity(0.2), radius: 5, x: 0, y: 4)
                }
                .padding(.bottom, screen.height / 40)
                .animation(.spring())

                
            }.accentColor(.black)
            .onAppear(){
                Api().fetchTipps { (tipps) in
                    self.tipps = tipps
                }
                if !objectLoaded {
                    filter.addItem(Filter(id: UUID(), name: "Ernährung", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Transport", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Haushalt", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Ressourcen", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Leicht", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Mittel", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Schwer", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Offiziell", isSelected: true))
                    filter.addItem(Filter(id: UUID(), name: "Community", isSelected: true))
                    objectLoaded = true
                }
            }
            .ignoresSafeArea(.all)
        }
    }
    
    func filterTipps2(index: Int){
        if (filterString.contains(filter.filter[index].name)){
            filterString.removeAll(where: {$0 == filter.filter[index].name})
            self.filter.filter[index].isSelected = false
        } else {
            filterString.append(filter.filter[index].name)
            self.filter.filter[index].isSelected = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ButtonLabel: View {
    
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.05 : 20, weight: Font.Weight.medium))
            Text(text)
                .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.045 : 20))
                .fontWeight(.medium)
        }
        .padding(13)
        .padding(.leading, 10)
    }
}

struct TabButton: View {
    
    @Binding var tabViewSelected: Int
    @Binding var offsetCapsule: CGFloat
    
    var icon: String
    var setTab: Int
    
    var body: some View {
        GeometryReader { g in
            Button(action: {
                self.tabViewSelected = setTab
                
                self.offsetCapsule = g.frame(in: .global).midX
                
                impact(style: .medium)
            }) {
                Image(systemName: icon)
                    .font(.system(size: 16 + UIScreen.main.bounds.height / 160, weight: Font.Weight.medium))
                    .opacity(self.tabViewSelected == setTab ? 1 : 0.5)
                    .frame(width: 40, height: 40)
            }
            .onAppear(){
                if setTab == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.offsetCapsule = g.frame(in: .global).midX
                    }
                }
            }
        }
        .frame(width: 40, height: 40)
    }
}
