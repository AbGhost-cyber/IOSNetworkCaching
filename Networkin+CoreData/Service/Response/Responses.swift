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
    let title: String?
    let content: String?
    let date: Int64
    let color: String
    let id: String
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
