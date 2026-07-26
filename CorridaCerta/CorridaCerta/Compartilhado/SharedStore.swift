import Foundation

/// Ponto único de leitura/escrita dos dados compartilhados entre o app
/// principal e a extensão de captura de tela (Broadcast Upload Extension).
/// As duas rodam em processos separados no iOS — não compartilham memória —
/// então usam um App Group como "cofre" comum.
enum SharedStore {
    /// IMPORTANTE: troque pelo seu próprio App Group depois de criar a conta
    /// de desenvolvedor Apple e registrar esse identificador no portal.
    static let appGroupID = "group.com.corridacerta.shared"

    private static let latestResultKey = "latest_verdict_result"
    private static let darwinNotificationName = "com.corridacerta.novoresultado"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupID) ?? .standard
    }

    static func saveLatestResult(_ result: RideVerdictResult) {
        guard let data = try? JSONEncoder().encode(result) else { return }
        defaults.set(data, forKey: latestResultKey)
        postDarwinNotification()
    }

    static func loadLatestResult() -> RideVerdictResult? {
        guard let data = defaults.data(forKey: latestResultKey) else { return nil }
        return try? JSONDecoder().decode(RideVerdictResult.self, from: data)
    }

    /// Notificação Darwin: um mecanismo de baixo nível que funciona entre
    /// processos diferentes do mesmo dispositivo (diferente do
    /// NotificationCenter comum, que só funciona dentro de um processo).
    private static func postDarwinNotification() {
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            CFNotificationName(darwinNotificationName as CFString),
            nil, nil, true
        )
    }

    static func observeNewResults(_ handler: @escaping () -> Void) {
        DarwinNotificationBridge.shared.handler = handler
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            nil,
            { _, _, _, _, _ in
                DarwinNotificationBridge.shared.handler?()
            },
            darwinNotificationName as CFString,
            nil,
            .deliverImmediately
        )
    }
}

/// Ponte simples para permitir usar uma closure Swift dentro do callback
/// em estilo C exigido pelo CFNotificationCenter.
final class DarwinNotificationBridge {
    static let shared = DarwinNotificationBridge()
    var handler: (() -> Void)?
    private init() {}
}
