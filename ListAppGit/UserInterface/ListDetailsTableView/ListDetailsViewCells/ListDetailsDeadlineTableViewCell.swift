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

    let datePicker = UIDatePicker()

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
        //contentView.addSubview(datePicker)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func setupViewModel() {
        if let deadline = viewModel?.list.deadline, deadline != "" {
            textField.text = deadline
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
        datePicker.datePickerMode = .dateAndTime

        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker

    }

    @objc func doneDatePicker(){

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        textField.text = formatter.string(from: datePicker.date)
        self.viewModel?.list.deadline = formatter.string(from: datePicker.date)
        self.datePicker.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.datePicker.endEditing(true)
    }
}

