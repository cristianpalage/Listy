//
//  ListyUITextField.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-12.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

// MARK: - ListyTextField

@IBDesignable
open class ListyTextField: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        setUpTheming()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
}

extension ListyTextField: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.attributedPlaceholder = NSAttributedString(string:"Enter list name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
    }
}
