//
//  DetailView.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 6/02/22.
//

import CoreImage
import LinkPresentation
import SwiftUI

// MARK: - DetailView Properties and Main SwiftUI View

struct DetailView: View {
    
    let network: Network
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var items: [Any] = []
    
    @State private var showingShareSheet = false
    @State private var showingDeleteAlert = false
    @State private var qrCode: UIImage? = nil
    
    var formattedDate: String {
        guard let date = network.date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return "\(formatter.string(from: date))"
    }
    
    var displayedPassword: String {
        guard let password = network.password else { return "" }
        return password
    }
    
    var body: some View {
        Form {
            Section(header: Text("Network Details"), footer: Text("The SSID should not contain special characters. \n\nIf your network is not protected by a password please leave the password field blank.")) {
                HStack {
                    Text("SSID")
                    Spacer()
                    Text(network.ssid ?? "Unknown")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Password")
                    Spacer()
                    Text(network.password ?? "Unknown")
//                    Text(String(repeating: "*", count: network.password!.count))
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Security")
                    Spacer()
                    Text(network.security ?? "Unknown")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Hidden Network")
                    Spacer()
                    Text(network.hidden == true ? "Yes" : "No" )
                        .foregroundColor(.secondary)
                }
            }
            Section(header: Text("QR Code")) {
                HStack {
                    Spacer()
                    Image(uiImage: UIImage(data: generateQR(ssid: network.ssid ?? "", security: network.security ?? "" , password: network.password ?? "", hidden: network.hidden)!)!)
                        .resizable()
                        .interpolation(.none)
                        .padding()
                        .frame(width: 256, height: 256)
                        .contextMenu {
                            Button {
                                showShareQRSheet()
                            } label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Export QR Code")
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    Spacer()
                }
            }
        }
        .navigationTitle("Network Details")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete Book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteNetwork)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this network?")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [UIImage(data: generateQR(ssid: network.ssid ?? "", security: network.security ?? "" , password: network.password ?? "", hidden: network.hidden)!)!])
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showShareQRSheet()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export QR Code")
                            .multilineTextAlignment(.center)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            ToolbarItem(placement: .bottomBar) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Network")
                            .multilineTextAlignment(.center)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

// MARK: - DetailView Methods

extension DetailView {
    
    /// Tag: Generate QR Code from Network Data
    func generateQR(ssid: String, security: String, password: String, hidden: Bool) -> Data? {
        var passcode = ""
        var encryptionType = ""
        switch security {
        case "WEP":
            encryptionType = "WEP"
            passcode = password
        case "WPA":
            encryptionType = "WPA"
            passcode = password
        case "WPA2":
            encryptionType = "WPA2"
            passcode = password
        default :
            encryptionType = "nopass"
            passcode = ""
        }
        let text = "WIFI:T:\(encryptionType);S:\(ssid);P:\(passcode);H:\(hidden);;"
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .utf8, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
    
    /// Tag: Show Share QR ActivityViewController
    func showShareQRSheet() {
        showingShareSheet.toggle()
    }
    
    /// Tag: Export QR to ActivityViewController
    func shareQR() {
        items.removeAll()
        items.append(UIImage(data: generateQR(ssid: network.ssid ?? "", security: network.security ?? "" , password: network.password ?? "", hidden: network.hidden)!)!)
    }
    
    /// Tag: Delete Network
    func deleteNetwork() {
        viewContext.delete(network)
        dismiss()
    }
}
