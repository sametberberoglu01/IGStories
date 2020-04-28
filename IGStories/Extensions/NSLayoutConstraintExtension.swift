//
//  NSLayoutConstraintExtension.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

extension NSLayoutYAxisAnchor {
    @discardableResult
    func sb_constraint(equalTo anchor: NSLayoutYAxisAnchor, constant: Int = 0) -> NSLayoutConstraint {
        let c = constraint(equalTo: anchor, constant: CGFloat(constant))
        c.isActive = true
        return c
    }
    
    @discardableResult
    func sb_constraint(greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: Int = 0) -> NSLayoutConstraint {
        let c = constraint(greaterThanOrEqualTo: anchor, constant: CGFloat(constant))
        c.isActive = true
        return c
    }
    
    @discardableResult
    func sb_constraint(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: Int = 0) -> NSLayoutConstraint {
        let c = constraint(lessThanOrEqualTo: anchor, constant: CGFloat(constant))
        c.isActive = true
        return c
    }
}

extension NSLayoutXAxisAnchor {
    @discardableResult
    func sb_constraint(equalTo anchor: NSLayoutXAxisAnchor, constant: Int = 0) -> NSLayoutConstraint {
        let c = constraint(equalTo: anchor, constant: CGFloat(constant))
        c.isActive = true
        return c
    }
    
    @discardableResult
    func sb_constraint(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: Int = 0) -> NSLayoutConstraint {
        let c = constraint(greaterThanOrEqualTo: anchor, constant: CGFloat(constant))
        c.isActive = true
        return c
    }
    
    @discardableResult
    func sb_constraint(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: Int = 0) -> NSLayoutConstraint {
        let c = constraint(lessThanOrEqualTo: anchor, constant: CGFloat(constant))
        c.isActive = true
        return c
    }
}

extension NSLayoutDimension {
    @discardableResult
    func sb_constraint(equalToConstant constant: Int) -> NSLayoutConstraint {
        let c = constraint(equalToConstant: CGFloat(constant))
        c.isActive = true
        return c
    }
    
    @discardableResult
    func sb_constraint(equalTo anchor: NSLayoutDimension, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let c = constraint(equalTo: anchor, multiplier: multiplier)
        c.isActive = true
        return c
    }
}
