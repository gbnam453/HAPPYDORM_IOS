//
//  SplashScreenView.swift
//  HoseoHappyDorm
//
//  Created by 남기범 on 3/1/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            MainView() // ✅ 2초 후 ContentView로 이동
        } else {
            ZStack {
                Color._658DFB.ignoresSafeArea()
                Image("splash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
