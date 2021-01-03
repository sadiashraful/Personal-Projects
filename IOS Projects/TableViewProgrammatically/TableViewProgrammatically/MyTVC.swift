//
//  ViewController.swift
//  TableViewProgrammatically
//
//  Created by Mohammad Ashraful Islam Sadi on 1/1/21.
//

import UIKit

class MyTVC: UIViewController {
    
    
    
    private var tableViewDataArrayTitle = ["January", "February", "March", "April", "May",
                                      "June", "July", "August", "September", "October",
                                       "November", "December"]
    private var tableViewDataArraySubtitle = ["First Month", "Second Month", "Third Month", "Fourth Month", "Fifth Month",
                                              "Sixth Month", "Seventh Month", "Eighth Month", "Nineth Month", "Tenth Month",
                                               "Eleventh Month", "Twelveth Month"]
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight), style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        setUpTableViewHeaderView()
    }
    
    private func setUpTableViewHeaderView() {
        let headerView: UIView = UIView.init(frame: CGRect(x: 1, y: 50, width: 276, height: 60))
        headerView.backgroundColor = .red
        
        let labelViewinHeader: UILabel = UILabel.init(frame: CGRect(x: 4, y: 5, width: 276, height: 40))
        labelViewinHeader.text = "TableView Header View"
        headerView.addSubview(labelViewinHeader)
        self.tableView.tableHeaderView = headerView

        labelViewinHeader.centerX(inView: headerView)
        labelViewinHeader.centerY(inView: headerView)
        
        let editbutton: UIButton = {
           let button = UIButton()
            button.setTitle("Edit", for: .normal)
            button.titleLabel?.textColor = .white
            return button
        }()
        
        headerView.addSubview(editbutton)
        editbutton.centerY(inView: headerView)
        editbutton.anchor(left: headerView.safeAreaLayoutGuide.leftAnchor,
                          paddingLeft: 20)
        editbutton.addTarget(self, action: #selector(toggleEditingMode), for: .touchUpInside)
        
        let addbutton: UIButton = {
           let button = UIButton()
            button.setTitle("Add", for: .normal)
            button.titleLabel?.textColor = .white
            return button
        }()
        
        headerView.addSubview(addbutton)
        addbutton.centerY(inView: headerView)
        addbutton.anchor(right: headerView.safeAreaLayoutGuide.rightAnchor,
                          paddingRight: -20)
        addbutton.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
    }
    
    @objc private func toggleEditingMode(byUser sender: UIButton) {
        // If you are currently in editing mode.....
        if isEditing {
            // Change the text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    @objc private func addNewItem(byUser sender: UIButton) {
        let newMonth = "MonthX"
        if let index = tableViewDataArrayTitle.firstIndex(of: newMonth) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

//    private func fetchData() {
//        guard let url = URL(string: "https://myexample.com/api/which_return_json_data") else { return }
//        let params = "page=1&type=Car"
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = params.data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error != nil {
//                print(error.debugDescription)
//                return
//            } else if data != nil {
//                DispatchQueue.main.async {
//                    do {
//
//                    }
//                }
//            }
//        }
//    }

}

extension MyTVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataArrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        cell.textLabel!.text = "\(tableViewDataArrayTitle[indexPath.row])"
        cell.detailTextLabel?.text = tableViewDataArraySubtitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TableView titleForHeaderInSection()"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "TableView titleForFooterInSection()"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableViewDataArrayTitle.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MyTVC: UITableViewDelegate {
    
}

