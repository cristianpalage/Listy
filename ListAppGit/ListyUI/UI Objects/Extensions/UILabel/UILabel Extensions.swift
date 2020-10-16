//
//  UILabel Extensions.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-12.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

// MARK: UILabel+Spacing

extension UILabel {
    public func applySpacing(withCharacterSpacing characterSpacing: CGFloat? = nil, lineHeight: CGFloat? = nil) {
            let attributedString = createMutableAttributedString()
            let range = NSRange(location: 0, length: attributedString.length)

            if let characterSpacing = characterSpacing {
                attributedString.addAttribute(.kern, value: characterSpacing, range: range)
            }

            if let lineHeight = lineHeight {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = lineHeight
                paragraphStyle.alignment = textAlignment
                paragraphStyle.lineBreakMode = lineBreakMode
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }

            attributedText = attributedString
        }
}

// MARK: Private Methods

private extension UILabel {

    func createMutableAttributedString() -> NSMutableAttributedString {
        if let attributedText = attributedText {
            return NSMutableAttributedString(attributedString: attributedText)
        } else {
            return NSMutableAttributedString(string: text ?? "")
        }
    }
}
