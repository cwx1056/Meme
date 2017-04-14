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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
}
