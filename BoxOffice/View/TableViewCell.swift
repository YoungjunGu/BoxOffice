//
//  TableViewCell.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 8. 8..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    //MARK:- Property
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var gradeImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension TableViewCell {
    
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

extension TableViewCell {
    
    func configureTable(movie: Movie, tableView: UITableView, indexPath: IndexPath) {
        
        self.titleLabel.text = movie.title
        self.infoLabel.text = movie.tableInfo
        self.dateLabel.text = movie.tableDate
        self.gradeImageView.image = UIImage(named: self.gradeOfMovie(movie: movie))
        
        Request.image(movie.thumb, completion: {(image: UIImage?) in
            DispatchQueue.main.async {
                
                guard let cell: TableViewCell = tableView.cellForRow(at: indexPath) as?  TableViewCell else {
                    return
                }
                cell.postImageView.image = image
            }
            
        })
        
    }
}
