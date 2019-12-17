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
    //ViewModel
    var viewModel = ImageViewModel()
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var navTitle = ""
    var imageTableView = UITableView()
    let cellId = "imageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.delegate = self
        imageTableView.dataSource = self
        self.setupUI()
        self.navigationItem.title = "Test"
        self.loadData()
    }
    
    func loadData(){
        imageTableView.isHidden = true
        self.startActivityIndicator()
        self.viewModel.fetchImageDetails { error in
                   DispatchQueue.main.async {
                       if error != nil{
                           print(error.debugDescription)
                           return
                       }
                       self.setupUIToDisplayData()
                       return
                   }
               }
    }
    
    func setupUIToDisplayData(){
        imageTableView.isHidden = false
        self.activityIndicator.stopAnimating()
        imageTableView.reloadData()
        self.navigationItem.title = viewModel.navTitle
        
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
    func startActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        activityIndicator.color = UIColor.white
        activityIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.view.addSubview(activityIndicator)
    }
}
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.getModelForCell(index: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CustomTVC{
            cell.imageData = cellModel
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
