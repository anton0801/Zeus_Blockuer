import SwiftUI

struct ContentView: View {
    
    @StateObject var appConfig = AppConfiguration()
    @StateObject var levelsManager = LevelsManager()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            appConfig.volumeApp = !appConfig.volumeApp
                        }
                    } label: {
                        if appConfig.volumeApp {
                            Image("volume_on")
                        } else {
                            Image("volume_off")
                        }
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            appConfig.musicApp = !appConfig.musicApp
                        }
                    } label: {
                        if appConfig.musicApp {
                            Image("music_on")
                        } else {
                            Image("music_off")
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: BlockuerGameView(level: levelsManager.levelForPlay)
                    .environmentObject(levelsManager)
                    .navigationBarBackButtonHidden(true)) {
                    Image("play")
                }
                
                HStack {
//                    NavigationLink(destination: EmptyView()) {
//                        Image("rewards")
//                    }
                    Button {
                        exit(0)
                    } label: {
                        Image("shut_down")
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .background(
                Image("background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}

class AppConfiguration: ObservableObject {
    
    @Published var volumeApp: Bool = false {
        didSet {
            UserDefaults.standard.set(volumeApp, forKey: "volumeApp")
        }
    }
    @Published var musicApp: Bool = false {
        didSet {
            UserDefaults.standard.set(musicApp, forKey: "musicApp")
        }
    }
    
    init() {
        volumeApp = UserDefaults.standard.bool(forKey: "volumeApp")
        musicApp = UserDefaults.standard.bool(forKey: "musicApp")
    }
    
}

class LevelsManager: ObservableObject {
    
    @Published var levelForPlay: Int
    
    init() {
        var levelForPass = UserDefaults.standard.integer(forKey: "level_for_pass")
        if levelForPass == 0 {
            levelForPass = 1
            UserDefaults.standard.setValue(1, forKey: "level_for_pass")
        }
        levelForPlay = levelForPass
    }
    
}
