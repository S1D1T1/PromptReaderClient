//
//  PromptReaderClient.swift

/// PromptReaderClient provides a simple interface to display files in PromptReader's
/// floating inspector window.
///
/// Basic usage:
/// ```
/// // Initialize the client
/// let promptReader = PromptReaderClient()
///
/// // Display a file in PromptReader
/// func selectionDidChange(_ url: URL) {
///     promptReader.inspect(url)
/// }
/// ```
///
/// The client automatically checks for PromptReader's availability and respects the user's
/// preference whether to use the inspector (stored in UserDefaults key "callPromptReader").
///
/// If calling PR is a user preference, it is suggested that you make it conditional on
///  the app being installed

///  For SwiftUI:
///  ```
///  // in SettingView
/// @AppStorage("callPromptReader") var callPromptReader = promptReader.isAppInstalled
///
/// Toggle("Show Image Settings in PromptReader", isOn: $callPromptReader)
///     .disabled(!promptReader.isAppInstalled)
///     .help(promptReader.isAppInstalled ?
///           "Show full image settings using companion app, PromptReader" :
///           "PromptReader is not installed")
/// ```
/// OR- Hide the preference altogether if app is not present.

///  there is no penalty for redundant calls with the same URL, the client checks for that


#if os(macOS)
import Foundation
import SwiftUI

public class PromptReaderClient {
  let appURL:Unmanaged<CFURL>?

  /// Indicates whether PromptReader is installed on the system.
  /// Use this to conditionally enable PromptReader features.
  public var isAppInstalled:Bool {
    self.appURL != nil
  }
  var lastURL:URL?

  public init() {
    @AppStorage("callPromptReader") var callPromptReader = true

    if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.tafkad.promptreader") {
      self.appURL = Unmanaged<CFURL>.passRetained(url as CFURL)
    }
    else  {
      self.appURL = nil
      callPromptReader = false
    }
  }

  /// Opens a URL in the PromptReader application.
  /// - Parameter url: The  file URL to open in PromptReader.
  public func inspect(_ url:URL){
    @AppStorage("callPromptReader") var callPromptReader = true

    guard callPromptReader,
          isAppInstalled,
          url != lastURL else {return}

    lastURL = url
    let endURL = Unmanaged<CFArray>.passRetained([url] as CFArray)
    var launch = LSLaunchURLSpec(
      appURL: appURL,
      itemURLs: endURL,
      passThruParams: nil,
      launchFlags: .dontSwitch,
      asyncRefCon: nil
    )
    LSOpenFromURLSpec(&launch, nil)

    endURL.release()
  }

}
#endif  // os(macOS)
