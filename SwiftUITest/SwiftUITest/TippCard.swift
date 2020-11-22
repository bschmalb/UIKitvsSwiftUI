//
//  TippCard.swift
//  SwiftUITest
//
//  Created by Bastian Schmalbach on 22.11.20.
//

import SwiftUI

struct TippCard: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var user: User
    
    @Binding var isChecked: Bool
    @Binding var isBookmarked: Bool
    @State var isClicked: Bool = false
    @State var isClicked2: Bool = false
    @State var tipp: Tipp
    
    @State var user2: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @State var userLevelLocal = 0
    
    @State var quelleShowing = false
    @State var showSourceTextView = false
    
    @State var options: Bool = false
    
    @State var reportClicked: Bool = false
    @State var likeClicked: Bool = false
    @State var dislikeClicked: Bool = false
    
    @State var correctUrl: String = ""
    
    @State var showYouSure: Bool = false
    
    var color: String
    
    var body: some View {
        
        ZStack {
            if (options) {
                GeometryReader { size in
                    VStack (spacing: 0){
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                impact(style: .medium)
                                self.options.toggle()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: size.size.width < 500 ? size.size.width * 0.06 : 25, weight: Font.Weight.medium))
                                    .opacity(0.1)
                                    .padding(.top, 25)
                                    .padding(.trailing, 25)
                            }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            VStack (spacing: 0){
                                Group {
                                    Spacer()
                                    Text("Geposted von:")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                    if user2.name != nil {
                                        Text("\(user2.name ?? "User")")
                                            .multilineTextAlignment(.center)
                                            .padding(5)
                                        Text("\(user2.gender ?? "")  \(user2.age ?? "")")
                                            .font(.footnote)
                                            .multilineTextAlignment(.center)
                                            .opacity(user2.hideInfo ?? false ? 0 : 1)
                                    } else {
                                        VStack {
//                                            LottieView(filename: "loadingCircle", loop: true)
//                                                .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
//                                                .frame(width: 30, height: 30)
                                        }.padding(10)
                                    }
                                    Spacer()
                                }.foregroundColor(.black)
                                    Group {
                                        HStack (spacing: 15){
                                            Image(systemName: likeClicked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                .opacity(0.8)
                                            Text("Positiv bewerten")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                                .opacity(0.8)
                                        }
                                        .padding(10)
                                        .onTapGesture(){
                                            impact(style: .medium)
                                            if (self.likeClicked) {
                                                self.patchScore(thumb: "down")
                                            } else {
                                                if (self.reportClicked) {
                                                    self.reportClicked = false
                                                    self.patchScore(thumb: "unreport")
                                                }
                                                if (self.dislikeClicked) {
                                                    self.dislikeClicked = false
                                                    self.patchScore(thumb: "up")
                                                }
                                                self.patchScore(thumb: "up")
                                            }
                                            self.likeClicked.toggle()
                                        }
                                        .onTapGesture(){}
                                        .gesture(DragGesture()
                                                    .onChanged({ (value) in
                                                        self.options = false
                                                    }))
                                        Spacer()
                                            .frame(maxHeight: 5)
                                        HStack (spacing: 20){
                                            Image(systemName: dislikeClicked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                .opacity(0.8)
                                            Text("Negativ bewerten")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                                .opacity(0.8)
                                        }
                                        .padding(10)
                                        .onTapGesture(){
                                            impact(style: .medium)
                                            
                                            if (!self.dislikeClicked && self.likeClicked) {
                                                self.patchScore(thumb: "down")
                                                self.patchScore(thumb: "down")
                                            } else if (self.dislikeClicked) {
                                                self.patchScore(thumb: "up")
                                            } else {
                                                self.patchScore(thumb: "down")
                                            }
                                            self.likeClicked = false
                                            self.dislikeClicked.toggle()
                                        }
                                        Spacer()
                                            .frame(maxHeight: 5)
                                        HStack (spacing: 20){
                                            Image(systemName: reportClicked ? "flag.fill" : "flag")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                .foregroundColor(.red)
                                                .opacity(0.8)
                                            Text("Diesen Tipp melden")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                                .foregroundColor(.red)
                                                .opacity(0.8)
                                        }
                                        .padding(10)
                                        .animation(.spring())
                                        .onTapGesture(){
                                            impact(style: .medium)
                                            if (self.reportClicked) {
                                                self.patchScore(thumb: "unreport")
                                                self.patchScoreUser(reportedTipps: "unreport")
                                            } else {
                                                self.patchScore(thumb: "report")
                                                self.patchScoreUser(reportedTipps: "report")
                                                if (!self.dislikeClicked) {
                                                    self.dislikeClicked = true
                                                    self.patchScore(thumb: "down")
                                                }
                                                if (self.likeClicked) {
                                                    self.likeClicked = false
                                                    self.patchScore(thumb: "down")
                                                }
                                            }
                                            self.reportClicked.toggle()
                                        }
                                        Spacer()
                                    }.foregroundColor(.black)
//                                }
                            }
                            .frame(width: size.size.width / 1.3)
                            .gesture(DragGesture()
                                        .onChanged({ (value) in
                                            self.options = false
                                        }))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                            UIScreen.main.bounds.height / 2.1)
                    .background(Color.black.opacity(0.05))
                    .background(Color(color))
                    .cornerRadius(15)
                    .onTapGesture(){}
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    self.options = false
                                }))
                    .animation(.spring())
                }
            }
            GeometryReader { size in
                ZStack {
                    VStack{
                        Spacer()
                        Image("I"+tipp.category)
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 40, idealHeight: 200, maxHeight: 300)
                            .drawingGroup()
                        Text(tipp.title)
                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.07  - CGFloat(tipp.title.count / 25) : 26, weight: .medium))
                            .fixedSize(horizontal: false, vertical: showSourceTextView ? false : true)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        if (showSourceTextView){
//                            SourceTextView(source: tipp.source, show: $showSourceTextView, color: color)
                        } else {
                            if (tipp.source.count > 3) {
                                HStack (spacing: 5){
                                    Text("Quelle")
                                        .foregroundColor(.gray)
                                        .font(.system(size: size.size.width * 0.03, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 5)
                                }
                                .onTapGesture {
                                    impact(style: .medium)
                                    self.openSource()
                                    }
//                                    .sheet(isPresented: $quelleShowing) {
//                                        QuelleView(quelle: tipp.source, quelleShowing: self.$quelleShowing)
//                                            .environmentObject(ApiUrl())
//                                    }
                            }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: isChecked ? "checkmark" : "plus")
                                .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isChecked ? .medium : .regular))
                                .foregroundColor(Color(isChecked ? .white : .black))
                                .rotationEffect(Angle(degrees: isChecked ? 0 : 180))
                                .scaleEffect(isClicked ? 2 : 1)
                                .animation(.spring())
                                .padding()
                                .onTapGesture(){
                                    self.isChecked.toggle()
                                    self.addToProfile(tippId: self.tipp._id, method: 0)
                                    self.patchScore(thumb: "up")
                                    self.isClicked = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.isClicked = false
                                    }
                                    impact(style: .medium)
                                }
                            Spacer()
                            Spacer()
                            Image(systemName: "bookmark")
                                .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isBookmarked ? .medium : .regular))
                                .foregroundColor(Color(isBookmarked ? .white : .black))
                                .scaleEffect(isClicked2 ? 2 : 1)
                                .animation(.spring())
                                .padding()
                                .onTapGesture(){
                                    self.isBookmarked.toggle()
                                    self.addToProfile(tippId: self.tipp._id, method: 1)
                                    
                                    self.isClicked2 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.isClicked2 = false
                                    }
                                    impact(style: .medium)
                                }
                            Spacer()
                        }
                        Spacer()
                            .frame(maxHeight: 10)
                        
                    }
                    VStack {
                        HStack(alignment: .top, spacing: 10) {
                            HStack {
                                Image(tipp.category)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size.size.width < 500 ? size.size.width * 0.097 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                                    .opacity(0.1)
                                    .padding(.leading, 20)
                                    .padding(.vertical)
                                Image(tipp.level)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size.size.width < 500 ? size.size.width * 0.07 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                                    .opacity(0.1)
                                    .padding(.vertical)
                                Image(tipp.official)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size.size.width < 500 ? size.size.width * 0.07 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                                    .opacity(0.1)
                                    .padding(.vertical)
                            }
                            Spacer()
                            Image(systemName: "ellipsis")
                                .font(.system(size: size.size.width < 400 ? size.size.width * 0.07 : 25, weight: Font.Weight.medium))
                                .padding(25)
                                .padding(.trailing, 5)
                                .background(Color(color))
                                .opacity(0.1)
                                .onTapGesture(){
                                    impact(style: .heavy)
                                    self.options.toggle()
                                    self.getPoster()
                                }
                        }.foregroundColor(.black)
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                            UIScreen.main.bounds.height / 2.1)
                }
                .background(Color(color))
                .cornerRadius(15)
                .offset(x: options ? -size.size.width / 1.3 : 0)
            }
            .onTapGesture(){
                options = false
            }
            .gesture(DragGesture()
                        .onChanged({ (value) in
                            if options {
                                self.options = false
                            }
                        }))
        }
        .animation(.spring())
        .accentColor(.black)
        .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
        .onAppear(){
            self.getUserTipps()
        }
    }
    func getUserTipps(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (user.checkedTipps.contains(self.tipp._id) ) {
                self.isChecked = true
            }
            if (user.savedTipps.contains(self.tipp._id) ) {
                self.isBookmarked = true
            }
        }
    }
    
    func patchScore(thumb: String) {
        
        let rating = Rate(thumb: thumb)
        
        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/tipps/" + tipp._id) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func patchScoreUser(reportedTipps: String) {
        
        let rating = ReportedTipps(reportedTipps: reportedTipps)
        
        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/users/" + tipp.postedBy) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func getPoster() {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/users/" + tipp.postedBy) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        self.user2 = user
                    }
                    return
                }
            }
        }
        .resume()
    }
    
    func isURL() -> Bool {
        if let myUrl = URL(string: tipp.source) {
            if (UIApplication.shared.canOpenURL(myUrl)) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func openSource () {
        if isURL() {
            self.quelleShowing = true
        } else {
            self.showSourceTextView = true
        }
    }
    
    func addToProfile(tippId: String, method: Int) {
        let patchData = TippPatchCheck(checkedTipps: tippId)
        let patchData2 = TippPatchSave(savedTipps: tippId)
        
        var encoded: Data?
        if (method == 0) {
            encoded = try? JSONEncoder().encode(patchData)
        } else {
            encoded = try? JSONEncoder().encode(patchData2)
        }
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/users/" + (id ?? "")) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func deleteTipp(){
        
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/tipps/" + (tipp._id)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    self.changeFilter.changeFilter = false
//                }
//            }.resume()
//        }
    }
}

struct Rate : Encodable, Decodable{
    var thumb: String
}

struct ReportedTipps: Encodable, Decodable {
    var reportedTipps: String
}

struct TippPatchSave: Encodable {
    var savedTipps: String
}

struct TippPatchCheck: Encodable {
    var checkedTipps: String
}

struct TippCard_Previews: PreviewProvider {
    static var previews: some View {
        TippCard(user: User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: []), isChecked: .constant(false), isBookmarked: .constant(false), tipp: Tipp(_id: "", title: "Hallo", source: "", level: "", category: "", score: 12, postedBy: "", official: ""), color: "cardgreen2")
    }
}
    
