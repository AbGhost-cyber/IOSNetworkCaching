//
//  AddNoteView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/12.
//

import SwiftUI
import CoreData
//this is to make things cleaner without having to call context.save from here
struct UINote {
    var title: String = ""
    var content: String = ""
    var date: Int64 = 0
    var color: String = "green"
    var id: String = ""
    
    func toDto() -> NoteDTO {
        return NoteDTO(
            title: self.title,
            content: self.content,
            date: self.date,
            color: self.color,
            id: self.id
        )
    }
    func isInValid() -> Bool {
        return title.isEmpty
    }
}
struct AddNoteView: View {
    @State private var uiNote: UINote = UINote()
    let note: Note?
    
    init(note: Note? = nil) {
        self.note = note
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $uiNote.title)
                        .font(.title3)
                } header: {
                    Text("Title")
                }
                Section {
                    TextEditor(text: $uiNote.content)
                        .frame(minHeight: 100)
                } header: {
                    Text("content")
                }
                Section {
                    ColorPickerView(selectedColor: $uiNote.color)
                } header: {
                    Text("Background")
                }
            }
        }
        .navigationTitle(note == nil ? "Create Note" : "Update Note")
        .toolbar {
            ToolbarItem {
                Button {} label: {
                    Image(systemName: "checkmark")
                }.disabled(uiNote.isInValid())

            }
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNoteView()
        }
    }
}
