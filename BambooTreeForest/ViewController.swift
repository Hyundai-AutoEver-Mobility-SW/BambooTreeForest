//
//  ViewController.swift
//  BambooTreeForest
//
//  Created by 정한얼 on 12/19/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    // Firestore에서 불러온 데이터를 저장할 배열
    var posts: [(title: String, createdAt: String, content: String, commentCount: Int, isLiked: Bool)] = []
    
    
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
    }
    
    // 테이블뷰에 보여줄 데이터 배열
    // var dataArray = ["첫번째 항목", "두번째 항목", "세째 항목"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 델리게이트 연결
        tableView.delegate = self
        tableView.dataSource = self
        // Firestore에서 데이터 읽기
        fetchDataFromFirestore()
    }
    // Firestore에서 데이터를 가져오는 함수
        func fetchDataFromFirestore() {
            db.collection("posts").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Firestore 데이터 가져오기 실패: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                // Firestore 문서 데이터를 배열에 저장
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
                
                // 테이블 뷰 업데이트 (추가된 부분)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
}

// 테이블뷰 관련 메서드들
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // 행 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        let post = posts[indexPath.row]
                // Firestore에서 가져온 데이터 표시
                cell.titleLabel.text = post.title // 제목 표시
        cell.dateLabel.text = post.createdAt
        cell.descLabel.text = post.content
                
        return cell
    }
    
    // 셀 선택 시 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번 셀 선택됨")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

