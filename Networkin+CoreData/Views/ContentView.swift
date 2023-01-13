//
//  ContentView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import SwiftUI

enum SheetType: Identifiable {
    case add
    case update(Note)
    
    var id: Int {
        switch self {
        case .add:
            return 1
        case .update(_):
            return 2
        }
    }
}
struct ContentView: View {
    @EnvironmentObject private var model: NoteModel
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id,  order: SortOrder.reverse)]) var notes: FetchedResults<Note>
    @State private var showSheet = false
    @State private var activeSheet: SheetType?
   let columns = [GridItem(.adaptive(minimum: 150), spacing: 0)]
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                if(model.isLoading) {
                    ProgressView()
                        .frame(minHeight: geo.size.height)
                        .frame(width: geo.size.width, alignment: .center)
                } else {
                    if notes.isEmpty {
                        Text("No item added yet...")
                            .frame(minHeight: geo.size.height)
                            .frame(width: geo.size.width, alignment: .center)
                    }else{
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                                ForEach(notes) { note in
                                    NoteItemView(note: note) {
                                        activeSheet = .update(note)
                                    }
                                    .padding([.trailing, .leading], 10)
                                }
                            }
                        }
                    }
                }
            }
        }
            .navigationTitle("Notes")
            .task {
                do {
                    try await model.getAllNotes()
                }catch {
                    model.setMsgAndLoadStatus(
                        msg: "server encountered an error 🥲",
                        isLoading: false)
                    print("called:\(error.localizedDescription)")
                }
            }
            .toolbar {
                Button {
                    activeSheet = .add
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .add:
                    NavigationStack {
                        AddNoteView()
                    }
                case .update(let note):
                    NavigationStack {
                        AddNoteView(note: note)
                    }
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var localService = LocalService.shared
    static var previews: some View {
        NavigationStack {
            ContentView()
                .environment(\.managedObjectContext, localService.container.viewContext)
                .environmentObject(
                    NoteModel(
                        RemoteService(baseURL: URL(string: "http://localhost:8085")!), localService))
        }
    }
}

