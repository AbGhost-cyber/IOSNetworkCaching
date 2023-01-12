//
//  ColorPickerView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/12.
//

import SwiftUI
extension Color {
    static subscript(name: String) -> Color {
        switch name {
        case "green":
            return Color.green
        case "teal":
            return Color.teal
        case "accent":
            return Color.accentColor
        case "pink":
            return Color.pink
        case "mint":
            return Color.mint
        case "purple":
            return Color.purple
        case "orange":
            return Color.orange
        case "brown":
            return Color.brown
        case "indigo":
            return Color.indigo
        case "cyan":
            return Color.cyan
        default:
            return Color.accentColor
        }
    }
}

struct ColorPickerView: View {
    let colors = ["green", "teal", "accent", "pink", "mint", "purple", "orange", "brown", "indigo", "cyan"]
    @Binding var selectedColor: String
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(colors, id: \.self) { color in
                    Button {
                        selectedColor = color
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color[color])
                            .frame(width: 50, height: 50)
                            .overlay {
                                if(selectedColor == color) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                    
                }
            }
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant("green"))
    }
}
