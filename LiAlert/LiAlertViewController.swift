//
//  LiAlertViewController.swift
//  LiAlert
//
//  Created by zm002 on 15/10/14.
//  Copyright © 2015年 zm002. All rights reserved.
//

import UIKit

func colorFromHex (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class LiAlertViewController: UIViewController,UIGestureRecognizerDelegate {
    
    private var mainView:UIView!
    private var titleLabel:UILabel!
    private var subTitleLabel:UILabel!
    private var customView:UIView!
    
    var strongSelf:LiAlertViewController!
    
    var okAction:((alert:LiAlertViewController) -> Void)?
    var cancelAction:((alert:LiAlertViewController) -> Void)?
    var action:((alert:LiAlertViewController,isOk:Bool) -> Void)?

    
    let vMargin:CGFloat = 20
    let hMargin:CGFloat = 16
    let btnHeight:CGFloat = 40
    
    //默认含有取消按钮
    private var okButtonTitle:String!
    
    var window:UIWindow {
        get {
            return UIApplication.sharedApplication().keyWindow!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.alpha = 0.7
        self.strongSelf = self
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        //只有点击view才能消失--；subview不能
        let tapHideGesture = UITapGestureRecognizer(target: self, action: "hide:")
        tapHideGesture.delegate = self
        self.view.addGestureRecognizer(tapHideGesture)
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        print("viewWillAppear")
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        print("viewDidAppear")
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        print("viewWillLayoutSubviews")
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews")
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    //设置主体view
    private func setupMainView() {
        if self.mainView == nil {
            self.mainView = UIView()
            self.view.addSubview(self.mainView)
            self.mainView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 25))
            self.view.addConstraint(NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -25))
            self.view.addConstraint(NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 80))
            
            self.mainView.layer.cornerRadius = 8
            self.mainView.clipsToBounds = true
            
            self.mainView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    private func setupTitleLabel() {
        if self.titleLabel == nil {
            self.titleLabel = UILabel()
            self.mainView.addSubview(self.titleLabel)
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.titleLabel.textAlignment = NSTextAlignment.Center
            self.titleLabel.font = self.titleLabel.font.fontWithSize(19)
            
            //multi line
            self.titleLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
            self.titleLabel.numberOfLines = 0
            
            self.mainView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10))
            self.mainView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: hMargin))
            self.mainView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -hMargin))
        }
    }
    
    private func setupSubTitleView() {
        if self.subTitleLabel == nil {
            self.subTitleLabel = UILabel()
            self.mainView.addSubview(self.subTitleLabel)
            self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.subTitleLabel.font = self.titleLabel.font.fontWithSize(14)
            
            //multi line
            self.subTitleLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
            self.subTitleLabel.numberOfLines = 0
            
            if self.titleLabel == nil {
                self.mainView.addConstraint(NSLayoutConstraint(item: self.subTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: hMargin))
            } else {
                self.mainView.addConstraint(NSLayoutConstraint(item: self.subTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: vMargin))
            }
            
            self.mainView.addConstraint(NSLayoutConstraint(item: self.subTitleLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: hMargin))
            self.mainView.addConstraint(NSLayoutConstraint(item: self.subTitleLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -hMargin))
            
//            self.mainView.addConstraint(NSLayoutConstraint(item: self.subTitleLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -10))
        }
    }
    
    private func setupButtons(okButtonTitle:String!) {
        let buttonWrapView = UIView()
        self.mainView.addSubview(buttonWrapView)
        buttonWrapView.translatesAutoresizingMaskIntoConstraints = false
        
        //check buttons 上面的view
        var tmp_view:UIView! = nil
        if self.customView != nil {
            tmp_view = self.customView
        } else if self.subTitleLabel != nil {
            tmp_view = self.subTitleLabel
        } else if self.titleLabel != nil {
            tmp_view = self.titleLabel
        }

        if tmp_view == nil {
            self.mainView.addConstraint(NSLayoutConstraint(item: buttonWrapView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: hMargin))
        } else {
            self.mainView.addConstraint(NSLayoutConstraint(item: buttonWrapView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: tmp_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: vMargin))
        }
        
        self.mainView.addConstraint(NSLayoutConstraint(item: buttonWrapView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: hMargin))
        self.mainView.addConstraint(NSLayoutConstraint(item: buttonWrapView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -hMargin))
        self.mainView.addConstraint(NSLayoutConstraint(item: buttonWrapView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.mainView.addConstraint(NSLayoutConstraint(item: buttonWrapView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: btnHeight))
        
        var buttons = [UIButton]()
        let cancelButton = UIButton(type: UIButtonType.Custom)
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.setTitleColor(colorFromHex("#cc9933"), forState: UIControlState.Normal)
        buttons.append(cancelButton)
        
        if okButtonTitle != nil {
            let okButton = UIButton(type: UIButtonType.Custom)
            okButton.setTitleColor(colorFromHex("#339933"), forState: UIControlState.Normal)
            okButton.setTitle(okButtonTitle, forState: UIControlState.Normal)
            buttons.append(okButton)
        }
        
        var pre_button:UIButton! = nil
        for (i,btn) in buttons.enumerate() {
            buttonWrapView.addSubview(btn)
            btn.tag = i + 1
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.addTarget(self, action: "alertAction:", forControlEvents: UIControlEvents.TouchUpInside)
            if pre_button == nil {
                buttonWrapView.addConstraint(NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: buttonWrapView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
            } else {
                buttonWrapView.addConstraint(NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: pre_button, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
                buttonWrapView.addConstraint(NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: pre_button, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
            }
            if i == buttons.count - 1 {
                buttonWrapView.addConstraint(NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: buttonWrapView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
            }
            buttonWrapView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["btn":btn]))
            pre_button = btn
        }
        
    }
    
    private func setupCustomView(view:UIView!) {
        self.customView = view
        if self.customView != nil {
            self.mainView.addSubview(self.customView)
            self.customView.translatesAutoresizingMaskIntoConstraints = false
            var tmp_view:UIView! = nil
            
            //check customview 上面的view
            if self.subTitleLabel != nil {
                tmp_view = self.subTitleLabel
            } else if self.titleLabel != nil {
                tmp_view = self.titleLabel
            }
            if tmp_view == nil {
                self.mainView.addConstraint(NSLayoutConstraint(item: self.customView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: hMargin))
            } else {
                self.mainView.addConstraint(NSLayoutConstraint(item: self.customView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: tmp_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: vMargin))
            }
            
            self.mainView.addConstraint(NSLayoutConstraint(item: self.customView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: hMargin))
            self.mainView.addConstraint(NSLayoutConstraint(item: self.customView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -hMargin))
            self.mainView.addConstraint(NSLayoutConstraint(item: self.customView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.size.height-120))
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isDescendantOfView(self.mainView) {
            return false
        }
        return true
    }
    
    func alertAction(sender:UIButton) {
        if sender.tag == 2 {
            self.okAction?(alert: self)
        } else if sender.tag == 1 {
            if self.cancelAction == nil {
                self.hide()
            } else {
                self.cancelAction?(alert: self)
            }
        }
    }
    
    func hide(sender:UITapGestureRecognizer? = nil) {
        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 0
            }, completion: { finished in
                self.view.removeFromSuperview()
                self.strongSelf = nil
        })
    }
    
    func setAlertTitle(title:String!) -> LiAlertViewController {
        if title != nil && self.titleLabel != nil {
            self.titleLabel.text = title
        }
        return self
    }
    
    func setSubTitle(subTitle:String!) -> LiAlertViewController {
        if subTitle != nil && self.subTitleLabel != nil {
            self.subTitleLabel.text = subTitle
        }
        return self
    }
    
    //设置customview height,不存参数，则使用最大的高度
    func setupCustomViewHeight(var height:CGFloat = -1) -> LiAlertViewController {
        if self.customView != nil {
            if height < 0 {
                //50为mainView的margin; 55为buttons的高度
                height = self.view.frame.size.height - 80 - btnHeight - vMargin
                if self.titleLabel != nil {
                    self.titleLabel.sizeToFit()
                    height -= self.titleLabel.frame.size.height + vMargin
                    print("\(self.titleLabel.frame.size.height)")
                }
                if self.subTitleLabel != nil {
                    self.subTitleLabel.sizeToFit()
                    height -= self.subTitleLabel.frame.size.height + vMargin
                    print("\(self.subTitleLabel.frame.size.height)")
                }
            }
            self.customView.addConstraint(NSLayoutConstraint(item: self.customView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height))
        }
        return self
    }
    
    func build(title title:String!,subTitle:String! = nil,customView: UIView! = nil,okButtonTitle:String! = nil, okAction: ((alert:LiAlertViewController) -> Void)? = nil) -> LiAlertViewController {
        self.setupMainView()
        
        //注意一下的顺序，title subtitle customView buttons
        if title != nil {
            self.setupTitleLabel()
            self.titleLabel.text = title
        }
        
        if subTitle != nil {
            self.setupSubTitleView()
            self.subTitleLabel.text = subTitle
        }
        
        self.setupCustomView(customView)
        
        self.setupButtons(okButtonTitle)
        
        self.okAction = okAction
        
        return self
    }
    
    func show(action:((alert:LiAlertViewController,isOk:Bool) -> Void)? = nil) {
        self.window.addSubview(self.view)
        self.window.bringSubviewToFront(self.view)
        view.frame = self.window.bounds
        
        self.action = action
        
        self.view.alpha = 0
        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 1
            }, completion: { finished in
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
