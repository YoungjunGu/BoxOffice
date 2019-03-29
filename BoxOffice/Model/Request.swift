//
//  Request.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 9. 15..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import Foundation
import UIKit


struct Request {
    
    private static var baseURLString: String = "http://connect-boxoffice.run.goorm.io/movies?"
    
    private static var infoURLString: String = "http://connect-boxoffice.run.goorm.io/movie?"
    
    private static var commentURLString: String = "http://connect-boxoffice.run.goorm.io/comments"
    
    private static let imageDispatchQueue: DispatchQueue = DispatchQueue(label: "image")
    
    private static var commentWriteURL: String = "http://connect-boxoffice.run.goorm.io/comments"
    
    private static var cachedImage: [URL: UIImage] = [:]
    
}


//MARK:- API Request
extension Request {
    //Alamofire 라이브러리를 사용해서 수정 필요
    //https://hcn1519.github.io/articles/2017-09/swift_escaping_closure 에서 escaping에 관한것과 사용법을 참고 했습니다.
    //영화정보 리스트 URL요청
    static func requestURL(addURL: String, _ completion: @escaping (_ movies: [Movie]?) -> Void) {
        
        if var urlComponents = URLComponents(string: baseURLString) {
            urlComponents.query = "order_type=\(addURL)"
            
            guard let url = urlComponents.url else { return }
            print(url.absoluteString)
            let session: URLSession = URLSession(configuration: .default)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let dataTask: URLSessionDataTask = session.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                defer {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
                guard let data = data else {
                    print("Data 업로드 실패")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                do {
                    let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(apiResponse.movies)
                    }
                    
                } catch(let err) {
                    print("디코딩 실패")
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            dataTask.resume()
        } else {
            print("There is no file from url")
        }
    }
    //    영화 상세 정보 URL요청
    static func requestInfoURL(addURL: String, _ completion: @escaping (_ movieInfo: MovieInfo?) -> Void) {
        //경로추가
        if var urlComponents = URLComponents(string: infoURLString) {
            urlComponents.query = "id=\(addURL)"
            
            guard let url = urlComponents.url else { return }
            let session: URLSession = URLSession(configuration: .default)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let dataTask: URLSessionDataTask = session.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                defer {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
                guard let data = data else {
                    print("Data 업로드 실패")
                    return
                }
                
                do {
                    let apiInfoResponse = try JSONDecoder().decode(MovieInfo.self, from: data)
                    DispatchQueue.main.async {
                        completion(apiInfoResponse)
                    }
                    
                } catch(let err) {
                    print("디코딩 실패")
                    print(err.localizedDescription)
                }
            }
            dataTask.resume()
        } else {
            print("There is no file from url")
        }
    }
    //한줄평 리스트 URL요청
    static func requestCommentURL(addURL: String, _ completion: @escaping (_ comments: [CommentInfo]?) -> Void) {
        
        if var urlComponents = URLComponents(string: commentURLString) {
            urlComponents.query = "movie_id=\(addURL)"
            
            guard let url = urlComponents.url else { return }

            let session: URLSession = URLSession(configuration: .default)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let dataTask: URLSessionDataTask = session.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                defer {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
                guard let data = data else {
                    print("Data 업로드 실패")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                do {
                    let apiResponse: APICommentResponse = try JSONDecoder().decode(APICommentResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(apiResponse.comments)
                    }
                    
                } catch(let err) {
                    print("디코딩 실패")
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            dataTask.resume()
        } else {
            print("There is no file from url")
        }
    }
    
}


extension Request {
  
    //한줄평 배열을 decoding
    static func loadCommentFromFile() -> [WriteComment] {
        
        if let urlComponents = URLComponents(string: commentWriteURL) {
            
            guard let url = urlComponents.url else { return [] }
            
            do {
                let data: Data = try Data(contentsOf: url)
                let decoder: JSONDecoder = JSONDecoder()
                let comments: [WriteComment] = try decoder.decode([WriteComment].self, from: data)
                
                return comments
                
            } catch {
                print("Can not save the comment to file")
                print(error.localizedDescription)
            }
            return []
        } else {
            print("There is no file form url")
        }
        return []
    }
    
    //객체를 API에 encoding
    static func writeCommentToFile(comment: WriteComment, completionHandler: @escaping (WriteComment?, Error?)->Void) {
        guard let url: URL = URL(string: commentWriteURL) else {
            return completionHandler(nil,NSError(domain: "Model", code: 0, userInfo: [NSLocalizedDescriptionKey: "한줄평 등록 실패"]))
        }
        print(url)
        let session: URLSession = URLSession(configuration: .default)
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            let data = try JSONEncoder().encode(comment)
            urlRequest.httpBody = data
        } catch {
            return completionHandler(nil,NSError(domain: "Model", code: 0, userInfo: [NSLocalizedDescriptionKey: "한줄평 Encoding 실패"]))
        }
        let uploadTask: URLSessionUploadTask = session.uploadTask(with: urlRequest, from: nil) { (data: Data?, reponse: URLResponse?,error: Error?) in
            if let data = data {
                let result = try? JSONDecoder().decode(WriteComment.self, from: data)
                completionHandler(result, error)
            } else {
                completionHandler(nil,NSError(domain: "Model", code: 0, userInfo: [NSLocalizedDescriptionKey: "한줄평 업로드 데이터 == nil"]))
            }
        }
        uploadTask.resume()
    }
    
    
    
    
}

//MARK:- Image Request
extension Request {
    
    static func image(_ url:URL, completion: @escaping (_ image: UIImage?) -> Void) {
        
        if let cachedImage: UIImage = self.cachedImage[url] {
            DispatchQueue.main.async {
                completion(cachedImage)
                return
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        imageDispatchQueue.async {
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            guard let data: Data = try? Data(contentsOf: url) else {
                print("이미지 변환 실패")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let image: UIImage? = UIImage(data: data)
            cachedImage[url] = image
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
    }
}
