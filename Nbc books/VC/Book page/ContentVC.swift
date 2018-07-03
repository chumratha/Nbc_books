//
//  ContentVC.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/3/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

class ContentVC: UIViewController {
    
    var imageUrl: String? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        let cgRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let imageView = UIImageView(frame: cgRect)
        imageView.contentMode = .scaleAspectFit
        
        let url = URL(string : imageUrl!)
        imageView.contentMode = .scaleAspectFit
        if let _url = url {
            loadImage(_url, imageView: imageView)
        }
        self.view.addSubview(imageView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImage(_ url: URL, imageView : UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
