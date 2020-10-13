//
//  listyUILabel.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-12.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

// MARK: - ListyLabel

@IBDesignable
open class ListyLabel: UILabel {

    /// Whether the label should set `isHidden` to true when it's text is empty or nil.
    @IBInspectable
    open var shouldAutoHide: Bool = false {
        didSet {
            checkAutoHide()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        self.font = UIFont(name: "NewYork-Regular", size: self.font.pointSize)
        checkAutoHide()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
}

// MARK: Private Methods

private extension ListyLabel {

    func checkAutoHide() {
        guard shouldAutoHide else { return }

        isHidden = (text?.isEmpty ?? true) && (attributedText?.length ?? 0) == 0
    }
}
