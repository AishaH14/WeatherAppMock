//
//  LocalJSONLoader.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/10/1447 AH.
//

import Foundation

enum LocalJSONLoaderError: Error {
    case fileNotFound(String)
    case failedToRead(Error)
    case failedToDecode(Error)
}

final class LocalJSONLoader {
    
    private init() {}
    
    static func load<T: Decodable>(_ type: T.Type, from fileName: String) async throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw LocalJSONLoaderError.fileNotFound("\(fileName).json not found")
        }
        
        return try await Task.detached(priority: .userInitiated) {
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                return try JSONDecoder().decode(T.self, from: data)
            } catch let decodingError as DecodingError {
                throw LocalJSONLoaderError.failedToDecode(decodingError)
            } catch {
                throw LocalJSONLoaderError.failedToRead(error)
            }
        }.value
    }
}
