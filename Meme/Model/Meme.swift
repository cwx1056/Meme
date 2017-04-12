//
//  Meme.swift
//  Meme
//
//  Created by Tech Netaround on 4/4/17.
//
//

import UIKit

struct Meme {

    // MARK: -
    // MARK: Properties
    
    fileprivate(set) var topText: String
    fileprivate(set) var bottomText: String
    fileprivate(set) var originalImage: UIImage
    fileprivate(set) var memedImage: UIImage
    
    // MARK: -
    // MARK: Initialization
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}
