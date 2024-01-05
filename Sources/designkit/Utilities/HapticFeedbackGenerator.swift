//
//  File.swift
//  
//
//  Created by Joschua Marz on 05.01.24.
//

import UIKit

public struct HapticFeedbackType {
    
    var generator: HapticFeedbackGenerator
    
    private init(generator: HapticFeedbackGenerator) {
        generator.prepare()
        self.generator = generator
    }
    
    public static func selection() -> HapticFeedbackType {
        return HapticFeedbackType(generator: UISelectionFeedbackGenerator())
    }
    
    public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> HapticFeedbackType {
        return HapticFeedbackType(generator: UIImpactFeedbackGenerator(style: style))
    }
}

public protocol HapticFeedbackGenerator {
    func prepare()
    func generateFeedback()
}

extension UISelectionFeedbackGenerator: HapticFeedbackGenerator {
    public func generateFeedback() {
        self.selectionChanged()
    }
}

extension UIImpactFeedbackGenerator: HapticFeedbackGenerator {
    public func generateFeedback() {
        self.impactOccurred()
    }
}
