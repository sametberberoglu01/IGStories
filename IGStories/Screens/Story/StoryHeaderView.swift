//
//  StoryHeaderView.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

protocol StoryHeaderViewDelegate: class {
    func storyHeaderViewDidTappedCloseButton(_ storyHeaderView: StoryHeaderView)
    func storyHeaderView(_ storyHeaderView: StoryHeaderView, didCompletedDisplayingStoryAt index: Int)
}

class StoryHeaderView: UIView {
    
    private enum Constants {
        static let timerInterval: CGFloat = 0.2
    }
    
    private weak var delegate: StoryHeaderViewDelegate?
    private var progressViews = [UIView]()
    private var story: Story?
    private var progressBarWidthConstraints = [NSLayoutConstraint]()
    
    private var timerCounter = 0
    private var timerCounterMaxValue = 0
    private var isTimerPaused = false
    private var timerDuration = 0
    private var timerIndex = 0
    
    private lazy var timer: Timer = {
        return Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval),
                                    target: self,
                                    selector: #selector(timerTicked),
                                    userInfo: nil, repeats: true)
    }()
    
    //MARK: UIElements
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icClose"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 3.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.sb_roundAllCorners()
        profileImageView.sb_addBorder(size: 1, color: .white)
    }
    
    private func setupUI() {
        sb_addPinnedView(progressStackView,
                         edgeInsets: SBEdgeInsets(top: 2, left: 8, bottom: nil, right: 8),
                         size: SBSize(width: nil, height: 5))
        sb_addPinnedView(profileImageView,
                         edgeInsets: SBEdgeInsets(top: 10, left: 8, bottom: nil, right: nil),
                         size: SBSize(width: 45, height: 45))
        sb_addPinnedView(usernameLabel, edgeInsets: SBEdgeInsets(top: 16, left: 60, bottom: nil, right: 8))
        sb_addPinnedView(timeLabel, edgeInsets: SBEdgeInsets(top: nil, left: 60, bottom: 15, right: 8))
        sb_addPinnedView(closeButton, edgeInsets: SBEdgeInsets(top: 12, left: nil, bottom: nil, right: 12), size: SBSize(width: 30, height: 30))
        
    }
    
    //MARK: Public Methods
    func configure(for story: Story?, delegate: StoryHeaderViewDelegate?) {
        self.story = story
        self.delegate = delegate
        
        usernameLabel.text = story?.user?.username
        timeLabel.text = story?.userStories?.first?.lastUpdated
        profileImageView.sb_loadImageUsingCache(withUrlString: story?.user?.profilePhotoUrl)
        
        progressStackView.subviews.forEach( {$0.removeFromSuperview()} )
        progressBarWidthConstraints.removeAll()
        for _ in 0..<(story?.userStories?.count ?? 0) {
            progressStackView.addArrangedSubview(generateProgressView())
        }
    }
    
    func startTimer(for index: Int, previousIndex: Int?, duration: Int) {
        if let prevIndex = previousIndex {
            progressBarWidthConstraints[prevIndex].constant = 0.0
            UIView.animate(withDuration: 0.1) {
                self.progressStackView.subviews[index].layoutIfNeeded()
            }
        }
        timerCounter = 0
        timerDuration = duration
        timerIndex = index
        timerCounterMaxValue = duration * Int(1.0 / Constants.timerInterval)
        timer.fire()
    }
    
    func pauseTimer(for index: Int) {
        isTimerPaused = true
    }
    
    func resumeTimer(for index: Int) {
        isTimerPaused = false
    }
    
    func completeTimer(for index: Int) {
        progressBarWidthConstraints[index].constant = progressBarWidth
        UIView.animate(withDuration: 0.1) {
            self.progressStackView.subviews[index].layoutIfNeeded()
        }
    }
    
    //MARK: Helpers
    private func generateProgressView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        containerView.sb_roundAllCorners(radius: 2)
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.sb_addPinnedView(view, edgeInsets: SBEdgeInsets(top: 0, left: 0, bottom: 0, right: nil))
        progressBarWidthConstraints.append(view.widthAnchor.sb_constraint(equalToConstant: 0))
        view.backgroundColor = .white
        view.sb_roundAllCorners(radius: 2)
        return containerView
    }
    
    private var progressBarWidth: CGFloat {
        let storyCount = CGFloat(story?.userStories?.count ?? 0)
        return (Utils.safeAreaSize.width - (16.0 + ((storyCount - 1) * 3.0))) / storyCount
    }
    
    private var frameWidthOfProgressBar: CGFloat {
        return progressBarWidth / CGFloat(timerCounterMaxValue)
    }
    
    @objc private func closeButtonTapped() {
        delegate?.storyHeaderViewDidTappedCloseButton(self)
    }
    
    @objc private func timerTicked() {
        if isTimerPaused { return }
        if timerCounter >= timerCounterMaxValue {
            delegate?.storyHeaderView(self, didCompletedDisplayingStoryAt: timerIndex)
            return
        }
        timerCounter += 1
        let width = CGFloat(timerCounter) * frameWidthOfProgressBar
        progressBarWidthConstraints[timerIndex].constant = width
        UIView.animate(withDuration: 0.2) {
            self.progressStackView.subviews[self.timerIndex].layoutIfNeeded()
        }
    }
    
    deinit {
        timer.invalidate()
    }
}

