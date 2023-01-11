//
//  Model.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import Foundation
import CoreData

@MainActor
class NoteModel: ObservableObject {
    @Published var remoteError: String = ""
    @Published var isLoading = true
    
    let remoteService: RemoteService
    let localService: LocalService
    
    init(_ remoteService: RemoteService, _ localService: LocalService) {
        self.remoteService = remoteService
        self.localService = localService
    }
    
    func getAllNotes() async throws {
        self.isLoading = true
        let response = try await remoteService.getAllNotes()
        switch (response) {
        case .success(let data):
            let context = localService.container.viewContext
            if !data.isEmpty {
                data.forEach { noteDto in
                   saveNoteToLocal(context: context, noteDto: noteDto)
                }
            }else {
                //TODO: check if there are some items in core data then sync to server
            }
            self.isLoading = false
        case .failure(let error):
            self.remoteError = error
            self.isLoading = false
        }
    }
    
    private func saveNoteToLocal(context: NSManagedObjectContext, noteDto: NoteDTO) {
        let entityForTableName = NSEntityDescription.entity(forEntityName: "Note", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let predicate = NSPredicate.init(format: "id == %@", noteDto.id)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityForTableName
        
        do {
            let arrData = try context.fetch(fetchRequest)
            
            if arrData.count > 0 {
                if let updatedNote = arrData.first as? Note {
                    updatedNote.title = noteDto.title
                    updatedNote.content = noteDto.content
                    updatedNote.date = noteDto.date
                    updatedNote.color = noteDto.color
                }
                
            } else {
               // insert new
                noteDto.toNote(context: context)
            }
            if context.hasChanges {
                try? context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
