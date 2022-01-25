//
//  CatBreedTableViewCell.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 24.01.22.
//
import UIKit

class CatBreedTableViewCell: UITableViewCell {
    var resultll: CatsModel?
    var isFavorite = false
    var indexPathRR :IndexPath = []
    
    @IBOutlet weak var catImageView: UIImageView!{
        didSet{
            catImageView.layer.cornerRadius = 20
            catImageView.image = #imageLiteral(resourceName: "Cat-18.jpeg")
        }
    }
    
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
       

    @IBOutlet weak var catBreedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                        catImageView.addGestureRecognizer(tapGR)
                        catImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
                    if sender.state == .ended {
                        let imageURL = resultll?[indexPathRR.row].image?.url
                        NotificationCenter.default.post(name: Notification.Name("image"), object: imageURL )
                    
                    }
            }
    func configureImage(imageURLString: String?){
        if let urlString = imageURLString{
            NetworkRequest.shared.requestData(urlString: urlString) { [weak self] result in
                switch result{
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.catImageView.image = image
                case .failure(let error):
                    self?.catImageView.image = #imageLiteral(resourceName: "Cat-18.jpeg")
                    print("No Image :\(error.localizedDescription)")
                }
            }
        } else {
            catImageView.image = #imageLiteral(resourceName: "Cat-18.jpeg")
        }
    }
    
    func configureCell(breedText: String,imageURL: String,descriptionText: String) {
        //let image = UIImage(data: data)
        
        configureImage(imageURLString: imageURL)
        catBreedLabel.text = breedText
        descriptionLabel.text = descriptionText
    }
    func configureDB(indexPath: IndexPath, result: CatsModel?){
        //var resultll: CatsModel?
        indexPathRR = indexPath
        resultll = result
        //DataBase.shared.saveSchedule(result: resultll?[indexPathRR.row])
        print("🐰\(resultll)❌")
        
    }
    
    @IBAction func isFavoriteButtonAction(_ sender: UIButton) {
        print ("tap")
        if isFavorite == false{
            isFavorite = true
           DataBase.shared.saveSchedule(result: resultll?[indexPathRR.row])
            print("🍄\(indexPathRR.row)")
           
        } else {
            isFavorite = false
            DataBase.shared.deleteSchedule(result: resultll?[indexPathRR.row])
        }
        
        configureButton()
    }
    func configureButton(){
        if isFavorite == false{
            favoriteButtonOutlet.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else {
            favoriteButtonOutlet.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    
    
}
