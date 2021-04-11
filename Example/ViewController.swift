//
//  ViewController.swift
//  Example
//
//  Created by Pavel Moslienko on 10 апр. 2021 г..
//  Copyright © 2021 moslienko. All rights reserved.
//

import UIKit
import SwiftModalPicker

// MARK: - ViewController

/// The ViewController
class ViewController: UIViewController {
    
    // MARK: Properties
    private var items: [ButtonType] = ButtonType.allCases
    private var reuseIdentifier = "PickerExampleTableCell"
    private var lastPickerValue: String?
    
    /// The Label
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.tableHeaderView = UIView()
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    // MARK: View-Lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    /// LoadView
    override func loadView() {
        self.view = self.tableView
    }
    
}


// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: self.reuseIdentifier)
        cell.textLabel?.text = self.items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.lastPickerValue
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        switch item {
        case .date:
            self.showDatePicker()
        case .time:
            self.showTimePicker()
        case .darkThemeDate:
            self.showDarkDatePicker()
        case .fruit:
            self.showFruitPicker()
        case .miltiItem:
            self.showMultiComponentPicker()
        }
    }
    
}

extension ViewController {
    
    private func showDatePicker() {
        let button = UIBarButtonItem(title: "Remove date", style: .plain, target: self, action: #selector(self.removeDate))
        let pickerToolbarButtons: [SwiftModalPicker.ToolbarButton] = [
            .cancel(title: "Cancel"),
            .custom(button: button),
            .space,
            .done
        ]
        
        
        let pickerViewPresenter = SwiftModalPicker(type: .calendar(params: SwiftModalPicker.CalendarParams(selectedDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .date, timeZone: .current)), toolbarItems: pickerToolbarButtons)
        
        pickerViewPresenter.onDatePickerDone = { date in
            print("date - \(date)")
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            self.lastPickerValue = formatter.string(from: date)
            
            self.tableView.reloadData()
        }
        
        pickerViewPresenter.onPickerClosed = {
            print("closed")
        }
        
        pickerViewPresenter.showPicker(from: self.view)
    }
    
    private func showTimePicker() {
        let pickerToolbarButtons: [SwiftModalPicker.ToolbarButton] = [
            .cancel(title: "Cancel"),
            .space,
            .done
        ]
        
        let pickerViewPresenter = SwiftModalPicker(type: .calendar(params: SwiftModalPicker.CalendarParams(selectedDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .time, timeZone: .current)), toolbarItems: pickerToolbarButtons)
        pickerViewPresenter.onDatePickerDone = { date in
            print("time - \(date)")
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.lastPickerValue = formatter.string(from: date)
            
            self.tableView.reloadData()
        }
        pickerViewPresenter.showPicker(from: self.view)
    }
    
    private func showDarkDatePicker() {
        let pickerToolbarButtons: [SwiftModalPicker.ToolbarButton] = [
            .cancel(title: "Cancel"),
            .space,
            .done
        ]
        
        
        let pickerViewPresenter = SwiftModalPicker(type: .calendar(params: SwiftModalPicker.CalendarParams(selectedDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .date, timeZone: .current)), toolbarItems: pickerToolbarButtons)
        pickerViewPresenter.viewTintColor = .red
        pickerViewPresenter.pickerBackgroundColor = .black
        pickerViewPresenter.pickerColor = .white
        pickerViewPresenter.toolbarBackgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        pickerViewPresenter.onDatePickerDone = { date in
            print("date - \(date)")
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            self.lastPickerValue = formatter.string(from: date)
            
            self.tableView.reloadData()
        }
        
        pickerViewPresenter.showPicker(from: self.view)
    }
    
    private func showFruitPicker() {
        let pickerToolbarButtons: [SwiftModalPicker.ToolbarButton] = [
            .cancel(title: "Cancel"),
            .space,
            .done
        ]
        
        let items = ["Apple", "Avocado", "Banana", "Blackberries"]
        let pickerViewPresenter = SwiftModalPicker(type: .custom(items: items, selectedIndex: 2), toolbarItems: pickerToolbarButtons)
        pickerViewPresenter.onPickerDone = { (val, index) in
            print("onPickerDone - \(val) on \(index)")
            self.lastPickerValue = val
            
            self.tableView.reloadData()
        }
        
        pickerViewPresenter.showPicker(from: self.view)
    }
    
    private func showMultiComponentPicker() {
        let label = UILabel(frame: .zero)
        label.text = "Title for picker"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        let pickerTitle = UIBarButtonItem(customView: label)
        
        let pickerToolbarButtons: [SwiftModalPicker.ToolbarButton] = [
            .cancel(title: "Cancel"),
            .space,
            .custom(button: pickerTitle),
            .space,
            .done
        ]
        
        let items = [["iPhone", "iPad", "MacBook", "Mac mini"], ["AirPods", "AirPods Pro", "AirPods Max"]]
        let pickerViewPresenter = SwiftModalPicker(type: .customWithMultiRows(items: items, selectedIndexes: [2, 1]), toolbarItems: pickerToolbarButtons)
        
        pickerViewPresenter.onPickerMiltiComponentsDone = { (values, indexes) in
            print("onPickerDone - \(values) on \(indexes)")
            self.lastPickerValue = values.joined(separator: ", ")
            
            self.tableView.reloadData()
        }
        
        pickerViewPresenter.showPicker(from: self.view)
    }
    
    @objc
    private func removeDate() {
        self.view.getActiveSwiftModalPicker()?.close()
        
        self.lastPickerValue = nil
        self.tableView.reloadData()
    }
    
}
