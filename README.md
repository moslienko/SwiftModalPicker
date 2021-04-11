<p align="center">
   <img width="200" src="https://raw.githubusercontent.com/SvenTiigi/SwiftKit/gh-pages/readMeAssets/SwiftKitLogo.png" alt="SwiftModalPicker Logo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat" alt="Swift 5.2">
   </a>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
</p>

# SwiftModalPicker

<p align="center">
ℹ️ Swift library for displaying a modal sheet with a picker in iOS apps.
</p>

<p float="center">
<img src="https://i.imgur.com/d7xsTyA.png" width="30%">
<img src="https://i.imgur.com/bLMl7Wi.png" width="30%">
<img src="https://i.imgur.com/s2hNI9d.png" width="30%">
<img src="https://i.imgur.com/9VyZkG2.png" width="30%">
<img src="https://i.imgur.com/YhJTsPM.png" width="30%">
</p>

## Features

- [x] 📅 Picker date
- [x] 🕑 Picker time
- [x] ↕️ Picker custom value
- [x] ↔️ Multi picker
- [x] ⚙️ Fine-tuning the picker and setting a custom style

## Example

The example application is the best way to see `SwiftModalPicker` in action. Simply open the `SwiftModalPicker.xcodeproj` and run the `Example` scheme.

## Installation
### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/moslienko/SwiftModalPicker.git", from: "1.0.0")
]
```

Alternatively navigate to your Xcode project, select `Swift Packages` and click the `+` icon to search for `SwiftModalPicker`.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate SwiftModalPicker into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage
### Create picker and show

```swift
	let picker = SwiftModalPicker(type: <SwiftModalPicker.PickerType>, toolbarItems: <[SwiftModalPicker.ToolbarButton]>)
	pickerViewPresenter.showPicker(from: self.view)
```

### Handlers

```swift
    public var onDatePickerDone: ((_ date: Date) -> Void)?
    public var onPickerDone: ((_ value: String, _ index: Int) -> Void)?
    public var onPickerMiltiComponentsDone: ((_ values: [String], _ indexes: [Int]) -> Void)?
    public var onPickerClosed: (() -> Void)?
```

### Toolbar

```swift
	public enum ToolbarButton {
        	case cancel(title: String)
        	case done
        	case custom(button: UIBarButtonItem)
        	case space
	}
```

Usage example

```swift
	let button = UIBarButtonItem(title: "Remove date", style: .plain, target: self, action: #selector(self.removeDate))
        let pickerToolbarButtons: [SwiftModalPicker.ToolbarButton] = [
            .cancel(title: "Cancel"),
            .custom(button: button),
            .space,
            .done
        ]
```

### Picker title

You can specify your own value for the picker title using the UIBarButtonItem custom button for the toolbar

```swift
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
```

### Date picker

```swift
	  let pickerViewPresenter = SwiftModalPicker(type: .calendar(params: SwiftModalPicker.CalendarParams(selectedDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .date, timeZone: .current)), toolbarItems: pickerToolbarButtons)
        
        pickerViewPresenter.onDatePickerDone = { date in
            ...
        }
```

### Time picker

```swift
	 let pickerViewPresenter = SwiftModalPicker(type: .calendar(params: SwiftModalPicker.CalendarParams(selectedDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .time, timeZone: .current)), toolbarItems: pickerToolbarButtons)
        pickerViewPresenter.onDatePickerDone = { date in
            ...
        }
```

### CustomPicker

```swift
	let items = ["Apple", "Avocado", "Banana", "Blackberries"]
        let pickerViewPresenter = SwiftModalPicker(type: .custom(items: items, selectedIndex: 2), toolbarItems: pickerToolbarButtons)
        pickerViewPresenter.onPickerDone = { (val, index) in
            ...
        }
```

### MultiComponentPicker

```swift
	let items = [["iPhone", "iPad", "MacBook", "Mac mini"], ["AirPods", "AirPods Pro", "AirPods Max"]]
        let pickerViewPresenter = SwiftModalPicker(type: .customWithMultiRows(items: items, selectedIndexes: [2, 1]), toolbarItems: pickerToolbarButtons)
        
        pickerViewPresenter.onPickerMiltiComponentsDone = { (values, indexes) in
            ...
        }
```

## Customization

The following options are available to change the picker style

```swift
public var viewTintColor: UIColor?
public var pickerBackgroundColor: UIColor?
public var pickerColor: UIColor?
public var toolbarBackgroundColor: UIColor?
```

Example

```swift
	let pickerViewPresenter = SwiftModalPicker(type: .calendar(params: SwiftModalPicker.CalendarParams(selectedDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .date, timeZone: .current)), toolbarItems: pickerToolbarButtons)
        pickerViewPresenter.viewTintColor = .red
        pickerViewPresenter.pickerBackgroundColor = .black
        pickerViewPresenter.pickerColor = .white
        pickerViewPresenter.toolbarBackgroundColor = UIColor.black.withAlphaComponent(0.7)
```

## Get the current picker
```swift
let picker = view.getActiveSwiftModalPicker()
```

Further actions with him - you can close the picker
```swift
picker?.close()
```

You can get the current value
```swift
picker?.donePicker()
```

As a result of which `onPickerDone` event will be triggered

## License

```
SwiftModalPicker
Copyright (c) 2021 Pavel Moslienko 8676976+moslienko@users.noreply.github.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
