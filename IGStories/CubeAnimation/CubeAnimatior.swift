//
//  CubeAnimatior.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

class CubeAnimator {
    
    private var perspective: CGFloat
    private var totalAngle: CGFloat
    
    init(perspective: CGFloat = -1 / 500, totalAngle: CGFloat = .pi / 2) {
        self.perspective = perspective
        self.totalAngle = totalAngle
    }
    
    func animate(collectionView: UICollectionView, attributes: CubeAnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset
        if abs(position) >= 1 {
            attributes.contentView?.layer.transform = CATransform3DIdentity
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        } else if attributes.scrollDirection == .horizontal {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, 0, 1, 0)
            
            attributes.contentView?.layer.transform = transform
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: position > 0 ? 0 : 1, y: 0.5))
        } else {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, -1, 0, 0)
            
            attributes.contentView?.layer.transform = transform
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: 0.5, y: position > 0 ? 0 : 1))
        }
    }
}

