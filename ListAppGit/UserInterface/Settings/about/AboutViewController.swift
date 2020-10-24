//
//  AboutViewController.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-19.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleHeader: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Listy"
        return label
    }()

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "👋 Hi, I'm Cristian Palage\n\nI'm a student studying Computer Science at the University of Waterloo in Waterloo, Ontario by day and musician and indie dev by night.\n\nI developed Listy originally for myself. I wanted a simple List app that takes advantage of all the wonderful integrations iOS has to to offer in an way that worked with my brain. After a seemingly endless and futile search I gave up and made my own.\n\nI'd love to hear what you think! You can reach out to me on Twitter or send me an Email.\n\nIf you like the app, please tell a friend, or leave a review on the app store!"
        return tv
    }()


    override func viewDidLoad() {
        setUpFont()
        setUpTheming()

        super.viewDidLoad()
        self.view.addSubview(containerView)
        containerView.addSubview(titleHeader)
        containerView.addSubview(textView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            titleHeader.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleHeader.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18)
        ])
    }


}

// MARK: set up methods

extension AboutViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        containerView.backgroundColor = theme.backgroundColor
        textView.textColor = theme.textColor
        textView.backgroundColor = .clear

        titleHeader.textColor = theme.textColor
    }
}

extension AboutViewController: FontProtocol {
    func applyFont(_ font: AppFont) {
        titleHeader.font = font.mediumFontValue().withSize(28)
        textView.font = font.fontValue().withSize(15)
    }
}


