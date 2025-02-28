import Foundation
import SwiftUI
import Combine

struct ImageZoomRepresentable<Content: View>: UIViewControllerRepresentable {
    
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeUIViewController(context: Context) -> ImageZoomViewController {
        let vc = ImageZoomViewController()
        vc.hostingController.rootView = AnyView(self.content())
        return vc
    }

    func updateUIViewController(_ viewController: ImageZoomViewController, context: Context) { }
}


class ImageZoomViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        return v
    }()
    
    var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))

    var zoomScale: CGFloat = 0 {
        didSet {
            if zoomScale > 1.0 {
                scrollView.isScrollEnabled = true
            } else {
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.parentConstraint(of: self.scrollView, to: self.view) // scrollview -> view

        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.childConstraint(of: self.hostingController.view, to: self.scrollView, isZoom: false) // image -> scrollview
        self.hostingController.didMove(toParent: self)
        
        scrollView.maximumZoomScale = 2.5
        scrollView.minimumZoomScale = 1
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        
        scrollView.addGestureRecognizer(tapRecognizer)
        
        scrollView.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            initScrollContent()
        }
    }
    
    //MARK: - View Constraint
    //가장 부모 뷰와 스크롤뷰에 대한 위치 제약조건 (ScrollView)
    func parentConstraint(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor)
        ])
    }
    
    //스크롤뷰와 자식 뷰에 대한 위치 제약조건 (Content (Image))
    func childConstraint(of viewA: UIView, to viewB: UIView, isZoom: Bool) {
        viewA.translatesAutoresizingMaskIntoConstraints = false

        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
            viewA.heightAnchor.constraint(equalToConstant: 270)
        ])
    }
    
    // 더블 클릭했을때 이미지 원복
    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        initScrollContent()
    }
    
    // init 시에 부모 뷰와 scrollview content 를 정렬
    func initScrollContent() {
        scrollView.setZoomScale(1.0, animated: true)
        zoomScale = 1.0
        
        let offsetX = max((self.view.bounds.size.width - self.hostingController.view.frame.width) * 0.5, 0.0)
        let offsetY = max((self.view.bounds.size.height - self.hostingController.view.frame.height) * 0.5, 0.0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX);
    }
}

extension ImageZoomViewController: UIScrollViewDelegate {
    //MARK: - ScrollView Zoom On
    // 줌 하고자 하는 뷰를 리턴한다.
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.hostingController.view
    }
    
    //MARK: - ScrollView Zoom 최대치, 최소치 컨트롤
    // 스크롤 할때마다 계속 호출하여 현재 줌 스케일 값을 할당한다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        zoomScale = scrollView.zoomScale
    }
    
    //MARK: - ScrollView Zoom End
    // scrollview Zoom 완료시에 scrollview content를 중간으로 정렬함
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX);
    }
}
