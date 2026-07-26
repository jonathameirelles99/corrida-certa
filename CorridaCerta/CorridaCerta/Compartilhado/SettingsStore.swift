import Foundation
import Combine

/// Guarda e publica as configurações do usuário.
/// Usa um App Group para que a extensão de captura de tela (Fase 2)
/// também consiga ler essas metas sem precisar duplicar a lógica.
final class SettingsStore: ObservableObject {
    private static let storageKey = "user_settings"

    @Published var settings: UserSettings {
        didSet { persist() }
    }

    private let defaults: UserDefaults

    init() {
        self.defaults = SharedStore.defaults
        if let data = defaults.data(forKey: Self.storageKey),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = .default
        }
    }

    private func persist() {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: Self.storageKey)
        }
    }
}
