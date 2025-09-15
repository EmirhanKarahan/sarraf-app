//
//  MailView.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 3.08.2025.
//

import SwiftUI
import MessageUI

// MARK: - Mail View
struct MailView: UIViewControllerRepresentable {
    let toRecipients: [String]
    let subject: String
    let messageBody: String
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    static let defaultMailBody = """
                    Merhaba,
                    
                    \(Bundle.main.displayName) uygulaması hakkında geri bildirimim:
                    
                    
                    
                    Uygulama Sürümü: \(Bundle.main.fullVersion)
                    iOS Sürümü: \(UIDevice.current.systemVersion)
                    """
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients(toRecipients)
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
            controller.dismiss(animated: true)
        }
    }
}
