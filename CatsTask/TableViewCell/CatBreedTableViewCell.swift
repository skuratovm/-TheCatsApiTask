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
            
        }
    }
    
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    
    @IBOutlet weak var catBreedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
            //catImageView.image = #imageLiteral(resourceName: "Cat-18.jpeg")
        }
    }
    //func configureImage
    
    func configureCell(with cat: CatsModelElement) {
        //let image = UIImage(data: data)
        let imageURLString = cat.image?.url
        
        configureImage(imageURLString: imageURLString)
        catBreedLabel.text = cat.name
        descriptionLabel.text = cat.catsModelDescription
        
    }
    
    func configureDB(indexPath: IndexPath, result: CatsModel?){
        //var resultll: CatsModel?
        indexPathRR = indexPath
        resultll = result
        
        print("🐰\(resultll)❌")
        
    }
    
    func configureButton(){
        if isFavorite == false{
            favoriteButtonOutlet.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else {
            favoriteButtonOutlet.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    
    
}
