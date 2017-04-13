//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Netaround Developer on 4/13/17.
//
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var memedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = memedImage
    }


}
