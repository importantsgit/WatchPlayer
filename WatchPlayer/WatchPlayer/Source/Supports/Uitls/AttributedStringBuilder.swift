//
//  AttributedStringBuilder.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/27/24.
//

import UIKit

final class NSAttributedStringBuilder {
    var string: AttributedString = .init()

    func add(
        string: String,
        color: UIColor = .primary,
        font: UIFont = .systemFont(ofSize: 16),
        lineHeight: CGFloat? = nil
    ) -> Self {
        
        var addString = AttributedString(string)
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = lineHeight != nil ? lineHeight! : font.pointSize * 1.2
        style.maximumLineHeight = lineHeight != nil ? lineHeight! : font.pointSize * 1.2
        
        addString.setAttributes(.init([
            .font: font,
            .foregroundColor: color,
            .baselineOffset: ((lineHeight != nil ? lineHeight! : font.pointSize * 1.2) - font.pointSize) / 2,
            .paragraphStyle: style
        ]))

        self.string.append(addString)
        
        return self
    }
    
    func buildNSAttributedString(
    ) -> NSAttributedString {
        string.getNSAttributedString()
    }
    
    func build(
    ) -> AttributedString {
        string
    }
}

fileprivate extension AttributedString {
    func getNSAttributedString(
    )-> NSAttributedString {
        NSAttributedString(self)
    }
}
