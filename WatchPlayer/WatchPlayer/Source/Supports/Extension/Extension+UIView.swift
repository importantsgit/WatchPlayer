//
//  Extension+UIView.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

extension UIView {
    static func setAnimation(
        time: Double = 0.3,
        animations: @autoclosure @escaping ()->Void,
        _ completions: ((Bool)->Void)? = nil
    ) {
        self.animate(withDuration: time, animations: animations, completion: completions)
    }

    static func setAnimation(
        time: Double = 0.3,
        animations: @escaping ()->Void,
        _ completions: ((Bool)->Void)? = nil
    ) {
        self.animate(withDuration: time, animations: animations, completion: completions)
    }

}

