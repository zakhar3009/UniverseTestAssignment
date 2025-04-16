//
//  NetworkingService.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import Foundation
import RxSwift

class NetworkingService {
    let decoderService: DecoderService
    
    init(decoderService: DecoderService) {
        self.decoderService = decoderService
    }
    
    func fetch<T: Decodable>(from url: URL) -> Single<T> {
        return Single<T>.create { single in
            let dataTask = Task.detached {
                guard let (data, response) = try? await URLSession.shared.data(from: url) else {
                    single(.failure(NetworkingError.requestError))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                    single(.failure(NetworkingError.invalidResponse))
                    return
                }
                guard let decodedData: T = try? self.decoderService.decode(from: data) else {
                    single(.failure(NetworkingError.decodingError))
                    return
                }
                single(.success(decodedData))
            }
            return Disposables.create { dataTask.cancel() }
        }
    }
}
