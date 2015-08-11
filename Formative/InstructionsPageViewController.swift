//
//  InstructionsPageViewController.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse

class InstructionsPageViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageData = parseJSON(NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("instructions", ofType: "json")!)!) as! Array<Array<String>>
    
    override func viewDidLoad() {
        print(pageData)
        var pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        
        var startingViewController = viewControllerAtIndex(0)
        pageViewController.setViewControllers([startingViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        pageViewController.view.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! InstructionsContentVC).pageIndex
        index = index-1
        if (index < 0)
        {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! InstructionsContentVC).pageIndex
        index = index + 1
        if (index >= pageData.count)
        {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> InstructionsContentVC
    {
        var vc = storyboard?.instantiateViewControllerWithIdentifier("InstructionsContentVC") as! InstructionsContentVC
        vc.pageData = pageData[index];
        vc.pageIndex = index
        
        return vc
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageData.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
