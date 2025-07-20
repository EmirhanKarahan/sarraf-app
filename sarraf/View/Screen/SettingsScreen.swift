//
//  SettingsScreen.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI

extension SettingsScreen {
    enum Theme: String, CaseIterable {
        case system = "Sistem"
        case light = "Açık"
        case dark = "Koyu"
        
        var icon: String {
            switch self {
            case .system: return "gear"
            case .light: return "sun.max"
            case .dark: return "moon"
            }
        }
    }
    
}

struct SettingsScreen: View {
    @State private var selectedTheme: Theme = .system
    
    var body: some View {
        NavigationView {
            List {
                Section("UYGULAMA AYARLARI") {
                    Button(action: {
                        
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.primary)
                                .frame(width: 24, height: 24)
                            
                            Text("Dil")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Text("🇹🇷")
                                    .font(.system(size: 16))
                                
                                Text("TR")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                    }
                    
                    HStack {
                        Image(systemName: "paintbrush")
                            .foregroundColor(.primary)
                            .frame(width: 24, height: 24)
                        
                        Text("Tema")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Picker("Tema", selection: $selectedTheme) {
                            ForEach(Theme.allCases, id: \.self) { theme in
                                HStack {
                                    Image(systemName: theme.icon)
                                    Text(theme.rawValue)
                                }
                                .tag(theme)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 180)
                    }
                    
                    Button(action: {
                        
                    }) {
                        HStack {
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                                .frame(width: 24, height: 24)
                            
                            Text("Bizi değerlendirin")
                            
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 14))
                                }
                            }
                        }
                        
                    }
                }
                
                Section("DİĞER") {
                    Button(action: {
                        
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
                    
                    
                }
                
                Section {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Sarraf")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Sürüm: 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                            Text("ile yapıldı")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                        Text("Baazar/Bu uygulama piyasa verilerini takip etmek amacıyla oluşturulmuştur ancak verilerin doğruluğu hakkında bir beyanda bulunmaz.")
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
        }
    }
}



struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
