//
//  SwiftModalPicker.swift
//  SwiftModalPicker
//
//  Created by Pavel Moslienko on 07.02.2021.
//  Copyright © 2021 moslienko. All rights reserved.
//

// Include Foundation
@_exported import Foundation
import UIKit

public class SwiftModalPicker: UITextField {
    
    private var pickerItems: [[String]] = []
    private var type: SwiftModalPicker.PickerType
    private var toolbarItems: [ToolbarButton] = []
    
    // MARK: - Components
    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let items = self.toolbarItems.map({ $0.button })
        toolbar.items = items
        toolbar.sizeToFit()
        
        return toolbar
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        return pickerView
    }()
    
    private lazy var datePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = .wheels
        }
        
        return pickerView
    }()
    
    // MARK: - Handlers
    public var onDatePickerDone: ((_ date: Date) -> Void)?
    public var onPickerDone: ((_ value: String, _ index: Int) -> Void)?
    public var onPickerMiltiComponentsDone: ((_ values: [String], _ indexes: [Int]) -> Void)?
    public var onPickerClosed: (() -> Void)?
    
    // MARK: - Decorate parameters
    public var viewTintColor: UIColor? {
        didSet {
            self.doneToolbar.tintColor = viewTintColor
        }
    }
    
    public var pickerBackgroundColor: UIColor? {
        didSet {
            self.datePickerView.backgroundColor = pickerBackgroundColor
        }
    }
    
    public var pickerColor: UIColor? {
        didSet {
            if let pickerColor = pickerColor {
                self.datePickerView.setValue(pickerColor, forKeyPath: "textColor")
                self.datePickerView.setValue(false, forKeyPath: "highlightsToday")
                
                self.pickerView.setValue(pickerColor, forKeyPath: "textColor")
            }
        }
    }
    
    public var toolbarBackgroundColor: UIColor? {
        didSet {
            self.doneToolbar.backgroundColor = toolbarBackgroundColor
            self.doneToolbar.barTintColor = toolbarBackgroundColor
        }
    }
    
    public init(type: SwiftModalPicker.PickerType, toolbarItems: [ToolbarButton]) {
        self.type = type
        super.init(frame: .zero)
        
        switch type {
        case let .calendar(params):
            self.datePickerView.date = params.selectedDate
            self.datePickerView.datePickerMode = params.datePickerMode
            self.datePickerView.timeZone = params.timeZone
            self.datePickerView.calendar = params.calendar
            self.datePickerView.minimumDate = params.minimumDate
            self.datePickerView.maximumDate = params.maximumDate
        case let .custom(items, _):
            self.pickerItems = [items]
        case let .customWithMultiRows(items, _):
            self.pickerItems = items
        }
        
        self.toolbarItems = toolbarItems
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    public func showPicker(from view: UIView) {
        view.addSubview(self)
        self.becomeFirstResponder()
    }
    
    public func close() {
        self.resignFirstResponder()
        self.removeFromSuperview()
    }
    
    public func donePicker() {
        switch self.type {
        case .calendar:
            self.onDatePickerDone?(self.datePickerView.date)
        case .custom:
            let index = self.pickerView.selectedRow(inComponent: 0)
            if self.pickerItems[0].indices.contains(index) {
                self.onPickerDone?(self.pickerItems[0][index], index)
            }
        case .customWithMultiRows:
            var values: [String] = []
            var indexes: [Int] = []
            
            self.pickerItems.indices.forEach({ componentIndex in
                let rowIndex = self.pickerView.selectedRow(inComponent: componentIndex)
                if self.pickerItems[componentIndex].indices.contains(rowIndex) {
                    values += [self.pickerItems[componentIndex][rowIndex]]
                    indexes += [rowIndex]
                }
            })
            
            self.onPickerMiltiComponentsDone?(values, indexes)
        }
    }
    
    // MARK: - Private
    private func setupView() {
        switch self.type {
        case .calendar:
            self.inputView = datePickerView
        case let .custom(_, selectedIndex):
            self.inputView = pickerView
            self.pickerView.reloadAllComponents()
            
            if let index = selectedIndex, self.pickerItems[0].indices.contains(index) {
                self.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        case let .customWithMultiRows(_, selectedIndexes):
            self.inputView = pickerView
            self.pickerView.reloadAllComponents()
            
            if selectedIndexes.count == self.pickerItems.count {
                selectedIndexes.enumerated().forEach({ (componentIndex, rowIndex) in
                    if let index = rowIndex, self.pickerItems[componentIndex].indices.contains(index) {
                        self.pickerView.selectRow(index, inComponent: componentIndex, animated: false)
                    }
                })
            }
        }
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc
    private func doneDatePicker() {
        self.resignFirstResponder()
        self.donePicker()
        self.removeFromSuperview()
    }
    
    @objc
    private func cancelPicker() {
        self.resignFirstResponder()
        self.onPickerClosed?()
        self.removeFromSuperview()
    }
    
}

// MARK: - UIPickerViewDelegate
extension SwiftModalPicker: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerItems[component][row]
    }
    
}

// MARK: - UIPickerViewDataSource
extension SwiftModalPicker: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.pickerItems.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerItems[component].count
    }
    
}

// MARK: - Models
extension SwiftModalPicker {
    
    public enum PickerType {
        case calendar(params: CalendarParams)
        case custom(items: [String], selectedIndex: Int?)
        case customWithMultiRows(items: [[String]], selectedIndexes: [Int?])
    }
    
    public enum ToolbarButton {
        case cancel(title: String)
        case done
        case custom(button: UIBarButtonItem)
        case space
        
        var button: UIBarButtonItem {
            switch self {
            case let .cancel(title):
                return UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(cancelPicker))
            case .done:
                return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicker))
            case let .custom(button):
                return button
            case .space:
                return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            }
        }
    }
    
    public class CalendarParams {
        var selectedDate: Date = Date()
        var minimumDate: Date? = nil
        var maximumDate: Date? = nil
        var datePickerMode: UIDatePicker.Mode = .date
        var timeZone: TimeZone? = .current
        var calendar: Calendar? = .current
        
        public init(selectedDate: Date = Date(), minimumDate: Date? = nil, maximumDate: Date? = nil, datePickerMode: UIDatePicker.Mode = .date, timeZone: TimeZone? = .current, calendar: Calendar? = .current) {
            self.selectedDate = selectedDate
            self.minimumDate = minimumDate
            self.maximumDate = maximumDate
            self.datePickerMode = datePickerMode
            self.timeZone = timeZone
            self.calendar = calendar
        }
    }
}

// MARK: - UIView helper
extension UIView {
    
    public func getActiveSwiftModalPicker() -> SwiftModalPicker? {
        return self.subviews.first(where: { $0 is SwiftModalPicker  }) as? SwiftModalPicker
    }
    
}
