//
//  ScrollViewController.swift
//  apple
//
//  Created by zqy on 2022/11/10.
//

import UIKit

class ScrollViewController: UIViewController {

    lazy var hScroll: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    var timer:Timer? = nil

    private var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "scroll";

        let width = self.view.bounds.width;
        
        self.hScroll.frame = CGRect(x: 0, y: 40, width: width, height: 200);
        hScroll.contentSize = CGSize(width: 5 * width, height: 0)
        hScroll.showsHorizontalScrollIndicator = false
        hScroll.showsVerticalScrollIndicator = false
        hScroll.delegate = self
        self.view.addSubview(hScroll)
        
        let colorArray:[UIColor] = [.yellow, .red, .green, .yellow, .red]
        
        for i in 0...4 {
            let view = UIView(frame: CGRect(x: CGFloat(i) * width + 10, y: 0, width: width - 20, height: 200))
            view.backgroundColor = colorArray[i];
            self.hScroll.addSubview(view)
        }
        
        addPageControl()
        
        scrollTo(crtPage: 1 , animated: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelTimer()
    }
    
    func initTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    func addPageControl() {
        self.pageControl = UIPageControl.init(frame: CGRect(x: 0, y: self.hScroll.frame.maxY + 22, width: self.view.bounds.size.width, height: 22))
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.contentHorizontalAlignment = .center
        self.pageControl.backgroundColor = .black
        self.view.addSubview(self.pageControl)
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
    }

    func scrollTo(crtPage: Int, animated: Bool) {
        self.hScroll.setContentOffset(CGPoint.init(x: self.view.bounds.size.width * CGFloat(crtPage), y: 0), animated: animated)
    }
    
    @objc func nextPage() {
        let crtPage = lroundf(Float(self.hScroll.contentOffset.x/self.view.bounds.size.width))

        scrollTo(crtPage: crtPage + 1, animated: true)
    }
    
    deinit {
        cancelTimer()
    }
    
    func cancelTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        
        let x =  self.view.bounds.size.width
        
        if offset <= 0 {
            scrollTo(crtPage: 3, animated: false)
            self.pageControl.currentPage = 2
        } else if offset >= 4 * x {
            scrollTo(crtPage: 1, animated: false)
            self.pageControl.currentPage = 0
        } else {
           self.pageControl.currentPage = lroundf(Float(offset/x)) - 1
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // pause
        self.timer?.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // resume
        self.timer?.fireDate = Date.init(timeIntervalSinceNow: 5)
    }
    
}
