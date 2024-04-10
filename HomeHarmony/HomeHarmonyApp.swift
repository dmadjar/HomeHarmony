import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct HomeHarmonyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.authenticationState {
            case .unauthenticated, .authenticating:
                LoginView()
                    .environmentObject(viewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            case .authenticated:
                MainView()
                    .environmentObject(viewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
        .onChange(of: viewModel.user) {
            Task {
                if viewModel.user != nil {
                    await self.viewModel.fetchData()
                }
            }
        }
    }
}
