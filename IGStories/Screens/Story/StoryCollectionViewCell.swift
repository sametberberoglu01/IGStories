//
//  StoryCollectionViewCell.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import AVKit

protocol StoryCollectionViewCellDelegate: class {
    func storyCollectionViewCellDidTappedCloseButton(_ storyCollectionViewCell: StoryCollectionViewCell)
    func storyCollectionViewCell(_ storyCollectionViewCell: StoryCollectionViewCell, shoulShowNextStoryAt index: Int)
    func storyCollectionViewCell(_ storyCollectionViewCell: StoryCollectionViewCell, shoulShowPreviousStoryAt index: Int)
}

class StoryCollectionViewCell: UICollectionViewCell {
    
    static let size = Utils.safeAreaSize

    @IBOutlet private weak var headerView: StoryHeaderView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var videoPlayerView: UIView!
    @IBOutlet private weak var gesturesContainerView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private weak var delegate: StoryCollectionViewCellDelegate?
    
    private var story: Story?
    private var currentIndex = 0
    private var userStoryIndex = 0
    
    private lazy var videoPlayerLayer: AVPlayerLayer = {
        guard let urlString = story?.userStories?[currentIndex].url,
            let url = URL(string: urlString) else {
                return AVPlayerLayer()
        }
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: StoryCollectionViewCell.size)
        return playerLayer
    }()
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.delaysTouchesBegan = true
        gesturesContainerView.addGestureRecognizer(longPressGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        gesturesContainerView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Gestures
    @objc private func handleLongGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            headerView.pauseTimer(for: currentIndex)
            videoPlayerLayer.player?.pause()
        } else if sender.state == .ended {
            headerView.resumeTimer(for: currentIndex)
            videoPlayerLayer.player?.play()
        }
    }
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.location(in: self).x > StoryCollectionViewCell.size.width / 2.0 {
            headerView.completeTimer(for: currentIndex)
            showNextStory(after: currentIndex)
        } else {
            showPreviousStory(before: currentIndex)
        }
    }

    //MARK: Public Methods
    func configure(for story: Story?, index: Int, delegate: StoryCollectionViewCellDelegate?) {
        self.story = story
        self.delegate = delegate
        self.userStoryIndex = index
        headerView.configure(for: story, delegate: self)
        videoPlayerView.layer.addSublayer(videoPlayerLayer)
        stopPlayer()
        showStory(at: 0, previousIndex: nil)
    }
    
    func stopPlayer() {
        if let player = videoPlayerLayer.player {
            player.pause()
            videoPlayerLayer.player = nil
        }
    }
    
    //MARK: Helpers
    private func showStory(at index: Int, previousIndex: Int?) {
        currentIndex = index
        let mediaType = story?.userStories?[index].type ?? .image
        imageView.isHidden = mediaType == .video
        videoPlayerView.isHidden = mediaType == .image
        errorLabel.isHidden = true
        stopPlayer()
        switch mediaType  {
        case .image:
            imageView.sb_loadImageUsingCache(withUrlString: story?.userStories?[index].url) { [weak self] (success) in
                guard let self = self else { return }
                self.errorLabel.isHidden = success
                self.headerView.startTimer(for: index, previousIndex: previousIndex, duration: 5)
            }
        case .video:
            startPlayer(with: story?.userStories?[index].url)
            self.headerView.startTimer(for: index, previousIndex: previousIndex, duration: videoPlayerLayer.sb_videoDuration)
        }
    }
    
    private func showNextStory(after index: Int) {
        let totalStoryCount = story?.userStories?.count ?? 0
        if index < totalStoryCount - 1 {
            currentIndex = index + 1
            showStory(at: currentIndex, previousIndex: nil)
        } else {
            delegate?.storyCollectionViewCell(self, shoulShowNextStoryAt: userStoryIndex + 1)
        }
    }
    
    private func showPreviousStory(before index: Int) {
        if index > 0 {
            currentIndex = index - 1
            showStory(at: currentIndex, previousIndex: index)
        } else {
            delegate?.storyCollectionViewCell(self, shoulShowPreviousStoryAt: userStoryIndex - 1)
        }
    }
    
    private func startPlayer(with urlString: String?) {
        if let player = videoPlayerLayer.player {
            player.pause()
            stopPlayer()
            startPlayer(with: urlString)
        } else {
            guard let urlStr = urlString, let url = URL(string: urlStr) else { return }
            let player = AVPlayer(url: url)
            videoPlayerLayer.player = player
            videoPlayerLayer.player?.play()
        }
    }
    
    deinit {
        stopPlayer()
    }
}

//MARK: StoryHeaderViewDelegate
extension StoryCollectionViewCell: StoryHeaderViewDelegate {
    func storyHeaderView(_ storyHeaderView: StoryHeaderView, didCompletedDisplayingStoryAt index: Int) {
        showNextStory(after: index)
    }
    
    func storyHeaderViewDidTappedCloseButton(_ storyHeaderView: StoryHeaderView) {
        delegate?.storyCollectionViewCellDidTappedCloseButton(self)
    }
}

