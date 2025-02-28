import SwiftUI
import WebKit

struct NoticeView: View {
    var body: some View {
        VStack {
            WebView(url: URL(string: "http://gbnam.dothome.co.kr/happydorm/notice.html")!)
                .onAppear {
                    print("WebView shown")
                }
        }
        .background(Color("color_background"))
        .navigationBarTitle("공지사항", displayMode: .inline)
        .navigationBarBackButtonHidden(false) // 기본 백 버튼 유지
        .onAppear {
            setBackButtonText()
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func setBackButtonText() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear] // 텍스트 숨기기
        appearance.backButtonAppearance.normal.backgroundImage = UIImage() // 기본 화살표 이미지를 사용

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "뒤로" // "뒤로" 텍스트 설정
        backButtonItem.tintColor = UIColor.gray // 화살표 색상 설정
        UINavigationBar.appearance().topItem?.backBarButtonItem = backButtonItem
    }
}

#Preview {
    NoticeView()
}
