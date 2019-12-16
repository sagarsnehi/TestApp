//
//  ViewController.swift
//  WiproTest
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //declare object
    var imageDetails : DataResponse?
    var navTitle = ""
    var imageTableView = UITableView()
    let cellId = "imageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.delegate = self
        imageTableView.dataSource = self
        self.setupUI()
        self.getImageDetails(){(imageData) in
            if let imagedata = imageData{
                self.imageDetails = imagedata
                self.navTitle = imageData?.title ?? ""
            }
            DispatchQueue.main.async {
                self.navigationItem.title = self.navTitle
                self.imageTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.view.backgroundColor = kTestColor
        self.view.addSubview(imageTableView)
        imageTableView.backgroundColor = .clear
        imageTableView.separatorColor = .white
        imageTableView.register(CustomTVC.self, forCellReuseIdentifier: cellId)
        self.addConstraint()
    }
    
    func addConstraint(){
        self.imageTableView.translatesAutoresizingMaskIntoConstraints = false
        self.imageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.imageTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.imageTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.imageTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        
    }
    
    fileprivate func getImageDetails(completion: @escaping (_ imagedata: DataResponse?) -> Void){
        let resource = prepareImageResource()
        _ = URLSession.shared.load(resource){ (result) in
            switch result{
            case .error(let error):
                print("Error banner API: \(error)")
                completion(nil)
            case .success(let testData):
                completion(testData)
            }
        }
    }
    func prepareImageResource() -> Resource<DataResponse> {
        let url = URLFactory.shared.prepareDataURL()
        return Resource(url: url)
    }

}
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageDetails?.rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CustomTVC{
            cell.imageData = imageDetails?.rows?[indexPath.row]
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = .white
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UITableView.automaticDimension > 100) ? UITableView.automaticDimension : 100
    }
    
}
