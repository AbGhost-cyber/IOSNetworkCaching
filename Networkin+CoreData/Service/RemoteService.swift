//
//  NoteService.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/11.
//

import Foundation
enum RemoteServiceError: Error {
    case badURL
    case unknownError
}
enum Result<Sucess,Failure>{
    case success(Sucess)
    case failure(Failure)
}
class RemoteService{
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getAllNotes() async throws -> Result<[NoteDTO], String> {
        guard let url = URL(string: "/notes", relativeTo: baseURL) else {
            return .failure("bad url")
        }
        //make request
        let (data, _) = try await URLSession.shared.data(from: url)
        let noteResponse = try JSONDecoder().decode(NoteListResponse.self, from: data)
        if(noteResponse.success) {
            return .success(noteResponse.data)
        }
        return .failure("an unknown error occurred")
    }
}


