//
//  ContentView.swift
//  InAppNotification
//
//  Created by Benji Loya on 13.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Show Sheet") {
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet, content: {
                    Button("Show AirDrop notification") {
                        UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                            HStack {
                                Image(systemName: "wifi")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                VStack(alignment: .leading, spacing: 2, content: {
                                    Text("AirDrop")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                    
                                    Text("From User Name")
                                        .textScale(.secondary)
                                        .foregroundStyle(.gray)
                                })
                                .padding(.top, 20)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(15)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.black)
                            }
                        }
                    }
                })
                
                
                Button("Show Notification") {
                    // Notification
                    UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                        HStack {
                            Image("ava")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(.circle)
                            
                            VStack(alignment: .leading, spacing: 6, content: {
                                Text("User Name")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                
                                Text("Hello, This is User Name")
                                    .textScale(.secondary)
                                    .foregroundStyle(.gray)
                            })
                            .padding(.top, 20)
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "speaker.slash.fill")
                                    .font(.title2)
                            })
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .tint(.white)
                            
                        }
                        .padding(15)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.black)
                        }
                    }
                    
                }
            }
            .navigationTitle("In App Notifications")
        }
    }
}

#Preview {
    ContentView()
}
