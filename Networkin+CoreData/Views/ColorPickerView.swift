//
//  ColorPickerView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/12.
//

import SwiftUI

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
                        RoundedRectangle(cornerRadius: 6)
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
