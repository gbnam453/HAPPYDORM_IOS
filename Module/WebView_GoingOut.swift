import SwiftUI
import WebKit

struct WebView_GoingOut: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView_GoingOut

        init(_ parent: WebView_GoingOut) {
            self.parent = parent
        }

        // 특정 URL이 열릴 때 리다이렉트 처리
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                print("현재 URL: \(url)")

                // ✅ 특정 URL이 열리면 리다이렉트 처리
                if url == "https://happydorm.hoseo.ac.kr/" {
                    let newURL = URL(string: "https://happydorm.hoseo.ac.kr/dormitory/view")!
                    webView.load(URLRequest(url: newURL))
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}
