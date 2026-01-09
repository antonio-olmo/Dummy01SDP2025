//
//  MyAccountView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 6/1/26.
//

import SwiftUI

struct MyAccountView: View {
    
    @State private var vm = MyAccountVM()
    
    var body: some View {
        VStack {
            Button {
                vm.logout()
            } label: {
                Text("Cerrar Sesión")
            }
            //.buttonStyle(.plain)
        }
        .fullScreenCover(isPresented: $vm.showLogin) {
            SignInView()
                .environment(MainVM())
        }
    }
}

#Preview {
    MyAccountView()
}
