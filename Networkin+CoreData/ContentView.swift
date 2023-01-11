//
//  ContentView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: NoteModel
    @FetchRequest(sortDescriptors: []) var notes: FetchedResults<Note>
    
    var body: some View {
        NavigationStack {
            VStack {
                if(model.isLoading) {
                    ProgressView()
                }else {
                    List(notes) { note in
                        VStack(alignment: .leading) {
                            Text(note.title ?? "Unknown")
                            Text(note.content ?? "Unknown")
                        }
                    }
                }
            }
            .navigationTitle("Notes")
            .task {
                do {
                    try await model.getAllNotes()
                    print("called")
                }catch {
                    print("called:\(error.localizedDescription)")
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

