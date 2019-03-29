//
//  Model.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 8. 8..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit

//영화 list
struct Movie: Codable {
    
    let grade: Int
    let thumb: URL
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    var tableInfo: String {
        return "평점 : \(userRating) 예매순위 :  \(reservationGrade)  예매율:  \(reservationRate)"
    }
    var tableDate: String {
        return "개봉일 : " + self.date
    }
    var collectionInfo: String {
        return "\(reservationGrade)위(\(userRating))/\(reservationRate)%"
    }
    
    enum CodingKeys: String, CodingKey {
        case grade,thumb,title,date,id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
    
    
}
//영화 상세 정보
struct MovieInfo: Codable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    var reservationInfo: String {
        return "\(self.reservationGrade)위 \(self.reservationRate)%"
    }
    var ratingInfo: String {
        return "\(self.userRating)"
    }
    var audienceInfo: String {
        return "\(self.audience)"
    }
    
    enum CodingKeys: String, CodingKey {
        case audience,actor,duration,director,synopsis,genre,grade,image,title,date,id
        case reservationRate = "reservation_rate"
        case reservationGrade = "reservation_grade"
        case userRating = "user_rating"
    }
}


//한줄평 리스트
struct CommentInfo: Codable {
    var rating: Double
    var timestamp: Double
    var writer: String
    var movieId: String
    var id: String
    var contents: String
    
    var dateConvert: String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    enum CodingKeys: String, CodingKey {
        case rating,timestamp,writer,contents,id
        case movieId = "movie_id"
    }
}
struct WriteComment: Codable {
    var rating: Double
    var timestamp: Double
    var writer: String
    var movieId: String
    var contents: String
    
    enum CodingKets: String, CodingKey {
        case rating,timestamp,writer,contents
        case movie_id = "movie_id"
    }
}























