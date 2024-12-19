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
    var dataArray: [String] = []
    
    
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
                
                // Firestore 문서 데이터를 배열에 저장 (추가된 부분)
                self.dataArray = documents.compactMap { $0.data()["title"] as? String }
                
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
        return dataArray.count
    }
    
    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        cell.titleLabel.text = dataArray[indexPath.row]
        cell.descLabel.text = "파이어스토어에서 \(indexPath.row + 1)"
        
        return cell
    }
    
    // 셀 선택 시 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번 셀 선택됨")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

