import ReplayKit
import Vision

/// Handler da extensão de gravação de tela (Broadcast Upload Extension).
/// Recebe cada frame capturado enquanto o usuário tem a gravação ativa
/// apontada pro Corrida Certa. Processa no máximo 1 frame por intervalo
/// definido, pra economizar bateria e memória — essa extensão tem um
/// limite de RAM bem menor que o app principal (por volta de 50MB).
class SampleHandler: RPBroadcastSampleHandler {

    private var lastProcessedAt = Date.distantPast
    private let minimumInterval: TimeInterval = 2.0
    private let settingsStore = SettingsStore()

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        lastProcessedAt = .distantPast
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard sampleBufferType == .video else { return }

        let now = Date()
        guard now.timeIntervalSince(lastProcessedAt) >= minimumInterval else { return }
        lastProcessedAt = now

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        OCRService.recognizeText(in: pixelBuffer) { [weak self] text in
            self?.handleRecognizedText(text)
        }
    }

    private func handleRecognizedText(_ text: String) {
        guard let offer = OfferTextParser.parse(rawText: text) else { return }
        let result = EarningsCalculator.evaluate(offer: offer, settings: settingsStore.settings)
        SharedStore.saveLatestResult(result)
        NotificationService.notify(result: result)
    }

    override func broadcastFinished() {
        // Nada específico a limpar por enquanto.
    }
}
