//
//  NoteService.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import Foundation

enum RemoteError: Error{
    case error(String)
}
class RemoteService{
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    
    func getAllNotes() async throws -> [NoteDTO] {
        guard let url = URL(string: "/notes", relativeTo: baseURL) else {
            throw RemoteError.error("bad url")
        }
        //make request
        let (data, _) = try await URLSession.shared.data(from: url)
        let noteResponse = try JSONDecoder().decode(NoteListResponse.self, from: data)
        if(noteResponse.success) {
            return noteResponse.data
        }
        throw RemoteError.error("an unknown error occurred")
    }
    func insertNote(with noteDto: NoteDTO) async throws -> String {
        guard let url = URL(string: "/notes", relativeTo: baseURL) else {
            throw RemoteError.error("bad url")
        }
        // make request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(noteDto)
        // get response
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SimpleResponse.self, from: data)
        
        if(response.success) {
            return response.message
        }
        throw RemoteError.error(response.message)
    }
}


