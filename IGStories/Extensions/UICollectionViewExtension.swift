//
//  UICollectionViewExtension.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

extension UICollectionView {
    func sb_registerCell(_ cellClass: AnyClass) {
        register(UINib(nibName: String(describing: cellClass.self),
                       bundle: nil),
                 forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
    
    func sb_dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                   for: indexPath) as! T
    }
}
