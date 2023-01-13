//
//  NoteItemView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/12.
//

import SwiftUI
import CoreData


struct NoteItemView: View {
    let note: Note
    let onPress:()->Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if note.title != nil {
                Text(note.title!)
                    .fontWeight(.bold)
                    .font(.headline)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if note.content != nil {
                Text(note.content!)
                    .lineLimit(3)
                    .font(.subheadline)
            }
            
            Text(Date(milliseconds: note.date).customFormat)
                .padding(5)
                .font(.caption)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.5))
                }
                .padding([.bottom, .top], 10)
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .multilineTextAlignment(.leading)
        .background(Color[note.color ?? "accent"].opacity(0.6))
        .cornerRadius(12)
        //.padding(15)
        .onTapGesture {
           onPress()
        }
    }
}

struct NoteItemView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    static var previews: some View {
        let note = Note(context: context)
        note.id = UUID().uuidString
        note.title = "Team Meeting"
        note.content = ""
        note.color = "green"
        note.date = Date().millisecondsSince1970
        return NoteItemView(note: note, onPress: {})
    }
}
