//
//  UIImageExtension.swift
//  WeatherApp
//
//  Created by APPLE on 07.08.22.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromWeb(urlString : String, placeHolderImage : UIImage) {
        if self.image == nil {
            self.image = placeHolderImage
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data,_,error ) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: {() -> Void in
                let image = UIImage(data : data!)
                self.image = image
            })
            
        }).resume()
    }
}
