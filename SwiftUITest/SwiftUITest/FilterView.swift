//
//  FilterView.swift
//  SwiftUITest
//
//  Created by Bastian Schmalbach on 22.11.20.
//

import SwiftUI
import Combine

struct FilterView: View {
    @Binding var isSelected: Bool
    var filter: Filter
    
    var body: some View {
        HStack {
            Image("\(filter.name)")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(filter.name)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .accentColor(.black)
                .fixedSize(horizontal: true, vertical: false)
        }
        .opacity(isSelected ? 1 : 0.3)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isSelected ? Color.white : .clear)
        .cornerRadius(15)
        .shadow(color: isSelected ? Color(.black).opacity(0.1) : Color(.clear), radius: 3, x: 2, y: 2)
    }
}

struct Filter {
    var name: String
    var isSelected: Bool
}
