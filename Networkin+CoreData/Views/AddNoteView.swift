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
    var id: String = UUID().uuidString

    func isInValid() -> Bool {
        return title.isEmpty && content.isEmpty
    }
}
struct AddNoteView: View {
    @State private var uiNote: UINote = UINote()
    @EnvironmentObject private var model: NoteModel
    @Environment(\.dismiss) var dismiss
    
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
                Button {
                    Task {
                        do {
                           try await upsertNote()
                        } catch {
                            print("add error: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Image(systemName: "checkmark")
                }.disabled(uiNote.isInValid())

            }
        }.onAppear {
            if let note = note {
                uiNote.id = note.id ?? UUID().uuidString
                uiNote.content = note.content ?? ""
                uiNote.color = note.color ?? "green"
                uiNote.title = note.title ?? ""
            }
        }
    }
    
    func upsertNote() async throws{
        guard !uiNote.isInValid() else {
            return
        }
        uiNote.date = Date().millisecondsSince1970
        try await model.insertNote(note: uiNote)
        print(model.userInfoMsg)
        dismiss()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNoteView()
        }
    }
}
