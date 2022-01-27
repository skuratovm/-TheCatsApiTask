//
//  CatsViewModel.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 26.01.22.
//

import Foundation
import Combine
import UIKit

class CatsViewModel {
    @Published var cats = [CatsModelElement]()
    @Published var data = Data()
    private let imageLoader = ImageLoader()
    @Published var image = UIImage()
    //var page = 0
    var fetchingMore = false
    var cancellable: Cancellable?
    private var anyCancelable = Set<AnyCancellable>()
    
    init() {}
    
    
    func fetchCats(page: Int) {
        NetworkManager.shared.getResults(page: page)
            .receive(on: DispatchQueue.main)
            .map{$0}
            .sink { completion in
                
                switch completion {
                    
                case .finished:
                    print("Done")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: {[weak self] cats in
                guard let self = self else {return}
                self.cats = cats
            }
            .store(in: &anyCancelable)
    }
    
}
