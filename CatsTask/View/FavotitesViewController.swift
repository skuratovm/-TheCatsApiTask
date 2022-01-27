//
//  FavotitesViewController.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 24.01.22.
//

import UIKit
import Combine

class FavotitesViewController: UIViewController {
    
    var resultMemoryArray = DataBase.shared.cats
    let viewModel = CatsViewModel()
    var anyCancelable = Set<AnyCancellable>()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CatBreedTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertP(_:)), name: Notification.Name("image"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showExportSheet), name: Notification.Name("export"), object: nil)
    }
    @objc func showExportSheet(_ notification: Notification){
        let path = notification.object
        let exportSheet = UIActivityViewController(activityItems: [path as Any] as [Any], applicationActivities: nil)
        self.present(exportSheet, animated: true, completion: nil)
    }
    
    @objc func showAlertP(_ notification: Notification){
        showAlert(imageURL: notification.object as! String) { (_) in
            print("save \(notification.object as! String)")
            
            var imageURLString = notification.object as! String
            ImageDownloader.shared.download(urlString: notification.object as! String)
        }
        
    }
    
}
extension FavotitesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultMemoryArray?.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! CatBreedTableViewCell
        viewModel.$catsBD
            .receive(on: DispatchQueue.main)
            .sink { cats in
                cell.configureCell(with: cats![indexPath.row])
                cell.configureDB(indexPath: indexPath, result: cats)
            }
            .store(in: &anyCancelable)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeFromFavorites = self.removeFromFavorites(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [removeFromFavorites])
        return swipe
    }
    private func removeFromFavorites(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Remove from favorites") { [weak self]_, _, _ in
            guard let self = self else {return}
            var result = self.viewModel.$catsBD
                .receive(on: DispatchQueue.main)
                .sink { cats in
                    DataBase.shared.deleteSchedule(result: cats![indexPath.row], row: indexPath.row)
                }
                .store(in: &self.anyCancelable)
            self.tableView.reloadData()

        }
        return action
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
