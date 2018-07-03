//
//  ListBooksVC.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/1/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ListBooksVC: UICollectionViewController {
    
    let flowlayout = UICollectionViewFlowLayout()
    var listBook :[Book] = []
    
    init() {
        super.init(collectionViewLayout: flowlayout)
        fetchData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // title
        self.title = "Books"
        // Register cell classes
        setupObjectLayout()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func setupObjectLayout()  {
        let frame = self.view.frame
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 10
        let space:CGFloat = 10
        flowlayout.itemSize = CGSize(width: (frame.size.width - space*5) / 3 , height: frame.size.height * 0.25)
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(5, 10, 10, 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listBook.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell
        let book = listBook[indexPath.row]
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: flowlayout.itemSize.width, height: flowlayout.itemSize.height))
        if book.pages.count > 0 {
            imageV.contentMode = .scaleAspectFit
            let url = book.pages[0].url
            imageV.sd_setImage(with: URL(string: url!)!, completed: nil)
        }
        cell.addSubview(imageV)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageVC = PageVC()
        pageVC.book = listBook[indexPath.row]
        navigationController?.pushViewController(pageVC, animated: true)
    }
    
    func fetchData() {
        let ws = WSListBooks()
        ws.request(success: { (d) in
            self.listBook = d as! [Book]
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }) { (error) in
            
        }
    }

}
