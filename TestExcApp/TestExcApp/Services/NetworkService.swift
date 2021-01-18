//
//  NetworkService.swift
//  TestExcApp
//
//  Created by Kisa Shket on 16.01.2021.
//

import Foundation
import UIKit
final class NetworkService{
    static let shared = NetworkService()
    private let session = URLSession(configuration: .default)
    private let acceptableCodes = [200, 201, 202, 203, 304]
    private let cacher = DataCacher()
    
    private init() {}
    
    func request(withIndex index: Int, complition: @escaping(Result<UIImage,
                                                                    GFError>) -> Void){
        guard let url = createUrl(withIndex: index) else {
            complition(.failure(.noUrl))
            return
        }
        
        let urlFileName = url.query!
        let imageFromCache = self.cacher.loadImageFromDiskWith(fileName: urlFileName)
        if imageFromCache != nil{
            complition(.success(imageFromCache!))
            return
        } else {
            
            let task = session.dataTask(with: url) { data, response, error in
                if let _ = error {
                    complition(.failure(.unableToComplete))
                    return
                }
                
                if let resp = response as? HTTPURLResponse{
                    print(resp.statusCode)
                }
                
                if let response = response as? HTTPURLResponse, self.acceptableCodes.contains(response.statusCode) == false{
                    complition(.failure(.wrongRequest(statusCode: response.statusCode)))
                    return
                }
                
                if let data = data, let image = UIImage(data: data){
                    self.cacher.saveImage(imageName: urlFileName, image: image)
                    complition(.success(image))
                } else {
                    complition(.failure(.wrongData))
                }
                
            }
            task.resume()
        }
    }
    
    fileprivate func createUrl(withIndex index: Int) -> URL?{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "placehold.it"
        components.path = "/375x150"
        components.queryItems = [
            URLQueryItem(name: "text", value: "\(index)")
        ]
        return components.url
    }
}
