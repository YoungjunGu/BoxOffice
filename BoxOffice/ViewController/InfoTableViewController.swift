//
//  InfoTableViewController.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 8. 27..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit


class InfoTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   //MARK:- Property
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userRateLabel: UILabel!
    @IBOutlet weak var reservRateLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var starRatingLabel: UILabel!
    
    @IBOutlet weak var synopsisView: UIView!
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var staffInfoView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topAnchor: NSLayoutConstraint!
    
    let zoomImageView = UIImageView()
    
    var pageHeight = CGFloat()
    
    //영화상세 정보 객체
    var info: MovieInfo?
    //영화 객체
    var movie: Movie? {
        didSet {
            self.title = movie?.title
        }
    }
    //한줄평 객체 배열
    var comments:[CommentInfo] = []
    
    
    var checkValue: Bool = false
    
    let attributeString = NSMutableAttributedString(string: "")
    let imageAttachment = NSTextAttachment()
    let imageAttechment2 = NSTextAttachment()
    let imageAttechment3 = NSTextAttachment()
    
    let cellIdentifier: String = "commentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        let addURL: String = (movie?.id)!
        self.requestMovieInfo(addURL: addURL)
        self.requestCommentsInfo(addURL: addURL)

        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action : #selector(InfoTableViewController.zoomOut(_:))))
        
       scrollView.scrollsToTop = tableView.scrollsToTop
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.layoutIfNeeded()
        
    }
    
    @objc func zoomOut(_ sender: UITapGestureRecognizer) {
        zoomImageView.removeFromSuperview()
    }

    //MARK:- IBAction
    @IBAction func tabWriteButton() {
        MovieInformation.shared.movieTitle = movie?.title
        MovieInformation.shared.movie = movie
    }
    @IBAction func tabPostImageView(_ sender: UITapGestureRecognizer) {
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.image = postImageView.image
        
        zoomImageView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.height)
        zoomImageView.contentMode = .scaleToFill
        
        view.addSubview(zoomImageView)

    }
    
}
//MARK:- UITableViewDataSource
extension InfoTableViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        if let tableCell = cell as? CommentTableViewCell {
            
            guard indexPath.row < self.comments.count else {
                return cell as! CommentTableViewCell
            }
            let comment: CommentInfo = self.comments[indexPath.row]
            
            DispatchQueue.main.async {
                tableCell.configurTable(comment: comment, tableView: tableView, indexPath: indexPath)
            }
            return tableCell
        } else {
            print("cell == nil")
            return cell as! CommentTableViewCell
        }
    }
}





//MARK:- Method
extension InfoTableViewController {
    //영화 상세정보 json 객체 요청
    func requestMovieInfo(addURL: String) {
        
        Request.requestInfoURL(addURL: addURL) { (movieInfo: MovieInfo?) in
            if let requestInfo = movieInfo {
                self.info = requestInfo
                DispatchQueue.main.async {
                    self.audienceLabel.text = self.info?.audienceInfo
                    self.reservRateLabel.text = self.info?.reservationInfo
                    self.userRateLabel.text = self.info?.ratingInfo
                    self.synopsisLabel.text = self.info?.synopsis
                    self.actorLabel.text = self.info?.actor
                    self.directorLabel.text = self.info?.director
                    self.titleLabel.text = self.info?.title
                    self.dateLabel.text = self.info?.date
                    self.genreLabel.text = self.info?.genre
                    self.starRating()
                    self.starRatingLabel.attributedText = self.attributeString
                    
                    let imageURL: URL = URL(string: self.info!.image)!
                    Request.image(imageURL, completion: {(image: UIImage?) in
                        self.postImageView.image = image
                        self.gradeImageView.image = UIImage(named: self.gradeOfMovie(movie: self.movie!))
                        
                    })
                }
            } else {
                print("movieInfo == nil")
            }
        }
    }
    //한줄평 json 배열 요청
    func requestCommentsInfo(addURL: String) {
        
        Request.requestCommentURL(addURL: addURL) { (comments: [CommentInfo]?) in
            if let requestComments = comments {
                self.comments = requestComments
                self.tableView.reloadSections(IndexSet(0...0), with: UITableViewRowAnimation.automatic)
            }
        }
        
    }
    //등급에 따른 이미지 반환
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
    
    func starRating() {
        if let rating = self.info?.userRating {
            let remainder = rating.truncatingRemainder(dividingBy: 1)
            var integer: Int = Int(rating - remainder)
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
    

    
}















