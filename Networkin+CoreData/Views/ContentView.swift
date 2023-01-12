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
    @State private var showSheet = false
    let columns = [GridItem(.adaptive(minimum: 150), spacing: -15)]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                    ForEach(0..<2) { j in
                        Section {
                            let num = j == 0 ? 2 : 10
                            ForEach(0..<num) {i in
                                NoteItemView(index: i)
                            }
                        } header: {
                            Text(j == 0 ? "Pinned" : "Others")
                                .foregroundColor(.black.opacity(0.5))
                                .padding(.leading, 15)
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
                    model.setMsgAndLoadStatus(
                        msg: "server encountered an error 🥲",
                        isLoading: false)
                    print("called:\(error.localizedDescription)")
                }
            }
            .toolbar {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showSheet) {
                NavigationStack {
                    AddNoteView()
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

