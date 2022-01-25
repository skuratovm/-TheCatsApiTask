//
//  DownloadAlertController.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 25.01.22.
//

import Foundation
import UIKit



extension ViewController {
    func showAlert(imageURL: String, completionHandler: @escaping(String) -> Void){
        let alertController = UIAlertController(title: "Download", message: "Save the image to camera roll", preferredStyle: .actionSheet)
        let downloadAlertAction = UIAlertAction(title: "Download", style: .default) { (_) in
            print("")
            completionHandler(imageURL )
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(downloadAlertAction)
        alertController.addAction(cancelAlertAction)
       present(alertController, animated: true)
    }
}
extension FavotitesViewController {
    func showAlert(imageURL: String, completionHandler: @escaping(String) -> Void){
        let alertController = UIAlertController(title: "Download", message: "Save the image to camera roll", preferredStyle: .actionSheet)
        let downloadAlertAction = UIAlertAction(title: "Download", style: .default) { (_) in
            print("")
            completionHandler(imageURL )
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(downloadAlertAction)
        alertController.addAction(cancelAlertAction)
       present(alertController, animated: true)
    }
}
