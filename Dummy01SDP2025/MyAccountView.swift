//
//  MyAccountView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 6/1/26.
//

import SwiftUI

struct MyAccountView: View {
    
    @State private var vm = MyAccountVM()
    
    //@State private var nickName: String = ""
    @AppStorage("nickName") var nickName: String = ""
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                Form {
                    
                    Section {
                        Text(vm.getEmail())
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    //.listRowBackground(Color.gray.opacity(0.2))
                    /*header: {
                     Text("Personal data")
                     }*/
                    
                    Section {
                        TextField("¿Cómo quieres que te llame?", text: $nickName)
                        
                        Text("Tú sólo escribe, que se graba solo")
                            .font(.footnote)
                    }
                    .listRowBackground(Color.gray.opacity(0.1))
                    /*header: {
                     Text("Personal data")
                     }*/
                }
                .textFieldStyle(.roundedBorder)
                .frame(height: 200)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .listSectionSpacing(4)
                .padding(.horizontal, isiPhone ? 0 : 120)
                               
                Image(.crying)
                    .resizable()
                    .scaledToFit()
                    .frame(height: isiPhone ? 180 : 300)
                    .foregroundStyle(.secondary)
                    .padding(.vertical,40)
                
                // Título con Label
                Label {
                    Text("¿Te vas?")
                        .font(.title2)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "person.crop.circle.badge.xmark")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                // Descripción
                Text("Si cierras sesión, me dejarás muy solo ...")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal, isiPhone ? 20 : 120)
                
                Button {
                    vm.logout()
                } label: {
                    Text("Cerrar Sesión")
                }
                .padding(.bottom,30)
                
                
                
                
                
                
                
                
                
            }
            .navigationTitle("Mi cuenta")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $vm.showLogin) {
                SignInView()
                    .environment(MainVM())
                
            }
            
        }
    }
}

#Preview {
    MyAccountView()
}
