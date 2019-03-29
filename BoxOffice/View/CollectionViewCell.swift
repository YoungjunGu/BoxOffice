//
//  CollectionViewCell.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 8. 14..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    //MARK:- Property
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension CollectionViewCell {
    
    func gradeOfMovie(movie: Movie) -> String {
        
        switch movie.grade {
        case 0:
            return "ic_allages"
        case 12:
            return "ic_12"
        case 15:
            return "ic_15"
        case 19:
            return "ic_19"
        default:
            return "ic_allages"
        }
        
    }
}


extension CollectionViewCell {
    
    func configureTable(movie: Movie, collectionView: UICollectionView, indexPath: IndexPath) {
        

        
        Request.image(movie.thumb, completion: {(image: UIImage?) in
            DispatchQueue.main.async {
                self.titleLabel.text = movie.title
                self.infoLabel.text = movie.collectionInfo
                self.dateLabel.text = movie.date
                self.gradeImageView.image = UIImage(named: self.gradeOfMovie(movie: movie))
                guard let cell: CollectionViewCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
                cell.postImageView.image = image
            }
            
        })
        
    }
}
