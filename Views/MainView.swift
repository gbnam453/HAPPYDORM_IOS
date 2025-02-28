import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme

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

                    NavigationLink(destination: NoticeView()) {
                        Image(colorScheme == .dark ? "btn_notice_night" : "btn_notice")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width - 40)
                            .padding(.horizontal, 20)
                    }

                    NavigationLink(destination: MenuView()) {
                        Image(colorScheme == .dark ? "btn_menu_night" : "btn_menu")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width - 40)
                            .padding(.horizontal, 20)
                    }

                    HStack {
                        NavigationLink(destination: GoingOutView()) {
                            Image(colorScheme == .dark ? "btn_goingout_night" : "btn_goingout")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: (geometry.size.width / 2) - 24)
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
        .navigationViewStyle(StackNavigationViewStyle()) // iPad에서의 레이아웃 문제를 방지하기 위해 추가
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
