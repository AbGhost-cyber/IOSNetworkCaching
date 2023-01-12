//
//  NoteItemView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/12.
//

import SwiftUI

struct NoteItemView: View {
    let colors = ["green", "teal", "accent", "pink", "mint", "purple", "orange", "brown", "indigo", "cyan"]
    var index = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(index == 2 ? "Birthday Party Preparations": "Team Meeting")
                .fontWeight(.bold)
                .font(.title3)
                .lineLimit(2)
            Text(index == 2 ? "": "Planning sprint log for next product design update")
                .lineLimit(3)
            Text("5 Sept, 4:30")
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black)
                }
                .padding(.bottom, 10)
        }
       // .frame(maxWidth: .infinity)
        .padding(15)
        .background(Color[colors[index]].opacity(0.7))
        .cornerRadius(12)
        .padding()
    }
}

struct NoteItemView_Previews: PreviewProvider {
    static var previews: some View {
        NoteItemView()
    }
}
