//
//  AnimatedCollectionViewFlowLayout.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

class CubeAnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    
    private lazy var animator = CubeAnimator()
    
    override class var layoutAttributesClass: AnyClass { return CubeAnimatedCollectionViewLayoutAttributes.self }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        return attributes.compactMap { $0.copy() as? CubeAnimatedCollectionViewLayoutAttributes }.map { self.transformLayoutAttributes($0) }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func transformLayoutAttributes(_ attributes: CubeAnimatedCollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else { return attributes }
        
        let attributesCopy = attributes
        let distance: CGFloat
        let itemOffset: CGFloat
        
        if scrollDirection == .horizontal {
            distance = collectionView.frame.width
            itemOffset = attributesCopy.center.x - collectionView.contentOffset.x
            attributesCopy.startOffset = (attributesCopy.frame.origin.x - collectionView.contentOffset.x) / attributesCopy.frame.width
            attributesCopy.endOffset = (attributesCopy.frame.origin.x - collectionView.contentOffset.x - collectionView.frame.width) / attributesCopy.frame.width
        } else {
            distance = collectionView.frame.height
            itemOffset = attributesCopy.center.y - collectionView.contentOffset.y
            attributesCopy.startOffset = (attributesCopy.frame.origin.y - collectionView.contentOffset.y) / attributesCopy.frame.height
            attributesCopy.endOffset = (attributesCopy.frame.origin.y - collectionView.contentOffset.y - collectionView.frame.height) / attributesCopy.frame.height
        }
        
        attributesCopy.scrollDirection = scrollDirection
        attributesCopy.middleOffset = itemOffset / distance - 0.5
        
        if attributesCopy.contentView == nil,
            let cell = collectionView.cellForItem(at: attributes.indexPath)?.contentView {
            attributesCopy.contentView = cell
        }
        animator.animate(collectionView: collectionView, attributes: attributesCopy)
        return attributesCopy
    }
}

class CubeAnimatedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var contentView: UIView?
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    var startOffset: CGFloat = 0
    var middleOffset: CGFloat = 0
    var endOffset: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CubeAnimatedCollectionViewLayoutAttributes
        copy.contentView = contentView
        copy.scrollDirection = scrollDirection
        copy.startOffset = startOffset
        copy.middleOffset = middleOffset
        copy.endOffset = endOffset
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let o = object as? CubeAnimatedCollectionViewLayoutAttributes else { return false }
        
        return super.isEqual(o)
            && o.contentView == contentView
            && o.scrollDirection == scrollDirection
            && o.startOffset == startOffset
            && o.middleOffset == middleOffset
            && o.endOffset == endOffset
    }
}

