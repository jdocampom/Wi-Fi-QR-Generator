//
//  AddNetwork.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 6/02/22.
//

import SwiftUI

struct AddNetworkView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var ssid = ""
    @State private var password = ""
    @State private var security = "Select one..."
    @State private var hidden = false
    
    let networkSecurityAlgorithms = ["Select one...", "None", "WEP", "WPA", "WPA2"]
    
    var didPassInputValidation: Bool {
        if ssid.trimmingCharacters(in: .whitespaces).isEmpty || security == "Select one..." {
            return false
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Network Details"), footer: Text("The SSID should not contain special characters. \n\nIf your network is not protected by a password please leave the password field blank.")) {
                    TextField("SSID", text: $ssid)
                    SecureField("Password", text: $password)
                    HStack {
                        Text("Security")
                        Spacer()
                        Picker("Encryption Level", selection: $security) {
                            ForEach(networkSecurityAlgorithms, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    HStack {
                        Text("Hidden Network")
                        Spacer()
                        Toggle(isOn: $hidden){}
                        .accessibility(label: Text("Hidden Network"))
                    }
                } 
            }
            .navigationTitle("Add Network")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading : Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newNetwork = Network(context: viewContext)
                    newNetwork.id = UUID()
                    newNetwork.ssid = ssid
                    newNetwork.password = password
                    newNetwork.security = security
                    newNetwork.date = Date()
                    newNetwork.hidden = hidden
                    try? viewContext.save()
                    dismiss()
                }
                    .disabled(didPassInputValidation == false))
        }
    }
    
}

struct AddNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        AddNetworkView()
    }
}
