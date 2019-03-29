//
//  WriteCommentViewController.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 9. 4..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit

class WriteCommentViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var cancelBarItem: UIBarButtonItem!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var starRatingLabel: UILabel!
    
    
    
    let attributeString = NSMutableAttributedString(string: "")
    let imageAttachment = NSTextAttachment() //empty star
    let imageAttechment2 = NSTextAttachment() // half star
    let imageAttechment3 = NSTextAttachment() // full star
    

    var movie: Movie?
    var myComment:WriteComment?
    var currentCommentInfo: [WriteComment]?
    
    var userRating: Double = 0.0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewContents()
        //한줄평 배열 가져옴
        
        //self.currentCommentInfo = Request.loadCommentFromFile()
        
    }
    
}

//MARK:- IBAction
extension WriteCommentViewController {
    
    @IBAction func tabCompleteButton() {
    
        let idText = idTextField.text
        let commentText = commentTextView.text
        
        if  idText == "" || commentText == ""  {
            
            let alert = UIAlertController(title: "알림", message: "한줄평 정보를 모두 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { ACTION in
                
            })

            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: {
                print("Alert controller shown")
            })
            
        } else {
            self.createCommentObject() //한줄평 객체화
            self.addMyCommentToFile() //POST send 호출
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func tabCancelButton() {
        MovieInformation.shared.userID = self.idTextField.text //user_id local save
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Method
extension WriteCommentViewController {
    //초기 화면 속성 설정
    func setViewContents() {
        starRatingLabel.text = WriteCommentViewController.formatValue(5)
        starView.didTouchCosmos = didTouchCosmos
        starView.didFinishTouchingCosmos = didFinishTouchingCosmos
        
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = UIColor.orange.cgColor
        commentTextView.layer.cornerRadius = 5
        
        self.movie = MovieInformation.shared.movie
        self.titleLabel.text = movie?.title
        self.gradeImageView.image = UIImage(named: gradeOfMovie(movie: movie!))
        self.idTextField.text = MovieInformation.shared.userID
    }
    //myComment 객체를 Send
    func addMyCommentToFile(completion: ((_ isSuccess: Bool)-> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let comment = self?.myComment {
                Request.writeCommentToFile(comment: comment, completionHandler: { (newComment, error) in
                    DispatchQueue.main.async {
                        completion?(newComment != nil)
                    }
                })
            } else {
                print("currentCommentInfo == nil")
            }
        }
    }
    //myComment 객체 생성
    func createCommentObject() {
        let timestamp = NSDate().timeIntervalSince1970
        myComment = WriteComment(rating: userRating, timestamp: timestamp, writer: idTextField.text!, movieId: (movie?.id)!, contents: commentTextView.text)
    }

    //등급별 이미지 반환
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

//MARK:- Cosmos StarRating
extension WriteCommentViewController {
    
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.f", value*2)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        userRating = rating
        starRatingLabel.text = WriteCommentViewController.formatValue(rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        userRating = rating
        self.starRatingLabel.text = WriteCommentViewController.formatValue(rating)
    }
    
    private func updateRating() {
        let value = Double()
        starView.rating = value
        
        self.starRatingLabel.text = WriteCommentViewController.formatValue(value)
    }

}





