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
            /// Tag: NSPersistentContainer is EMPTY
            if networks.isEmpty {
                Text("No saved networks")
                /// Tag: Text Modifiers
                /// This modifiers should be available whenever CoreData Persistance Container is  empty
                /// Navigation Bar Title
                    .navigationTitle("Saved Networks")
                /// Toolbar
                    .toolbar {
                        /// Add Button - Add a new Network to Persistant Storage
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showingAddScreen.toggle()
                            } label: {
                                Label("Add Network", systemImage: "plus")
                            }
                        }
                        /// Add Button - Add a new Network to Persistant Storage
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
                /// Tag: NSPersistentContainer is NOT EMPTY
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
                /// Tag: List Modifiers
                /// This modifiers should be available whenever CoreData Persistance Container is NOT empty
                /// Navigation Bar Title
                .navigationTitle("Saved Networks")
                /// Toolbar
                .toolbar {
                    /// Edit Button - Remove an existing Network to Persistant Storage
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    /// Add Button - Add a new Network to Persistant Storage
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                            print("Add button tapped")
                        } label: {
                            Label("Add Network", systemImage: "plus")
                        }
                    }
                    /// About Button - Contact Support, Rate the App or Leave a Tip
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
            }
        }
        /// Tag: NavigationView Modifiers
        /// This sheet modifiers should be available all the time, even if there are no networks saved on CoreData.
        /// Show AboutView - Contact Support, Rate the App or Leave a Tip
        .sheet(isPresented: $showingAboutScreen) {
            AboutView()
        }
        /// Show AddView - Add a new Network to Persistant Storage
        .sheet(isPresented: $showingAddScreen) {
            AddNetworkView()
        }
    }
}

// MARK: - ContentView Methods

extension ContentView {
    /// Tag: deleteItems()
    /// Delete a Network from Persistant Storage
    func deleteItems(at offsets: IndexSet) {
        for offset in offsets {
            let network = networks[offset]
            viewContext.delete(network)
        }
    }
}

// MARK: -  ContentView Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
