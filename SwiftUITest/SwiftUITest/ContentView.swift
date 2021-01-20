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

struct Filter {
    var name: String
    var isSelected: Bool
}


struct ContentView: View {
    
    var screen = UIScreen.main.bounds
    @State var offsetCapsule: CGFloat = 0
    @State var widthCapsule: CGFloat = 25
    @State var tabViewSelected = 0
    
    @State var tipps: [Tipp] = [Tipp]()
    
    @State var reloadScrollView: Bool = false
    
    @State var filterString = ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Leicht", "Mittel", "Schwer", "Offiziell", "Community"]
    
    @State var filter: [Filter] = [
        Filter(name: "Ernährung", isSelected: true),
        Filter(name: "Transport", isSelected: true),
        Filter(name: "Haushalt", isSelected: true),
        Filter(name: "Ressourcen", isSelected: true),
        Filter(name: "Leicht", isSelected: true),
        Filter(name: "Mittel", isSelected: true),
        Filter(name: "Schwer", isSelected: true),
        Filter(name: "Offiziell", isSelected: true),
        Filter(name: "Community", isSelected: true),
    ]
    
    var cardColors: [String]  = [
        "cardgreen", "cardblue", "cardyellow", "cardpurple", "cardorange", "cardred", "cardturqouise", "cardyelgre", "cardpink"
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
                    Button(action: {}) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .padding(10)
                            .padding(.trailing, 15)
                    }
                }
                .padding(.top, 60)
                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack {
                        Text("Filter:")
                            .font(.system(size: 18, weight: Font.Weight.medium))
                            .padding(.trailing, 10)
                        ForEach(filter.indices, id: \.self) { index in
                            FilterView(
                                isSelected: $filter[index].isSelected,
                                filter: filter[index])
                                .onTapGesture {
                                    impact(style: .medium)
                                    filter[index].isSelected ?
                                        filterString.removeAll(where: { $0 == filter[index].name }) : filterString.append(filter[index].name)
                                    Api().fetchFiltered(filter: filterString) { tipps in
                                        self.tipps = tipps
                                        reloadScrollView = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            reloadScrollView = false
                                        }
                                    }
                                    filter[index].isSelected.toggle()
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }.frame(height: 55)
                .animation(.spring())
                
                if !reloadScrollView {
                    ScrollView (.horizontal, showsIndicators: false){
                        LazyHStack {
                            ForEach(self.tipps.indices, id: \.self) { index in
                                if tipps.count > 0 {
                                    HStack (alignment: .center){
                                        TippCard(tipp: tipps[index], color: cardColors[index % cardColors.count])
                                    }.frame(width: UIScreen.main.bounds.width)
                                }
                            }
                        }
                    }.frame(height: UIScreen.main.bounds.height / 2.1 + 20)
                    .padding(.bottom, 12)
                } else {
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height / 2.1 + 32)
                }
                
                VStack (spacing: 10) {
                    ButtonLabel(icon: "plus.circle", text: "Eigenen Tipp hinzufügen")
                    ButtonLabel(icon: "hand.thumbsup", text: "Tipps von Nutzern bewerten")
                }.offset(y: -10)
                
                Spacer()
                
                VStack {
                    Spacer()
                    ZStack {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "lightbulb", tabItem: 0)
                            Spacer()
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "doc.plaintext", tabItem: 1)
                            Spacer()
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "book", tabItem: 2)
                            Spacer()
                            TabButton(tabViewSelected: $tabViewSelected, offsetCapsule: $offsetCapsule, icon: "person", tabItem: 3)
                            Spacer()
                                .frame(width: 20)
                        }
                        .accentColor(Color(.black))
                        .offset(y: -2)
                        Capsule()
                            .fill(Color(.black))
                            .frame(width: widthCapsule, height: 2)
                            .offset(x: offsetCapsule - (screen.width/2), y: 17)
                    }
                    .frame(width: screen.width - 30, height: 55, alignment: .center)
                    .background(Color(.white))
                    .cornerRadius(20)
                    .shadow(color: Color(.black).opacity(0.2), radius: 5, x: 0, y: 4)
                }
                .padding(.bottom, 20)
                .animation(.spring())

                
            }.accentColor(.black)
            .onAppear(){
                Api().fetchFiltered(filter: filterString) { (tipps) in
                    self.tipps = tipps
                }
            }
            .ignoresSafeArea(.all)
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
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: Font.Weight.medium))
                Text(text)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .padding(13)
            .padding(.leading, 10)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 45)
        .background(Color(.white))
        .cornerRadius(15)
        .shadow(color: Color(.black).opacity(0.05), radius: 5, x: 4, y: 4)
    }
}

struct TabButton: View {
    
    @Binding var tabViewSelected: Int
    @Binding var offsetCapsule: CGFloat
    var icon: String
    var tabItem: Int
    
    var body: some View {
        GeometryReader { g in
            Button(action: {
                offsetCapsule = g.frame(in: .global).midX
                impact(style: .medium)
                tabViewSelected = tabItem
            }) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(tabViewSelected == tabItem ? .black : .gray)
                    .frame(width: 40, height: 40)
            }
            .onAppear(){
                if tabItem == 0 {
                    self.offsetCapsule = g.frame(in: .global).midX
                }
            }
        }
        .frame(width: 40, height: 40)
    }
}
