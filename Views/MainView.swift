import SwiftUI
import Network

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isConnected: Bool = true // ✅ 인터넷 연결 상태 확인
    @State private var showNoInternetAlert: Bool = false // ✅ 인터넷 연결 없음 팝업

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 10.0) {

                    Image(colorScheme == .dark ? "title_night" : "title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width - 40)
                        .padding(.horizontal, 20)

                    Image("banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width - 40)
                        .padding(.horizontal, 20)

                    // ✅ 인터넷 연결 상태에 따라 NavigationLink 조건부 적용
                    if isConnected {
                        NavigationLink(destination: NoticeView()) {
                            Image(colorScheme == .dark ? "btn_notice_night" : "btn_notice")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width - 40)
                                .padding(.horizontal, 20)
                        }
                    } else {
                        Button(action: {
                            showNoInternetAlert = true
                        }) {
                            Image(colorScheme == .dark ? "btn_notice_night" : "btn_notice")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width - 40)
                                .padding(.horizontal, 20)
                        }
                    }

                    if isConnected {
                        NavigationLink(destination: MenuView()) {
                            Image(colorScheme == .dark ? "btn_menu_night" : "btn_menu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width - 40)
                                .padding(.horizontal, 20)
                        }
                    } else {
                        Button(action: {
                            showNoInternetAlert = true
                        }) {
                            Image(colorScheme == .dark ? "btn_menu_night" : "btn_menu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width - 40)
                                .padding(.horizontal, 20)
                        }
                    }

                    HStack {
                        if isConnected {
                            NavigationLink(destination: GoingOutView()) {
                                Image(colorScheme == .dark ? "btn_goingout_night" : "btn_goingout")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (geometry.size.width / 2) - 24)
                            }
                        } else {
                            Button(action: {
                                showNoInternetAlert = true
                            }) {
                                Image(colorScheme == .dark ? "btn_goingout_night" : "btn_goingout")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (geometry.size.width / 2) - 24)
                            }
                        }

                        Button(action: {
                            openAppOrRedirectToStore(urlScheme: "metaclub://", appStoreURL: "https://apps.apple.com/kr/app/%EB%A9%94%ED%83%80%ED%81%B4%EB%9F%BD/id6444430778")
                        }) {
                            Image(colorScheme == .dark ? "btn_washer_night" : "btn_washer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: (geometry.size.width / 2) - 24)
                        }
                    }.padding(.horizontal, 0)

                    Text("1.7.0 gbnam")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .padding(.bottom, 10)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color("color_background"))
                .edgesIgnoringSafeArea(.bottom) // 하단의 Safe Area만 무시
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // iPad에서의 레이아웃 문제 방지
        .onAppear {
            checkInternetConnection()
        }
        .alert(isPresented: $showNoInternetAlert) {
            Alert(
                title: Text("인터넷이 연결되어 있지 않아요"),
                message: Text("연결 상태를 다시 확인해주세요"),
                dismissButton: .default(Text("확인"))
            )
        }
    }

    // ✅ 인터넷 연결 확인 (NWPathMonitor 사용)
    private func checkInternetConnection() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }

    func openAppOrRedirectToStore(urlScheme: String, appStoreURL: String) {
        if let url = URL(string: urlScheme) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                if let appStoreUrl = URL(string: appStoreURL) {
                    UIApplication.shared.open(appStoreUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
