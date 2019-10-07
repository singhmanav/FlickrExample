//
//  File.swift
//  Assignment
//
//  Created by xeadmin on 05/09/19.
//  Copyright © 2019 Manav. All rights reserved.
//

import Foundation

let apiKey = "70d069fac1d9d4597b0e284f6c139c84"

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    let jsonDecoder = JSONDecoder()
    
    func searchFlickr(_ searchText: String, page: Int = 1,completion : @escaping (_ results: PhotoSearchResult?,_ error : Error?) -> Void){
        
        guard let searchURL = getSearchUrl(searchText,page: page) else {
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchRequest, completionHandler: { (data, response, error) in
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    completion(nil,error)
                    return
            }
            do {
                let photoSearchResult = try self.jsonDecoder.decode(PhotoSearchResult.self, from: data)
                completion(photoSearchResult,nil)
            }
            catch{
                completion(nil,error)
            }
            
        }) .resume()
    }
    
    fileprivate func getSearchUrl(_ searchText:String, page: Int = 1) -> URL? {
        
        guard let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(encodedText)&per_page=18&format=json&nojsoncallback=1&page=\(page)"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
        
        return url
    }
}
