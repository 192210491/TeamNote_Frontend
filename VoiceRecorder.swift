import Foundation
import AVFoundation
import Speech
import Combine

final class VoiceRecorder: NSObject, ObservableObject {

    // MARK: - Published
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var audioURL: URL?

    // MARK: - Audio
    private let audioEngine = AVAudioEngine()
    private var audioRecorder: AVAudioRecorder?

    // MARK: - Speech
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // MARK: - Init
    override init() {
        super.init()
        requestPermissions()
    }

    // MARK: - Permissions
    private func requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in }
        SFSpeechRecognizer.requestAuthorization { _ in }
    }

    // MARK: - Start Recording
    func startRecording() throws {

        transcript = ""
        isRecording = true

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .measurement)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        // ✅ Create audio file URL
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("m4a")

        audioURL = fileURL

        // ✅ Audio Recorder settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
        audioRecorder?.record()

        // MARK: - Speech Recognition
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode

        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(
            with: recognitionRequest
        ) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
        }

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: format
        ) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    // MARK: - Stop Recording
    func stopRecording() {

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionRequest?.endAudio()
        recognitionTask?.cancel()

        audioRecorder?.stop()

        isRecording = false
    }
}

