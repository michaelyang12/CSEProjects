//
//  SearchHistoryModal.swift
//  michaelyang-lab4
//
//  Created by Michael Yang on 11/1/21.
//

import UIKit

class SearchHistoryModal: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var copyLabel: UILabel!
    
    var history: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    //set table cells to respective info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = history[indexPath.row]
        
        return cell
    }
    
    //onclick
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = history[indexPath.row]
        copyLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        //show label for 3 seconds
            self.copyLabel.isHidden = true
        }
    }
    
    func setupTableView() {
        table.dataSource = self
        table.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        copyLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear() {
//        setupTableView()
//        // Do any additional setup after loading the view.
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
