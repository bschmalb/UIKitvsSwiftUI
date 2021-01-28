//
//  TippCard.swift
//  SwiftUITest
//
//  Created by Bastian Schmalbach on 22.11.20.
//

import SwiftUI

struct TippCard: View {
    @State var isChecked: Bool = false
    @State var isBookmarked: Bool = false
    @State var tipp: Tipp
    
    @State var poster: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @State var options: Bool = false
    
    var color: String
    
    var body: some View {
        ZStack {
            VStack (spacing: 0){
                HStack(alignment: .top) {
                    Spacer()
                    Button(action: {
                        impact(style: .medium)
                        options.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: Font.Weight.medium))
                            .opacity(0.1)
                            .padding(.top, 25)
                            .padding(.trailing, 25)
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    VStack (spacing: 0){
                        Spacer()
                        Text("Geposted von:")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        Text(poster.name ?? "...")
                            .multilineTextAlignment(.center)
                            .padding(5)
                        Text("\(poster.gender ?? "")  \(poster.age ?? "")")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        Spacer()
                        TippCardRateButton(icon: "hand.thumbsup", title: "Positiv bewerten", color: .black)
                        TippCardRateButton(icon: "hand.thumbsdown", title: "Negativ bewerten", color: .black)
                        TippCardRateButton(icon: "flag", title: "Diesen Tipp melden", color: .red)
                        Spacer()
                    }.foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width / 1.3)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 2.1)
            .background(Color.black.opacity(0.05))
            .background(Color(color))
            .cornerRadius(15)
            .animation(.spring())
            ZStack {
                VStack{
                    Spacer()
                    Image("I"+tipp.category)
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 40, idealHeight: 200, maxHeight: 300)
                    Text(tipp.title)
                        .font(.system(size: 24 - CGFloat(tipp.title.count / 25), weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    if (tipp.source.count > 3) {
                        HStack (spacing: 5){
                            Text("Quelle")
                                .foregroundColor(.gray)
                                .font(.system(size: 10, weight: .medium))
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: isChecked ? "checkmark" : "plus")
                            .font(.system(size: 24))
                            .foregroundColor(Color(isChecked ? .white : .black))
                            .rotationEffect(Angle(degrees: isChecked ? 0 : 180))
                            .animation(.spring())
                            .padding()
                            .onTapGesture(){
                                isChecked.toggle()
                                impact(style: .medium)
                            }
                        Spacer()
                        Spacer()
                        Image(systemName: "bookmark")
                            .font(.system(size: 24))
                            .foregroundColor(Color(isBookmarked ? .white : .black))
                            .animation(.spring())
                            .padding()
                            .onTapGesture(){
                                isBookmarked.toggle()
                                impact(style: .medium)
                            }
                        Spacer()
                    }
                    Spacer()
                        .frame(maxHeight: 10)
                    
                }
                VStack {
                    HStack(alignment: .top, spacing: 10) {
                        HStack (spacing: -5){
                            Image(tipp.category)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(.leading, 20)
                            Image(tipp.level)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Image(tipp.official)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }.opacity(0.1)
                        .padding(.top, 10)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24, weight: Font.Weight.medium))
                            .padding(25)
                            .padding(.trailing, 5)
                            .background(Color(color))
                            .opacity(0.1)
                            .onTapGesture(){
                                impact(style: .heavy)
                                getPoster()
                                options.toggle()
                            }
                    }.foregroundColor(.black)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 2.1)
            }
            .background(Color(color))
            .cornerRadius(15)
            .offset(x: options ? -UIScreen.main.bounds.width / 1.3 : 0)
        }
        .animation(.spring())
        .accentColor(.black)
        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
    }
    
    func getPoster() {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/users/" + tipp.postedBy) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        poster = user
                    }
                    return
                }
            }
        }
        .resume()
    }
}

struct TippCardRateButton: View {
    
    var icon: String
    var title: String
    var color: Color
    @State var clicked: Bool = false
    
    var body: some View {
        HStack (spacing: 20){
            Image(systemName: clicked ? icon + ".fill" : icon)
                .font(.system(size: 18, weight: Font.Weight.medium))
            Text(title)
                .font(.system(size: 16))
        }
        .foregroundColor(color)
        .padding(10)
        .animation(.spring())
        .onTapGesture(){
            impact(style: .medium)
            clicked.toggle()
        }
    }
}
