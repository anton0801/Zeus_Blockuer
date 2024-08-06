import SwiftUI

struct BlockuerGamePauseView: View {
    
    @Environment(\.presentationMode) var pm
    @StateObject var appConfig = AppConfiguration()
    
    var restartAction: () -> Void
    var continueGame: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("PAUSE")
                .font(.custom("Fredoka-Bold", size: 62))
                .foregroundColor(.white)
            Spacer()
            Text("GAME PAUSED!")
                .font(.custom("Fredoka-Bold", size: 40))
                .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                Button {
                    pm.wrappedValue.dismiss()
                } label: {
                    Image("home")
                }
                Button {
                    continueGame()
                } label: {
                    Image("continue_game")
                }
                Button {
                    restartAction()
                } label: {
                    Image("restart")
                }
            }
            
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
            
            Spacer()
        }
        .background(
            Image("game_state_background")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    BlockuerGamePauseView {
        
    } continueGame: {
        
    }

}
