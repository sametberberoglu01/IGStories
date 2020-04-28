//
//  StoryViewController.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

class StoryViewController: BaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    private var index = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    class func create(for index: Int) -> StoryViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "StoryViewController") as! StoryViewController
        vc.index = index
        return vc
    }
    
    private func setupUI() {
        collectionView.sb_registerCell(StoryCollectionViewCell.self)
        
        if let layout = collectionView?.collectionViewLayout as? CubeAnimatedCollectionViewLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = StoryCollectionViewCell.size
            layout.sectionInset = .zero
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
        }
        
        let downGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        downGestureRecognizer.direction = .down
        view.addGestureRecognizer(downGestureRecognizer)
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil) { [weak self] (_) in
            guard let self = self, self.index != 0 else { return }
            self.collectionView.scrollToItem(at: IndexPath(item: self.index, section: 0), at: .right, animated: false)
        }
    }
    
    //MARK: Gestures
    @objc private func swipedDown() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: UICollectionViewDelegate
extension StoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? StoryCollectionViewCell else { return }
        cell.stopPlayer()
    }
}

//MARK: UICollectionViewDataSource
extension StoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoryManager.shared.stories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoryCollectionViewCell = collectionView.sb_dequeueCell(for: IndexPath(item: index, section: 0))
        cell.configure(for: StoryManager.shared.stories?[indexPath.item], index: indexPath.item, delegate: self)
        return cell
    }
}

//MARK: StoryCollectionViewCellDelegate
extension StoryViewController: StoryCollectionViewCellDelegate {
    func storyCollectionViewCellDidTappedCloseButton(_ storyCollectionViewCell: StoryCollectionViewCell) {
        dismiss(animated: true, completion: nil)
    }
    
    func storyCollectionViewCell(_ storyCollectionViewCell: StoryCollectionViewCell, shoulShowNextStoryAt index: Int) {
        self.index = index
        if index >= collectionView.numberOfItems(inSection: 0) {
            dismiss(animated: true, completion: nil)
            return
        }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
    }
    
    func storyCollectionViewCell(_ storyCollectionViewCell: StoryCollectionViewCell, shoulShowPreviousStoryAt index: Int) {
        self.index = index
        if index < 0 { return }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
    }
}

