//
//  FavotitesViewController.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 24.01.22.
//

import UIKit

class FavotitesViewController: UIViewController {

    var resultMemoryArray = DataBase.shared.cats
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CatBreedTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
       // NotificationCenter.default.addObserver(self, selector: #selector(showAlertP(_:)), name: Notification.Name("image"), object: nil)
    }
    
//    @objc func showAlertP(_ notification: Notification){
//        showAlert(imageURL: notification.object as! String) { (_) in
//            print("save \(notification.object as! String)")
//
//            //
//            if let image = image {
//                if let data = image.jpegData(compressionQuality: 1.0) {
//                    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cat.jpg")
//                    try? data.write(to: path!)
//                    let exportSheet = UIActivityViewController(activityItems: [path as Any] as [Any], applicationActivities: nil)
//                    self!.present(exportSheet, animated: true, completion: nil)
//                }
//            }
//        }
 //   }
    
    
    


}
extension FavotitesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultMemoryArray?.count ?? 0
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! CatBreedTableViewCell
        let breedName = resultMemoryArray?[indexPath.row].name ?? "non"
        let descriptionText = resultMemoryArray?[indexPath.row].catsModelDescription ?? ""
        let breedImageURL = resultMemoryArray?[indexPath.row].image?.url ?? ""
        cell.configureCell(breedText: breedName,imageURL: breedImageURL, descriptionText: descriptionText)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
       
    }
    
    
}
