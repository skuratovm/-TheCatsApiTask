//
//  ViewController.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 24.01.22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var anyCancelable = Set<AnyCancellable>()
    var cancellable: Cancellable?
    let viewModel = CatsViewModel()
    var fetchingMore = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CatBreedTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        fetchCats()
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertP(_:)), name: Notification.Name("image"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showExportSheet), name: Notification.Name("export"), object: nil)
    }
   
    private func fetchCats() {
        viewModel.fetchCats()
        viewModel.$cats
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.tableView.reloadData()
                
            }
            .store(in: &anyCancelable)
        
    }
    @objc func showExportSheet(_ notification: Notification){
        let path = notification.object
        let exportSheet = UIActivityViewController(activityItems: [path as Any] as [Any], applicationActivities: nil)
        self.present(exportSheet, animated: true, completion: nil)
    }
    @objc func showAlertP(_ notification: Notification){
        showAlert(imageURL: notification.object as! String) { (_) in
            print("save \(notification.object as! String)")
            
            ImageDownloader.shared.download(urlString: notification.object as! String)
        }
        
    }
    
    @IBAction func refreshCatsButtonAction(_ sender: UIBarButtonItem) {
        fetchCats()
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cats.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! CatBreedTableViewCell
        viewModel.$cats
            .receive(on: DispatchQueue.main)
            .sink { cats in
                cell.configureCell(with: cats[indexPath.row])
                cell.configureDB(indexPath: indexPath, result: cats)
            }
            .store(in: &anyCancelable)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToFavorite = self.addToFavorites(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [addToFavorite])
        return swipe
    }
    private func addToFavorites(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Add to favorites") { [weak self]_, _, _ in
            guard let self = self else {return}
            var result = self.viewModel.$cats
                .receive(on: DispatchQueue.main)
                .sink { cats in
                    DataBase.shared.saveSchedule(result: cats[indexPath.row],row: indexPath.row)
                }
                .store(in: &self.anyCancelable)
            self.tableView.reloadData()
        }
        //self.tableView.reloadData()
        return action
    }
    
    
}

