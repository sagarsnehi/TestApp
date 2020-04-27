//
//  ImageViewModel.swift
//  WiproTest
//
//  Created by sagar snehi on 17/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import Foundation

class ImageViewModel {
    var cellModel = [RowsData]()
    var response : DataResponse?
    var navTitle  = ""
    
    func fetchImageDetails(completion: @escaping (_ error: Error?) -> Void){
        let resource = prepareImageResource()
        _ = URLSession.shared.load(resource){ (result) in
            switch result{
            case .error(let error):
                print("Error while fetching data: \(error)")
                completion(error)
            case .success(let testData):
                DispatchQueue.main.async {
                    self.prepareModel(response: testData)
                }
                completion(nil)
            }
        }
    }
    
    func prepareImageResource() -> Resource<DataResponse> {
        let url = URLFactory.shared.prepareDataURL()
        return Resource(url: url)
    }
    
    func prepareModel(response : DataResponse){
        self.cellModel = (response.rows ?? nil)!
        self.navTitle = response.title ?? "No title"
    }
    
    func numberOfSections() -> Int{
        return 1
    }
    
    func numberOfItemInSection() -> Int{
        return cellModel.count
    }
    
    func getModelForCell(index : IndexPath) -> RowsData{
        return cellModel[index.row]
    }
}
