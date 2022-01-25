//
//  ViewController.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 24.01.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var result: CatsModel?
    var limit = 20
    var total  = 100
    //var favoriteClicker[Int:Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CatBreedTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertP(_:)), name: Notification.Name("image"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchSchedule()
    }
    @objc func showAlertP(_ notification: Notification){
        showAlert(imageURL: notification.object as! String) { (_) in
            print("save \(notification.object as! String)")
            
            var imageURLString = notification.object as! String
            NetworkRequest.shared.requestData(urlString: imageURLString) { [weak self] result in
                switch result{
                case .success(let data):
                    let image = UIImage(data: data)
                    //
                    if let image = image {
                        if let data = image.jpegData(compressionQuality: 1.0) {
                            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cat.jpg")
                            try? data.write(to: path!)
                            let exportSheet = UIActivityViewController(activityItems: [path as Any] as [Any], applicationActivities: nil)
                            self!.present(exportSheet, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    
                    print("No Image :\(error.localizedDescription)")
                }
            }
        }
      
    }
    
    @IBAction func favouritesButtonAction(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func refreshCatsButtonAction(_ sender: UIBarButtonItem) {
        fetchSchedule()
    }
    
    
    private func fetchSchedule(){
        //activityIndicator.startAnimating()
        //refreshButtonOutlet.rotate()
        let urlString = "https://api.thecatapi.com/v1/breeds"
        tableView.reloadData()
        NetworkDataFetch.shared.FetchSchedule(urlString: urlString) { [weak self]catModel, error in
            if error == nil{
                guard let catModel = catModel else {return}
                self?.result = catModel
                //MARK:save data to UserDefaults
                //self?.refreshButtonOutlet.endRotate()
                
                //DataBase.shared.saveSchedule(result: self?.result)
                //print("🌎\(self?.result)")
                
                //self?.resultMemory = self?.result
                self!.tableView.reloadData()
                //print("\(self?.result?.breeds[0].name)")
            } else {
                //self?.errorArlert(title: "Ошибка соединения!", message: "Проверьте подкрлючение к инернету и попробуйте еще раз.")
                print("❌\(error?.localizedDescription)")
            }
        }
    }
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! CatBreedTableViewCell
        //fetchSchedule(indexPath: indexPath)
        let modelElement = result
        let breedName = result?[indexPath.row].name ?? "non"
        let descriptionText = result?[indexPath.row].catsModelDescription ?? ""
        let breedImageURL = result?[indexPath.row].image?.url ?? ""
        cell.configureCell(breedText: breedName,imageURL: breedImageURL, descriptionText: descriptionText)
        cell.configureDB(indexPath: indexPath, result: modelElement)
        return cell
    }
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if indexPath.row == result?.count ?? 1 - 1{
    //            if result?.count < total{
    //                var index = 0
    //                while index < limit {
    //
    //                }
    //            }
    //        }
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
        
    }
    
    
}

