//
//  ButtonLabel.swift
//  SwiftUITest
//
//  Created by Bastian Schmalbach on 02.02.21.
//

import SwiftUI

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
