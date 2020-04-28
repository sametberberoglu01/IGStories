//
//  MainViewController.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    class func create() -> MainViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        return vc
    }

    private func setupUI() {
        collectionView.sb_registerCell(StoriesCollectionViewCell.self)
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.itemSize = StoriesCollectionViewCell.size
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        StoryManager.shared.loadStories()
    }
}

//MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyViewController = StoryViewController.create(for: indexPath.item)
        present(storyViewController, animated: true, completion: nil)
    }
}

//MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoryManager.shared.stories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoriesCollectionViewCell = collectionView.sb_dequeueCell(for: indexPath)
        cell.configure(with: StoryManager.shared.stories?[indexPath.item].user)
        return cell
    }
    
}



