//
//  MovieInformation.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 9. 6..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import Foundation

class MovieInformation {
    static let shared: MovieInformation = MovieInformation()
    
    var movieTitle: String?
    var gradeImage: String?
    var movie: Movie?
    var userID: String?
}


