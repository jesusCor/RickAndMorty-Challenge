//
//  CharactersRepository.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 28/01/2024.
//

import Alamofire


class CharactersRepository: BaseRepository {
    
    static let shared = CharactersRepository()
    private override init() {}
    
    let paramName = "name"
    
    
    // MARK: Endpoints
    
    let getCharactersEndpoint = "/character"
    
    
    // MARK: Api functions.
    
    func getCharactersPage(page: Int, characterName: String) async throws -> CharactersPage {
        do {
            // We add the pageable query parameters first.
            var params: [String : Any] = [paramPage: page]
            
            // Add characterName as query param (if empty, it'll fetch all the characters).
            params[paramName] = characterName
            
            return try await getRequest(getCharactersEndpoint, parameters: params).serializingDecodable(CharactersPage.self).value
        } catch {
            throw AppErrorType.unknown("getCharactersPage error: \(error)")
        }
    }
    
}
