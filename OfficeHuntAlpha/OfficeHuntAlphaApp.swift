/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

@main
struct OfficeHuntAlphaApp: App {
    
    class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
            func applicationDidFinishLaunching(_ notification: Notification) {
                let mainWindow = NSApp.windows[0]
                mainWindow.delegate = self
            }
        
            func windowShouldClose(_ sender: NSWindow) -> Bool {
                let alert = NSAlert.init()
                alert.addButton(withTitle: "Return")
                alert.addButton(withTitle: "Quit")
                alert.informativeText = "Quit or return to application?"
                let response = alert.runModal()
                if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                    return false
                    } else {
                    NSApplication.shared.terminate(self)
                    return true
                }
            }
        }
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    struct FontView: View {
        let allFontNames = NSFontManager.shared.availableFonts
        var body: some View {
            List(allFontNames, id: \.self) { name in
                Text(name).font(Font.custom(name, size: 12))
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CameraView()
        }
    }
}

