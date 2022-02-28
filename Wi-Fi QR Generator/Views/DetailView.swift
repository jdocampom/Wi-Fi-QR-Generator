//
//  DetailView.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 6/02/22.
//

import CoreImage
import LinkPresentation
import SwiftUI

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
                        .textSelection(.enabled)                }
                HStack {
                    Text("Password")
                    Spacer()
                    Text(network.password ?? "Unknown")
//                    Text(String(repeating: "*", count: network.password!.count))
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Security")
                    Spacer()
                    Text(network.security ?? "Unknown")
                }
                HStack {
                    Text("Hidden Network")
                    Spacer()
                    Text(network.hidden == true ? "Yes" : "No" )
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
            ShareSheet(items: items)
        }
        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Save") {
//                    dismiss()
//                }
//            }
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

extension DetailView {
    
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
    
    func showShareQRSheet() {
        shareQR()
//        shareCode(image: image)
        showingShareSheet.toggle()
    }
    
    func shareQR() {
        items.removeAll()
        items.append(UIImage(data: generateQR(ssid: network.ssid ?? "", security: network.security ?? "" , password: network.password ?? "", hidden: network.hidden)!)!)
//                items.append(UIImage(data: generateQR(ssid: network.ssid ?? "", security: network.security ?? "" , password: network.password ?? "", hidden: network.hidden)!)!.resized(withPercentage: 0.25)!)
    }
    
    func deleteNetwork() {
        viewContext.delete(network)
        dismiss()
    }
    
//    func shareCode(image: UIImage) {
//        let qrCode = image
//        let shareSheet = UIActivityViewController(activityItems: [qrCode], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(shareSheet, animated: true, completion: nil)
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            shareSheet.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
//            shareSheet.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2.1, y: UIScreen.main.bounds.height / 1.3, width: 200, height: 200)
//        }
//    }
    
}
