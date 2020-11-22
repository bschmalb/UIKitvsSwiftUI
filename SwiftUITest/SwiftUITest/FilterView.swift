//
//  FilterView.swift
//  SwiftUITest
//
//  Created by Bastian Schmalbach on 22.11.20.
//

import SwiftUI

struct FilterView: View {
    @Binding var isSelected: Bool
    var filter: Filter
    var screen = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            HStack {
                Image("\(filter.icon)")
                    .resizable()
                    .scaledToFit()
                    .font(.title)
                    .frame(width: screen < 400 ? screen * 0.05 : 25, height: screen < 400 ? screen * 0.05 : 25)
                    .opacity(isSelected ? 1 : 0.3)
                    .padding(5)
                Text(filter.name)
                    .font(.system(size: screen < 500 ? screen * 0.045 : 20))
                    .fontWeight(.medium)
                    .accentColor(Color("black"))
                    .fixedSize(horizontal: true, vertical: false)
                    .opacity(isSelected ? 1 : 0.3)
            }.padding(.horizontal, 10)
                .padding(.vertical, 6)
        }
        .background(Color(isSelected ? "buttonWhite" : "transparent"))
        .cornerRadius(15)
        .shadow(color: isSelected ?Color("black").opacity(0.1) : Color("transparent"), radius: 3, x: 2, y: 2)
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(isSelected: .constant(true), filter: Filter(id: UUID(), icon: "Ernährung", name: "Ernährung", isSelected: true))
    }
}
