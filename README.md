# PromptReaderClient

A lightweight Swift class for integrating PromptReader into your macOS application. PromptReader is a floating inspector window that displays AI image generation parameters. This client class makes it easy to send images to PromptReader for inspection.


## Basic Usage
First of all, you don't need to do *anything* to have PromptReader run alongside your image app. Users can drag images from your app to PromptReader to get extra info.  
If you would like PromptReader to *track* the selection in your gallery or browser app, then read on. PromptReader can float above and display detailed info on the currently selected image. To have PR track the current selection, pass its URL to the PromptReaderClient object

```swift
// Initialize the client
let promptReader = PromptReaderClient()

// Display a file in PromptReader
func selectionDidChange(_ url: URL) {
    promptReader.inspect(url)
}
```
![Screenshot](images/gallery-hud.jpg)

## Features

- Simple API for displaying files in PromptReader
- Automatic checks for App availability
- User preference management
- SwiftUI support

## Installation

Add PromptReaderClient.swift to your Xcode project. That's all.

## SwiftUI Integration

We suggest adding a user preference toggle for enabling PR:

```swift
@AppStorage("callPromptReader") var callPromptReader = promptReader.isAppInstalled

Toggle("Show Image Settings in PromptReader", isOn: $callPromptReader)
    .disabled(!promptReader.isAppInstalled) // only enable the pref if app is installed
    .help(promptReader.isAppInstalled ?
          "Show full image settings using companion app, PromptReader" :
          "PromptReader is not installed")
```

## Requirements

- macOS 14 or later
- PromptReader, [Download](https://github.com/S1D1T1/PromptWriter/releases/latest/download/PromptReader.app.zip)

## License

MIT License. See [LICENSE](LICENSE) file for details.



## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
