import Foundation
import UserNotifications

/// Dispara notificações locais com o resultado da análise.
/// Funciona tanto a partir do app principal quanto da extensão de
/// captura de tela — notificações locais não exigem que o processo
/// que as agenda seja o app principal.
enum NotificationService {

    static func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }

    static func notify(result: RideVerdictResult) {
        let content = UNMutableNotificationContent()
        content.title = result.verdict.rawValue
        content.body = String(
            format: "R$/km: %.2f · R$/h: %.2f",
            result.netValuePerKm,
            result.netValuePerHour
        )
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // dispara imediatamente
        )

        UNUserNotificationCenter.current().add(request)
    }
}
