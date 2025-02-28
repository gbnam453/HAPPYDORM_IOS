import SwiftUI

struct GoingOutView: View {
    var body: some View {
        VStack {
            WebView_GoingOut(url: URL(string: "http://gbnam.dothome.co.kr/happydorm/goingout.html")!)
                .onAppear {
                    print("WebView shown")
                }
        }
        .background(Color("color_background"))
        .navigationBarTitle("외출/외박신청", displayMode: .inline)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            setBackButtonText()
            print("GoingOutView appeared")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(currentDateString())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private func setBackButtonText() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance.normal.backgroundImage = UIImage()

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "뒤로"
        backButtonItem.tintColor = UIColor.gray
        UINavigationBar.appearance().topItem?.backBarButtonItem = backButtonItem
    }

    private func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d(E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: Date())
    }
}

#Preview {
    GoingOutView()
}
