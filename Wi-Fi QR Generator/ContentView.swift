//
//  ContentView.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 6/02/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Network.date, ascending: true)], animation: .default) private var networks: FetchedResults<Network>
    
    @State private var showingAddScreen = false
    @State private var showingAboutScreen = false
    
    var body: some View {
        NavigationView {
            if networks.isEmpty {
                Text("No saved networks")
                    .navigationTitle("Saved Networks")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showingAddScreen.toggle()
                            } label: {
                                Label("Add Network", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddScreen) {
                        AddNetworkView()
                    }
            } else {
                List {
                    ForEach(networks) { network in
                        NavigationLink {
                            DetailView(network: network)
                        } label: {
                            HStack {
                                if network.security == "None" {
                                    Image(systemName: "lock.open.fill")
                                } else {
                                    Image(systemName: "lock.fill")
                                }
                                VStack(alignment: .leading) {
                                    Text(network.ssid ?? "Unknown")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                    HStack {
                                        Text("Security:")
                                            .font(.subheadline)
                                        Text(network.security ?? "Unknown")
                                            .font(.subheadline)
                                    Spacer()
                                    }
                                }
                            }
                        }
                        
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Saved Networks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                            print("Add button tapped")
                        } label: {
                            Label("Add Network", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showingAboutScreen.toggle()
                            print("About button tapped")
                        } label: {
                            HStack {
                                Label("About the App", systemImage: "info.circle")
                                Text("About the App")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingAboutScreen) {
                    AboutView()
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddNetworkView()
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offset in offsets {
            let network = networks[offset]
            viewContext.delete(network)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
