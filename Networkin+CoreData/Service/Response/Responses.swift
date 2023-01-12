//
//  Responses.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import Foundation
import CoreData

struct SimpleResponse: Codable {
    let success: Bool
    let message: String
}
struct NoteDTO: Codable, Identifiable {
    let title: String
    let content: String?
    let date: Int64
    let color: String
    let id: String
}

extension NoteDTO {
    func toNote(context: NSManagedObjectContext){
        let note = Note(context: context)
        note.id = self.id
        note.title = self.title
        note.content = self.content
        note.date = self.date
        note.color = self.color
    }
}
extension Note {
    func toDto() -> NoteDTO {
        return NoteDTO(
            title: self.title ?? "Unknown title",
            content: self.content ?? "Unknown content",
            date: self.date,
            color: self.color ?? "",
            id: self.id ?? UUID().uuidString
        )
    }
}

struct NoteListResponse: Codable {
    let success: Bool
    let message: String
    let data: [NoteDTO]
}

struct NoteResponse: Codable {
    let success: Bool
    let message: String
    let data: NoteDTO
}
