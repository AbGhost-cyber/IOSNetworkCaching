//
//  Networkin_CoreDataApp.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import SwiftUI

@main
struct Networkin_CoreDataApp: App {
    private var remoteService = RemoteService(baseURL: URL(string: "http://localhost:8085")!)
    @StateObject  private var localService = LocalService.shared
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(\.managedObjectContext, localService.container.viewContext)
                    .environmentObject(NoteModel(remoteService, localService))
            }
        }
    }
}
