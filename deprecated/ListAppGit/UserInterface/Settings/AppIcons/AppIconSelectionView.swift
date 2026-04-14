//
//  AppIconSelectionView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-24.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit


class AppIconSelectionView: UIViewController {

    var myCollectionView:UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App Icon"

        setup()
        setUpTheming()
        setUpFont()
    }

    private let iconSelectionCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 80, height: 120)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 30

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear


        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()


}

extension AppIconSelectionView {
    func setup() {


        let view = UIView()
        view.addSubview(iconSelectionCollectionView)
        NSLayoutConstraint.activate([
            iconSelectionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iconSelectionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iconSelectionCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            iconSelectionCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70)
        ])

        iconSelectionCollectionView.register(changeIconCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        iconSelectionCollectionView.dataSource = self
        iconSelectionCollectionView.delegate = self
        self.view = view
    }
}

extension AppIconSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlternateIcons.alternateIcons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! changeIconCollectionViewCell
        myCell.viewModel = changeIconCollectionViewCellViewModel(colourName: AlternateIcons.alternateIcons[indexPath.row])
        return myCell
    }
}
extension AppIconSelectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UIApplication.shared.supportsAlternateIcons {
            let iconName = indexPath.row == 0 ? nil : AlternateIcons.alternateIcons[indexPath.row] + "Icon"
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("App Icon changed!")
                }
            }
        }
    }
}


extension AppIconSelectionView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.view.backgroundColor = theme.secondaryBackgroundColor
    }
}

extension AppIconSelectionView: FontProtocol {
    func applyFont(_ font: AppFont) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: font.mediumFontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: themeProvider.currentTheme.textColor
        ]

        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: font.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: self.themeProvider.currentTheme.textColor
        ],
        for: .normal)
        self.iconSelectionCollectionView.reloadData()
    }
}
