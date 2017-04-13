//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Netaround Developer on 4/13/17.
//
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    struct Identifier {
        static let memeTableCell = "MemeTableViewCell"
        static let memeEditorNavigationController = "MemeEditorNavigationController"
        static let memeDetailViewController = "MemeDetailViewController"
    }
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        tableView.separatorStyle = .none
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
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.memeTableCell, for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        cell.memeTextLabel.text = "\(meme.topText)...\(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Identifier.memeDetailViewController) as! MemeDetailViewController
        detailViewController.memedImage = memes[indexPath.row].memedImage
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Private methods
    
    @objc fileprivate func reloadMemes() {
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
        tableView.reloadData()
    }
    
    
}
