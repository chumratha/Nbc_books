//
//  PageVC.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/2/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

class PageVC: UIViewController , UIPageViewControllerDataSource , UIPageViewControllerDelegate {

    var pageController: UIPageViewController!
    var controllers = [ContentVC]()
    var book: Book! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create page with curl transition
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        
//        let views = ["pageController": pageController.view] as [String: AnyObject]
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        pageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let books = book.pages
        for (index, element) in books.enumerated() {
            let vc = ContentVC()
            vc.imageUrl = element.url
            vc.pageIndex = index + 1
            controllers.append(vc)
        }
        // set first view for display
        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController as! ContentVC) {
            if index > 0 {
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController as! ContentVC) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        
        return nil
    }

    
    
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
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
