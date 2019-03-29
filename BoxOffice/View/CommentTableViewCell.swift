//
//  CommentTableViewCell.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 8. 31..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    //MARK:- Property
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var starRatingLabel: UILabel!
    
    var attributeString = NSMutableAttributedString(string: "")
    let imageAttachment = NSTextAttachment()
    let imageAttechment2 = NSTextAttachment()
    let imageAttechment3 = NSTextAttachment()
    
    var checkValue: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
//MARK:- Method
extension CommentTableViewCell {
    
    func configurTable(comment: CommentInfo?, tableView: UITableView, indexPath: IndexPath) {
        
        if let commentInfo: CommentInfo = comment {
            DispatchQueue.main.async {
                self.timestampLabel.text = commentInfo.dateConvert
                self.writerLabel.text = commentInfo.writer
                self.contentsLabel.text = commentInfo.contents


                self.starRating(info: comment!)
                self.starRatingLabel.attributedText = self.attributeString
                self.attributeString = NSMutableAttributedString(string: "")
            }
        } else {
            print("comment == nil")
        }
    }
    
    func starRating(info: CommentInfo) {
        
        let remainder = info.rating.truncatingRemainder(dividingBy: 1)
        var integer: Int = Int(info.rating - remainder)
        if integer%2 == 0 { //짝수
            for _ in 0...4 {
                if integer >= 1 {
                    self.imageAttachment.image = UIImage(named: "ic_star_label")
                    imageAttachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                    self.attributeString.append(NSAttributedString(attachment: self.imageAttachment))
                    integer /= 2
                } else {
                    self.imageAttechment3.image = UIImage(named: "ic_star_large")
                    imageAttechment3.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                    self.attributeString.append(NSAttributedString(attachment: self.imageAttechment3))
                    integer /= 2
                }
            }
        } else { //홀수
            if integer > 5 {
                for i in 0...4 {
                    
                    if checkValue == true {
                        for _ in i...4 {
                            self.imageAttechment3.image = UIImage(named: "ic_star_large")
                            imageAttechment3.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                            self.attributeString.append(NSAttributedString(attachment: self.imageAttechment3))
                            
                        }
                        break
                    }
                    if integer >= 1 {
                        self.imageAttachment.image = UIImage(named: "ic_star_label")
                        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                        self.attributeString.append(NSAttributedString(attachment: self.imageAttachment))
                        integer /= 2
                    } else {
                        self.imageAttechment2.image = UIImage(named: "ic_star_large_half")
                        imageAttechment2.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                        self.attributeString.append(NSAttributedString(attachment: self.imageAttechment2))
                        
                        integer /= 2
                        checkValue = true
                        
                    }
                }
            } else {
                for i in 0...4 {
                    
                    if checkValue == true {
                        for _ in i...4 {
                            self.imageAttechment3.image = UIImage(named: "ic_star_large")
                            imageAttechment3.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                            self.attributeString.append(NSAttributedString(attachment: self.imageAttechment3))
                            
                        }
                        break
                    }
                    if integer >= 2 {
                        self.imageAttachment.image = UIImage(named: "ic_star_label")
                        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                        self.attributeString.append(NSAttributedString(attachment: self.imageAttachment))
                        integer /= 2
                    } else {
                        self.imageAttechment2.image = UIImage(named: "ic_star_large_half")
                        imageAttechment2.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                        self.attributeString.append(NSAttributedString(attachment: self.imageAttechment2))
                        
                        integer /= 2
                        checkValue = true
                        
                    }
                }
            }
            
            
            
        }
    }
    
}
