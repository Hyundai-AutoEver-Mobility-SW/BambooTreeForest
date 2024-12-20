import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    // @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView! // 지우면 에러남
    
    private let viewModel = MainViewModel()
    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 배경 뷰 설정
        setupBackgroundView()

        // 스크롤 뷰 설정
        setupScrollView()

        // Firestore 데이터 가져오기
        fetchPosts()
    }

    private func setupBackgroundView() {
        let backgroundView = BackgroundView(frame: view.bounds)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = false // 가로 스크롤 비활성화
        scrollView.alwaysBounceVertical = true // 세로 스크롤 활성화
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchPosts() {
        viewModel.fetchPosts { [weak self] in
            DispatchQueue.main.async {
                self?.setupBoxes()
            }
        }
    }

    private func setupBoxes() {
        var previousBox: UIView? = nil
        let boxMargin: CGFloat = 20
        for (index, data) in viewModel.posts.enumerated() {
                let postBox = PostBoxView(
                    title: data.title,
                    date: data.createdAt,
                    content: data.content,
                    commentCount: data.commentCount,
                    isLiked: data.isLiked
                )
                scrollView.addSubview(postBox)

            NSLayoutConstraint.activate([
                postBox.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
                postBox.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30),
                postBox.heightAnchor.constraint(equalToConstant: 500),
                postBox.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -60) // 30 + 30
            ])


            if let previousBox = previousBox {
                postBox.topAnchor.constraint(equalTo: previousBox.bottomAnchor, constant: boxMargin).isActive = true
            } else {
                postBox.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
            }

            previousBox = postBox

            if index == viewModel.posts.count - 1 {
                postBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
            }
        }
    }
}
