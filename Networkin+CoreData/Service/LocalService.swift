//
//  LocalService.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import Foundation
import CoreData

class LocalService: ObservableObject {
    let container: NSPersistentContainer
    static let shared: LocalService = LocalService()
    
    private init() {
        container = NSPersistentContainer(name: "models")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
        }
    }
}
