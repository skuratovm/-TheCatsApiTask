//
//  NetworkManager.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 26.01.22.
//

import Foundation
import Combine
import UIKit

class NetworkManager{
    static let shared = NetworkManager()
    
    var anyCancelable = Set<AnyCancellable>()
    
    func getResults() -> AnyPublisher<[CatsModelElement], Error> {
        
        let urlString = "https://api.thecatapi.com/v1/breeds"
        let url = URL(string: urlString)!
        
        let decoder = JSONDecoder()
        
        return Future {[weak self] promise in
            guard let self = self else {return}
            URLSession.shared.dataTaskPublisher(for: url)
                .retry(1)
                .mapError {$0}
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [CatsModelElement].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { cats in
                    promise(.success(cats))
                }
                .store(in: &self.anyCancelable)
        }
        .eraseToAnyPublisher()
        
        
    }
    
}
