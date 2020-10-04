//
//  ListDetailsDeadlineTableViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-13.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct ListDetailsDeadlineTableViewCellViewModel {
    var list: Node

    init(list: Node) {
        self.list = list
    }
}

class ListDetailsDeadlineTableViewCell: UITableViewCell {

    //let datePicker = UIDatePicker()
    var toolBar = UIToolbar()

    var datePicker = UIDatePicker()

    var viewModel: ListDetailsDeadlineTableViewCellViewModel? {
        didSet { setupViewModel() }
    }

    let textField: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let header: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


private extension ListDetailsDeadlineTableViewCell {
    func setup() {
        showDatePicker()

        contentView.addSubview(textField)
        contentView.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func setupViewModel() {
        if let deadline = viewModel?.list.deadline {
            textField.text = dateFormatter(date: deadline)
        } else {
            textField.text = "No deadline set"
        }
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker){

        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()

        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"

        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)

        print("Selected value \(selectedDate)")
    }

    func showDatePicker() {

        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: Selector(("doneClick")))
        doneButton.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: Selector(("cancelClick")))
        cancelButton.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        // Adds the toolbar to the view
        self.datePicker.date = .init(timeIntervalSinceNow: 0)
        self.textField.inputView = datePicker
        self.textField.inputAccessoryView = toolBar

    }

    @objc func doneClick() {
        textField.text = dateFormatter(date: datePicker.date)
        self.viewModel?.list.deadline = datePicker.date
        textField.resignFirstResponder()
    }

    @objc func cancelClick() {
        textField.resignFirstResponder()
        self.datePicker.date = .init(timeIntervalSinceNow: 0)
    }
}

