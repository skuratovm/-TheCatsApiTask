//
//  ImageDownloader.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 27.01.22.
//


import Foundation
import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    private init() {}
    
    func download(urlString: String){
        
        let imageURLString = urlString
        NetworkRequest.shared.requestData(urlString: imageURLString) { [weak self] result in
            switch result{
            case .success(let data):
                let image = UIImage(data: data)
                //
                if let image = image {
                    if let data = image.jpegData(compressionQuality: 1.0) {
                        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cat\(arc4random()).jpg")
                        try? data.write(to: path!)
                        NotificationCenter.default.post(name: Notification.Name("export"), object: path)
                    }
                }
            case .failure(let error):

                print("No Image :\(error.localizedDescription)")
            }
        }
    }
    
}

