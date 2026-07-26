import Vision
import CoreVideo

/// Executa reconhecimento de texto (OCR) em um frame de vídeo usando o
/// Vision Framework da Apple. Roda 100% no dispositivo — nenhum dado de
/// tela é enviado para servidores externos.
enum OCRService {
    static func recognizeText(in pixelBuffer: CVPixelBuffer, completion: @escaping (String) -> Void) {
        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion("")
                return
            }
            let text = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            completion(text)
        }
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["pt-BR"]
        request.usesLanguageCorrection = false

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
