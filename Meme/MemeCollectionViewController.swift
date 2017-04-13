//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Netaround Developer on 4/13/17.
//
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    struct Identifier {
        static let memeCollectionCell = "MemeCollectionViewCell"
        static let memeEditorNavigationController = "MemeEditorNavigationController"
        static let memeDetailViewController = "MemeDetailViewController"
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        let space: CGFloat = 3.0
        let dimesion = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimesion, height: dimesion)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NotificationKeyMemesUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemes), name: NSNotification.Name(rawValue: "NotificationKeyMemesUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Events reponse
    
    @IBAction fileprivate func didTapAddMeme() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editorViewController = storyboard.instantiateViewController(withIdentifier: Identifier.memeEditorNavigationController)
        present(editorViewController, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegate & UICollectionViewDatasource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.memeCollectionCell, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Identifier.memeDetailViewController) as! MemeDetailViewController
        detailViewController.memedImage = memes[indexPath.row].memedImage
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Private methods
    
    @objc fileprivate func reloadMemes() {
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
        collectionView?.reloadData()
    }
}
