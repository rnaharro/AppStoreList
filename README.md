# AppStoreList

**AppStoreList** is a SwiftUI library that allows you to display a list of apps from the App Store in an aesthetically pleasing way. It uses `StoreKit` to fetch app details and presents a user-friendly list that supports navigation to the App Store.

---

## 🚀 Features

- 📱 Fetch and display apps from the App Store.
- 🎨 Fully designed for **SwiftUI**.
- 🔍 Supports searching for apps by **artist ID, app ID, or bundle ID**.
- 🔗 Opens the App Store page seamlessly.
- 📡 Handles network requests asynchronously with `async/await`.
- 🛠 Compatible with both **CocoaPods** and **Swift Package Manager**.

---

## 📦 Installation

### Swift Package Manager (SPM)

To install via **Swift Package Manager**, follow these steps:

1. Open **Xcode** and go to **File > Add Packages…**.
2. Enter the repository URL:  https://github.com/rnaharro/AppStoreList
3. Choose the **latest version** and click **Add Package**.

### CocoaPods

To install via **CocoaPods**, add the following line to your `Podfile`:

```ruby
pod 'AppStoreList'
```
Then, run:

```sh
pod install
```

## 📖 Usage

### Basic Example
```swift
import SwiftUI
import AppStoreList

struct ContentView: View {
    var body: some View {
        NavigationView {
            AppStoreList(title: "Top Apps", artistId: 383673904)
        }
    }
}
```

Using a Custom ViewModel
If you want to inject your own AppStoreViewModel, you can do:

```swift
let viewModel = AppStoreViewModel()
AppStoreList(title: "My Apps", viewModel: viewModel)
Opening the App Store Directly
If you need to open an app's App Store page manually:

Task {
    await viewModel.presentApp(appObject)
}
```

## 🔧 Compatibility

| Platform | Minimum Version |
|----------|---------------|
| iOS      | **16.0**      |
| macOS    | ❌ Not Supported |
| watchOS  | ❌ Not Supported |
| tvOS     | ❌ Not Supported |

- Requires **Xcode 14+**.
- Fully supports **SwiftUI**.
- Works with **Swift 5.7+**.

## 🔄 Changelog

See the Releases page for details on updates.

## 📄 License

AppStoreList is available under the MIT License. See the LICENSE file for more details.

## 👥 Author

Developed by Ricardo N.
Feel free to contribute or report issues on the GitHub repository.
