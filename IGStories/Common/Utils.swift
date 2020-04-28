//
//  Utils.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

typealias SuccessCompletion = (Bool) -> Void

class Utils {
    
    class var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    class var safeAreaSize: CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - (Utils.safeAreaInsets.left + Utils.safeAreaInsets.right)
        let height: CGFloat = UIScreen.main.bounds.height - (Utils.safeAreaInsets.top + Utils.safeAreaInsets.bottom)
        return CGSize.init(width: width, height: height)
    }
    
}
