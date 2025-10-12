//
//  SettingsScreen.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI
import MessageUI

struct SettingsScreen: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>?
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfUsage = false
    
    var body: some View {
        List {
            HStack {
                Image(systemName: "paintbrush")
                    .foregroundColor(.primary)
                    .frame(width: 24, height: 24)
                
                Text("Tema")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Picker("Tema", selection: $themeManager.selectedTheme) {
                    ForEach(ThemeManager.Theme.allCases, id: \.self) { theme in
                        Text(theme.displayName)
                            .tag(theme)
                    }
                }
                .pickerStyle(.segmented)
                .fixedSize(horizontal: true, vertical: false)
            }
            
            //                    Button(action: {
            //
            //                    }) {
            //                        HStack {
            //                            Image(systemName: "star")
            //                                .foregroundColor(.yellow)
            //                                .frame(width: 24, height: 24)
            //
            //                            Text("Bizi değerlendirin")
            //                                .foregroundColor(.primary)
            //
            //                            Spacer()
            //
            //                            HStack(spacing: 2) {
            //                                ForEach(0..<5) { _ in
            //                                    Image(systemName: "star.fill")
            //                                        .foregroundColor(.yellow)
            //                                        .font(.system(size: 14))
            //                                }
            //                            }
            //                        }
            //
            //                    }
            
            Button(action: {
                if MFMailComposeViewController.canSendMail() {
                    showingMailView = true
                } else {
                    // Fallback: Open default mail app
                    if let url = URL(string: "mailto:\(Constants.feedbackEmail)?subject=Feedback") {
                        UIApplication.shared.open(url)
                    }
                }
            }) {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                        .frame(width: 24, height: 24)
                    
                    Text("Geri Bildirim")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
            }
            
            Button(action: {
                showingPrivacyPolicy = true
            }) {
                HStack {
                    Image(systemName: "lock.document")
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 24)
                    
                    Text("Gizlilik Politikası")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
            }
            
            Button(action: {
                showingTermsOfUsage = true
            }) {
                HStack {
                    Image(systemName: "text.document")
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 24)
                    
                    Text("Kullanım Koşulları")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
            }
            
            Section {
                VStack(spacing: 10) {
                    if let appIcon = UIImage(named: "AppIcon") {
                        Image(uiImage: appIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Text(Bundle.main.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Sürüm: \(Bundle.main.fullVersion)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("❤️ ile yapıldı")
                    
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Bundle.main.displayName) uygulaması, yalnızca piyasa verilerini takip etmenizi kolaylaştırmak amacıyla geliştirilmiştir. Gösterilen fiyat ve bilgiler farklı satıcılar arasında değişiklik gösterebilir; uygulama bu verilerin doğruluğu veya güncelliği konusunda garanti vermez.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .navigationTitle("Uygulama Ayarları")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingPrivacyPolicy) {
            if let url = URL(string: Constants.privacyPolicyURL) {
                Browser(url: url)
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: $showingTermsOfUsage) {
            if let url = URL(string: Constants.termsOfServiceURL) {
                Browser(url: url)
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: $showingMailView) {
            MailView(
                toRecipients: [Constants.feedbackEmail],
                subject: "Geri Bildirim",
                messageBody: MailView.defaultMailBody,
                result: $mailResult
            )
        }
    }
}


struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .environmentObject(ThemeManager())
    }
}
