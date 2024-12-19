import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var posts: [(title: String, createdAt: String, content: String, commentCount: Int, isLiked: Bool)] = []
    

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
    
    // 제목, 날짜, 내용 레이블 추가
    let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(hex: "#000") // 텍스트 색상
            label.font = UIFont(name: "Kodchasan", size: 20) // 폰트와 크기
            label.numberOfLines = 1
            label.textAlignment = .center // 중앙 정렬
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    @IBAction func writeButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowWriteVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWriteVC" {
            if let writeVC = segue.destination as? WriteViewController {
                // 데이터 전달
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 이미지 추가
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        // boxView 추가
        view.addSubview(boxView)
        let margin: CGFloat = 30
        NSLayoutConstraint.activate([
            boxView.heightAnchor.constraint(equalToConstant: 500), // 높이 500으로 설정
            boxView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin), // 상단 마진
                boxView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin), // 좌측 마진
                boxView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin) // 우측 마진
        ])
        
        boxView.addSubview(titleLabel)
                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 20), // 상단에서 20pt 떨어짐
                    titleLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),
                    titleLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -20),
                ])

        // tableView를 boxView 안에 추가
//        boxView.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 20), // 상단 패딩
//            tableView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -20), // 하단 패딩
//            tableView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20), // 좌측 패딩
//            tableView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -20), // 우측 패딩
//        ])
//
//        // Firestore 데이터 및 델리게이트 연결
//        tableView.delegate = self
//        tableView.dataSource = self
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
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell

        let post = posts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.dateLabel.text = post.createdAt
        cell.descLabel.text = post.content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번 셀 선택됨")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
