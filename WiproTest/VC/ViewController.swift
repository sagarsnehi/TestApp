//
//  ViewController.swift
//  WiproTest
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //ViewModel
    var viewModel = ImageViewModel()
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var navTitle = ""
    var imageTableView = UITableView()
    private let refreshControl = UIRefreshControl()
    let cellId = "imageCell"
    
    ///viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.delegate = self
        imageTableView.dataSource = self
        self.setupUI()
        self.navigationItem.title = "No title"
        self.loadData()
        
    }
    
    ///Load data
    func loadData(){
        if Reachability.isConnectedToNetwork() {
            imageTableView.isHidden = true
            self.startActivityIndicator()
            self.fetchImageData()
        }
        else{
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.loadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            controller.addAction(cancel)
            controller.addAction(retryAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
    func fetchImageData(){
        self.viewModel.fetchImageDetails { [weak self] error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error.debugDescription)
                }
                self?.setupUIToDisplayData()
                return
            }
        }
    }
    
    func setupUIToDisplayData(){
        imageTableView.isHidden = false
        self.refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
        imageTableView.reloadData()
        self.navigationItem.title = viewModel.navTitle == "" ? "No title" : viewModel.navTitle
        
    }
    
    func setupUI(){
        self.view.backgroundColor = kTestColor
        self.view.addSubview(imageTableView)
        imageTableView.backgroundColor = kTestColor
        imageTableView.separatorColor = .white
        imageTableView.register(CustomTVC.self, forCellReuseIdentifier: cellId)
        imageTableView.refreshControl = refreshControl
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        let refreshControlAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching image data ...",attributes: refreshControlAttribute)
        
        //contstaints
        self.addConstraint()
    }
    
    @objc private func refreshData(_ sender: Any) {
        //Fetch data
        self.fetchImageData()
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

///Table View delegates and datasource
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if viewModel.numberOfItemInSection() > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = viewModel.numberOfSections()
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No details available."
            noDataLabel.textColor     = .white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
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
