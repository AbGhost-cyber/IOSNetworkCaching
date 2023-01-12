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
    @Published var userInfoMsg: String = ""
    @Published var isLoading = true
    
   private let remoteService: RemoteService
    private let localService: LocalService
    
    init(_ remoteService: RemoteService, _ localService: LocalService) {
        self.remoteService = remoteService
        self.localService = localService
    }
    
    func getAllNotes() async throws {
       setMsgAndLoadStatus(isLoading: true)
        do {
            let noteDtos = try await remoteService.getAllNotes()
            let context = localService.container.viewContext
            
            if !noteDtos.isEmpty {
                noteDtos.forEach { noteDto in
                   saveNoteToLocal(context: context, noteDto: noteDto)
                }
            } else {
                //TODO: check if there are some items in core data then sync to server
            }
            setMsgAndLoadStatus(isLoading: false)
        }catch RemoteError.error(let error){
            setMsgAndLoadStatus(msg: error, isLoading: false)
        }
    }
    
    func setMsgAndLoadStatus(msg: String = "", isLoading: Bool) {
        self.userInfoMsg = msg
        self.isLoading = isLoading
    }
    
    func insertNote(note: UINote) async throws {
        setMsgAndLoadStatus(isLoading: true)
        do {
            let context = localService.container.viewContext
            saveNoteToLocal(context: context, noteDto: note.toDto())
            let message = try await remoteService.insertNote(with: note.toDto())
            setMsgAndLoadStatus(msg: message, isLoading: false)
        }catch RemoteError.error(let error){
            setMsgAndLoadStatus(msg: error, isLoading: false)
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
