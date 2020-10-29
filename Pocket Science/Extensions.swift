//
//  Extensions.swift
//  Pocket Science
//
//  Created by Ethan Chew on 29/10/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import Foundation
import UIKit

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension UIView {
    func flashcardAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil, r2lDirection: Bool) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        if r2lDirection == true {
            leftToRightTransition.subtype = CATransitionSubtype.fromLeft
        } else {
            leftToRightTransition.subtype = CATransitionSubtype.fromRight
        }
        
        leftToRightTransition.type = CATransitionType.push
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        leftToRightTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
}

extension Array where Element: Equatable {
    func remove(_ obj: Element) -> [Element] {
        return filter { $0 != obj }
    }
}

extension UIColor {
    static let lowerPriColour = UIColor(red: 117, green: 170, blue: 230, alpha: 1.0)
    static let upperPriColour = UIColor(red: 86, green: 146, blue: 229, alpha: 1.0)
}
