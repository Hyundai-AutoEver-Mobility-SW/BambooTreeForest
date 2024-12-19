import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    // @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView! // 지우면 에러남
    
    let db = Firestore.firestore()
    var posts: [(title: String, createdAt: String, content: String, commentCount: Int, isLiked: Bool)] = []
    
    // 스크롤 뷰 생성
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = false // 가로 스크롤 활성화
               scrollView.alwaysBounceVertical = true  // 세로 스크롤 비활성화
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let imageView: UIImageView = {
        let aImageView = UIImageView()
        aImageView.image = UIImage(named: "Frame") // 배경 이미지 설정
        aImageView.contentMode = .scaleAspectFill
        aImageView.clipsToBounds = true
        aImageView.translatesAutoresizingMaskIntoConstraints = false
        return aImageView
    }()

    let boxView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear // 기존 배경색 제거
            view.layer.cornerRadius = 30 // 모서리 둥글게 설정
            view.layer.borderWidth = 1 // 테두리 두께 설정
            view.layer.borderColor = UIColor.white.cgColor // 테두리 색상 설정

            // 박스 배경 이미지 설정
            if let backgroundImage = UIImage(named: "redBox") {
                view.layer.contents = backgroundImage.cgImage // CALayer에 이미지 설정
                view.layer.contentsGravity = .resizeAspectFill // 이미지 크기 비율 유지
                view.layer.masksToBounds = true // 경계를 넘는 이미지 잘라내기
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 배경 이미지 추가
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // 스크롤 뷰 추가
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Firestore 데이터 가져오기
        fetchDataFromFirestore()
    }

    func fetchDataFromFirestore() {
        db.collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Firestore 데이터 가져오기 실패: \(error)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            self.posts = documents.compactMap { doc -> (String, String, String, Int, Bool)? in
                let data = doc.data()

                guard
                    let title = data["title"] as? String,
                    let createdAt = data["createdAt"] as? String,
                    let content = data["content"] as? String,
                    let commentCount = data["commentCount"] as? Int,
                    let isLiked = data["isLiked"] as? Bool
                else { return nil }

                return (title, createdAt, content, commentCount, isLiked)
            }

            DispatchQueue.main.async {
                self.setupBoxes()
            }
        }
    }

    func setupBoxes() {
        var previousBox: UIView? = nil
        let boxMargin: CGFloat = 20

        for (index, data) in posts.enumerated() {
            let boxView = createBoxView(title: data.title, description: data.content)
            scrollView.addSubview(boxView)

            NSLayoutConstraint.activate([
                boxView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
                boxView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30),
                boxView.heightAnchor.constraint(equalToConstant: 500),
                boxView.widthAnchor.constraint(equalToConstant: 280)
            ])

            if let previousBox = previousBox {
                boxView.topAnchor.constraint(equalTo: previousBox.bottomAnchor, constant: boxMargin).isActive = true
            } else {
                boxView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
            }

            previousBox = boxView

            if index == posts.count - 1 {
                boxView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
            }
        }
    }

    func createBoxView(title: String, description: String) -> UIView {
        let boxView = UIView()
        boxView.backgroundColor = UIColor.clear // 투명 배경
        boxView.layer.cornerRadius = 30
        boxView.layer.borderWidth = 1
//        boxView.layer.borderColor = UIColor.lightGray.cgColor
        boxView.translatesAutoresizingMaskIntoConstraints = false

        // 배경 이미지 추가
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "redBox")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        boxView.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: boxView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor)
        ])

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        boxView.addSubview(titleLabel)
        boxView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -10)
        ])

        return boxView
    }
}

