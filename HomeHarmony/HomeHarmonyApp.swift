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
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.authenticationState {
            case .unauthenticated, .authenticating:
                LoginView()
                    .environmentObject(viewModel)
            case .authenticated:
                MainView()
                    .environmentObject(viewModel)
                    .onAppear {
                        Task {
                            await viewModel.getUser()
                            await viewModel.getFamilies()
                            await viewModel.getFriendRequests()
                            await viewModel.getFriends()
                        }
                    }
            }
        }
    }
}
