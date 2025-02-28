import SwiftUI
import SwiftSoup

struct MenuView: View {
    @State private var imageUrl: String?
    private let url = "https://happydorm.hoseo.ac.kr"
    
    var body: some View {
        VStack {
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } placeholder: {
                    ZStack {
                        Color("color_background")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5) // ✅ 크기 조정 (선택 사항)
                    }
                }
            } else {
                ZStack {
                    Color("color_background")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(1.5) // ✅ 크기 조정 (선택 사항)
                }
            }
        }
        .background(Color("color_background"))
        .onAppear {
            fetchImage()
        }
        .navigationBarTitle("식단표", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(currentDateString())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func fetchImage() {
        DispatchQueue.global(qos: .background).async {
            let html = try! String(contentsOf: URL(string: self.url)!)
            let doc: Document = try! SwiftSoup.parse(html)
            let src = try! doc.select(".col-md-4 div.content.notice-slide a img").first()!.attr("src")
            DispatchQueue.main.async {
                self.imageUrl = self.url + src
            }
        }
    }
    
    private func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d(E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: Date())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuView()
        }
    }
}
