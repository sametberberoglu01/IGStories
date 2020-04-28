//
//  AVPlayerLayer.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import AVKit

extension AVPlayerLayer {
    var sb_videoDuration: Int {
        let value = Double(player?.currentItem?.asset.duration.value ?? CMTimeValue(0))
        let timeScale = Double(player?.currentItem?.asset.duration.timescale ?? CMTimeScale(0))
        return Int(ceil(value / timeScale))
    }
}
