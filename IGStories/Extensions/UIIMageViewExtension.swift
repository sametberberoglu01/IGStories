//
//  UIIMageViewExtension.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private static let imageCache = NSCache<AnyObject, AnyObject>()
    
    func sb_loadImageUsingCache(withUrlString urlString: String?, completion: SuccessCompletion? = nil) {
        guard let urlString = urlString else {
            DispatchQueue.main.async {
                completion?(false)
            }
            return
        }
        image = nil
        
        //check cache for image first
        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = cachedImage
            DispatchQueue.main.async {
                completion?(true)
                return
            }
        }
        
        //otherwise, start a new download
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion?(false)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil, let data = data, let downloadedImage = UIImage(data: data) else {
                    completion?(false)
                    return
                }
                UIImageView.imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                self?.image = downloadedImage
                completion?(true)
            }
        }.resume()
    }
    
}

