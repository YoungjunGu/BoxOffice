//
//  Response.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 9. 15..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let movies: [Movie]
}

struct APICommentResponse: Codable {
    let comments: [CommentInfo]
}
