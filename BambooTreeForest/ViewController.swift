import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    // Firestore에서 불러온 데이터를 저장할 배열
    var dataArray: [String] = []
    var documentIds: [String] = [] // Firestore 문서 ID 배열
    var selectedDocumentId: String?
    
    // Bar Button Item 눌렀을 때 실행되는 액션
    @IBAction func writeButtonTapped(_ sender: UIBarButtonItem) {
        // ShowWriteVC는 스토리보드에서 설정한 세그웨이 Identifier
        performSegue(withIdentifier: "ShowWriteVC", sender: nil)
    }
    
    // 세그웨이가 실행되기 전에 호출되는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWriteVC" {
            if let writeVC = segue.destination as? WriteViewController {
                // 여기서 WriteViewController로 데이터 전달
                // 예: writeVC.someData = data
            }
        }
        if segue.identifier == "ShowCommentVC" {
//            if let commentVC = segue.destination as? CommentViewController {
//                // 선택된 문서 ID를 전달
//                commentVC.receivedId = selectedDocumentId
//                guard let id = selectedDocumentId else {
//                    print("문서 ID를 전달받지 못했습니다.")
//                    return
//                }
//                commentVC.receivedId = id
//            }
            if segue.identifier == "ShowCommentVC", let commentVC = segue.destination as? CommentViewController, let postId = sender as? String {
                    commentVC.receivedId = postId
                }
        }
    }
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
        // Firestore에서 데이터를 가져오는 함수
        func fetchDataFromFirestore() {
            db.collection("posts").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Firestore 데이터 가져오기 실패: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                // Firestore 문서 데이터를 배열에 저장 (추가된 부분)
                self.dataArray = documents.compactMap { $0.data()["title"] as? String }
                self.documentIds = documents.map { $0.documentID }
                
                // 테이블 뷰 업데이트 (추가된 부분)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
// 정환이 페이지 이동 관련 코드들
// 테이블뷰 관련 메서드들
extension ViewController: UITableViewDelegate, UITableViewDataSource, CustomTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        cell.titleLabel.text = dataArray[indexPath.row]
        cell.descLabel.text = "파이어스토어에서 \(indexPath.row + 1)"
        cell.delegate = self // 델리게이트 설정
        
        return cell
    }
    
    
    // 정환이 페이지 이동 관련 코드들
    func didTapButton(in cell: CustomTableViewCell) {
        // 버튼이 눌린 셀의 indexPath 가져오기
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // 선택된 문서 ID 저장
        selectedDocumentId = documentIds[indexPath.row]
//        print("버튼 클릭됨 - 선택된 문서 ID: \(selectedDocumentId ?? "")")
        
        // Segue 호출
//        performSegue(withIdentifier: "ShowCommentVC", sender: nil)
    }

    private func setupBoxes() {
        var previousBox: UIView? = nil
        let boxMargin: CGFloat = 20
        for (index, data) in viewModel.posts.enumerated() {
                let postBox = PostBoxView(
                    id: data.id,
                    index: index,
                    title: data.title,
                    date: data.createdAt,
                    content: data.content,
                    commentCount: data.commentCount,
                    isLiked: data.isLiked,
                    onCommentButtonTapped: { [weak self] in
                        print("댓글 버튼 클릭 - 문서 ID: \(data.id)")
                        self?.navigateToCommentPage(postId: data.id)
                    },
                    onHeartButtonClicked: { [weak self] newLikedState in
                        self?.updateFirestoreLikedStatus(postId: data.id, newLikedState: newLikedState)
                    }
                    
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
    private func navigateToCommentPage(postId: String) {
        // 댓글 페이지로 이동하는 로직 구현
        performSegue(withIdentifier: "ShowCommentVC", sender: postId)
    }
    private func updateFirestoreLikedStatus(postId: String, newLikedState: Bool) {
        Firestore.firestore().collection("posts").document(postId).updateData([
            "isLiked": newLikedState
        ]) { error in
            if let error = error {
                print("하트 상태 업데이트 실패: \(error)")
            } else {
                print("하트 상태 업데이트 성공: \(newLikedState)")
            }
        }
    }
}
