//
//  PrivacyPolicyViewController.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-17.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

class PrivacyPolicyViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        tv.attributedText = NSAttributedString(
            string: "Listy takes your privacy very seriously. If you have opted to allow Apple to share information with developers we receive some anonymous analytics. Listy uses no other third party analytics tools or SDKs to track your activity in the app. In addition, every piece of infomation you input to the app, stays on your device at all times.",
            attributes: attributes
        )
        return tv
    }()

    override func viewDidLoad() {
        setUpFont()
        setUpTheming()

        super.viewDidLoad()
        self.view.addSubview(headerView)
        headerView.addSubview(textView)

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            textView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -18),
            textView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
        ])
    }


}

// MARK: set up methods

extension PrivacyPolicyViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.navigationController?.navigationBar.backgroundColor = theme.secondaryBackgroundColor
        headerView.backgroundColor = theme.backgroundColor
        textView.textColor = theme.textColor
        textView.backgroundColor = .clear
    }
}

extension PrivacyPolicyViewController: FontProtocol {
    func applyFont(_ font: AppFont) {
        textView.font = font.fontValue().withSize(17)
    }
}


