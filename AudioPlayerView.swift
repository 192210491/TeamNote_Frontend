import SwiftUI
// MARK: - Post Logic (SAFE VERSION)
import AVFoundation

struct AudioPlayerView: View {

    let audioURL: URL
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false

    var body: some View {
        Button(action: togglePlay) {
            HStack {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2)

                Text(isPlaying ? "Playing voice note..." : "Play voice note")
                    .font(.subheadline)

                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(14)
        }
    }

    private func togglePlay() {
        if isPlaying {
            player?.stop()
            isPlaying = false
        } else {
            do {
                player = try AVAudioPlayer(contentsOf: audioURL)
                player?.play()
                isPlaying = true
            } catch {
                print("Audio play error:", error)
            }
        }
    }
}

