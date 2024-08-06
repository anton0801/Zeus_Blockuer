import SwiftUI

struct BlockuerGameOverView: View {
    
    @Environment(\.presentationMode) var pm
    @StateObject var appConfig = AppConfiguration()
    
    var restartAction: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("GAME OVER!")
                .font(.custom("Fredoka-Bold", size: 62))
                .foregroundColor(.white)
            Spacer()
            Text("TRY AGAIN!")
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
    BlockuerGameOverView {
        
    }
}
