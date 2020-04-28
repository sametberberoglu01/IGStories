//
//  UIViewExtension.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

struct SBEdgeInsets {
    var top: CGFloat?
    var left: CGFloat?
    var bottom: CGFloat?
    var right: CGFloat?
    
    static let zero = SBEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static let topZero = SBEdgeInsets(top: 0, left: 0, bottom: nil, right: 0)
    static let bottomZero = SBEdgeInsets(top: nil, left: 0, bottom: 0, right: 0)
    
    init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}

struct SBSize {
    var width: CGFloat?
    var height: CGFloat?
    
    static let zero = SBSize(width: 0, height: 0)
    
    init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width
        self.height = height
    }
}

extension UIView {
    
    func sb_roundAllCorners(radius: CGFloat? = nil) {
        layer.cornerRadius = 0.0
        clipsToBounds = false
        var conerRadius: CGFloat = 0.0
        if let radius = radius {
            conerRadius = radius
        } else {
            conerRadius = frame.height / 2.0
        }
        layer.cornerRadius = conerRadius
        clipsToBounds = true
    }
    
    func sb_addBorder(size: Int, color: UIColor) {
        layer.borderWidth = CGFloat(size)
        layer.borderColor = color.cgColor
    }
    
    func sb_addPinnedView(_ view: UIView, edgeInsets: SBEdgeInsets? = .zero, size: SBSize? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        if let left = edgeInsets?.left {
            view.leftAnchor.sb_constraint(equalTo: leftAnchor, constant: Int(left))
        }
        
        if let right = edgeInsets?.right {
            view.rightAnchor.sb_constraint(equalTo: rightAnchor, constant: Int(-right))
        }
        
        if let top = edgeInsets?.top {
            view.topAnchor.sb_constraint(equalTo: topAnchor, constant: Int(top))
        }
        
        if let bottom = edgeInsets?.bottom {
            view.bottomAnchor.sb_constraint(equalTo: bottomAnchor, constant: Int(-bottom))
        }
        
        if let width = size?.width {
            view.widthAnchor.sb_constraint(equalToConstant: Int(width))
        }
        
        if let height = size?.height {
            view.heightAnchor.sb_constraint(equalToConstant: Int(height))
        }
    }
    
}

//MARK: Cube Animation
extension UIView {
    func keepCenterAndApplyAnchorPoint(_ point: CGPoint) {
        guard layer.anchorPoint != point else { return }
        
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var layerPosition = layer.position
        layerPosition.x -= oldPoint.x
        layerPosition.x += newPoint.x
        
        layerPosition.y -= oldPoint.y
        layerPosition.y += newPoint.y
        
        layer.position = layerPosition
        layer.anchorPoint = point
    }
}
