//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Vadym Piatkovskyi on 10/1/18.
//  Copyright © 2018 Vadym Piatkovskyi. All rights reserved.
//

import UIKit
import QuartzCore

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var simpleView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        
        return UIScreen.main.bounds.height - (UIScreen.main.focusedView?.frame.size.height ?? 250 / 2 + UIApplication.shared.statusBarFrame.height)
    }
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //making blure effect
//        prepareBackgroundView()
        //making rounded corners
        prepareAdditionalViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    //MARK: Actions
    @IBAction func close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
    }
    
    //MARK: Gestures
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    //MARK: UI Methods
    private func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    private func prepareAdditionalViews() {
        self.makeRounded(view: self.view, radius: 15)
        self.dropShadow(view: self.view)
        
        self.makeRounded(view: self.simpleView, radius: 5)
        self.dropShadow(view: self.simpleView)
        
        self.dropShadow(view: self.closeBtn)
    }
    
    //MARK: Corners
    private func makeRounded(view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
    }
    
    //MARK: Shadows
    private func dropShadow(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 0, height: -2.5)
    }
}
