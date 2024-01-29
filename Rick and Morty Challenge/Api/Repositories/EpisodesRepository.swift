//
//  EpisodesRepository.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import Alamofire


class EpisodesRepository: BaseRepository {
    
    static let shared = EpisodesRepository()
    private override init() {}
    
    
    // MARK: Endpoints
    
    let getEpisodesEndpoint = "/episode"
    func getMultipleEpisodesEndpoint(episodes: [Int]) -> String {
        // We convert the list of episodes into a comma separated string first.
        let episodeNumbersString = episodes.map { String($0) }.joined(separator: ",")
        return "/episode/\(episodeNumbersString)"
    }
    
    
    // MARK: Api functions.
    
    func getEpisode(episode: Int) async throws -> EpisodeResponse {
        do {
            let endpoint = getMultipleEpisodesEndpoint(episodes: [episode])
            return try await getRequest(endpoint).serializingDecodable(EpisodeResponse.self).value
        } catch {
            throw AppErrorType.unknown("getEpisode error: \(error)")
        }
    }
    
    func getMultipleEpisodes(episodes: [Int]) async throws -> [EpisodeResponse] {
        do {
            let endpoint = getMultipleEpisodesEndpoint(episodes: episodes)
            return try await getRequest(endpoint).serializingDecodable([EpisodeResponse].self).value
        } catch {
            throw AppErrorType.unknown("getMultipleEpisodes error: \(error)")
        }
    }
    
//    func getEpisodesPage(page: Int) async throws -> EpisodesPage {
//        do {
//            // We add the pageable query parameters first.
//            let params: [String : Any] = [paramPage: page]
//
//            return try await getRequest(getEpisodesEndpoint, parameters: params).serializingDecodable(EpisodesPage.self).value
//        } catch {
//            throw AppErrorType.unknown("getEpisodesPage error: \(error)")
//        }
//    }
    
}
