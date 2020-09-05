//
//  ViewController.swift
//  MMAssignment
//
//  Created by Harshal Dhokate on 05/09/20.
//  Copyright © 2020 Harshal Dhokate. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    //MARK:- Properties
    var imageDetails: [ImageInfo]?
    var imageDecodeData: [ImageData]?
    let imagePathUrl = "https://picsum.photos/300/300?image"
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Lorem Picsum"
        
        //Get Image Information data from WebCall
        self.webCallForGettingIMageInformation()
    }
    
    //MARK:- Web Call
    func webCallForGettingIMageInformation() {
        //Create a URL from string
        let strUrlPath = "https://picsum.photos/list"
        
        guard let url = URL(string: strUrlPath) else{
            return
        }
        
        //Request creation
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: .infinity)
        request.httpMethod = "GET"
        
        //Task URLSession
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            print("The Response is : ",response)
            
            do{
                //Get the Decoder object
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode([ImageData].self, from: data!)
                self.imageDecodeData = responseModel
                
                //Reload 
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    //MARK:- UICollection View Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDecodeData?.count ?? 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CustomCell else {
            
             fatalError("Unable to dequeue Custome Cell")
        }
        
        let imageDetails = imageDecodeData?[indexPath.row]
        
        //Set Author Name
        if let author = imageDetails?.author {
            cell.lblAuthorName.text = author
        }
        //Set images according to id
        if let imageId = imageDetails?.id {
            cell.imageView.loadImage(url: URL(string: "\(self.imagePathUrl)+\(imageId)")!)
        }
        
        return cell
    }

}

extension UIImageView {
     func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
