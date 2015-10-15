//
//  ViewController.swift
//  LiAlert
//
//  Created by zm002 on 15/10/14.
//  Copyright © 2015年 zm002. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var customTableView: UITableView!
    @IBOutlet var customWrap1View: UIView!
    @IBOutlet weak var customAlertLabel: UILabel!
//    var liAlert:LiAlertViewController!
    
    var items = ["我的网站开了16天，所以baidu-sitemap效果还不是很明显，不过我看了它生成的xml形式的确比sitemap,xml更符合百度标准，我个人觉得sitemap.xml适合提交给谷歌搜素引擎,baidusitemap.xml适合提交百度搜索引擎。","Since iOS8, -tableView:heightForRowAtIndexPath: will be called more times than we expect, we can feel these extra calculations when scrolling. So we provide another API with cache by index path:","Auto layout mode using \"-systemLayoutSizeFittingSize:\"","Frame layout mode using \"-sizeThatFits:\"","Generally, no need to care about modes, it will automatically choose a proper mode by whether you have set auto layout constrants on cell's content view. If you want to enforce frame layout mode, enable this property in your cell's configuration block:","Since iOS8, -tableView:heightForRowAtIndexPath: will be called more times than we expect, we can feel these extra calculations when scrolling. So we provide another API with cache by index path:","Auto layout mode using \"-systemLayoutSizeFittingSize:\"","Frame layout mode using \"-sizeThatFits:\"","Generally, no need to care about modes, it will automatically choose a proper mode by whether you have set auto layout constrants on cell's content view. If you want to enforce frame layout mode, enable this property in your cell's configuration block:","Since iOS8, -tableView:heightForRowAtIndexPath: will be called more times than we expect, we can feel these extra calculations when scrolling. So we provide another API with cache by index path:","Auto layout mode using \"-systemLayoutSizeFittingSize:\"","Frame layout mode using \"-sizeThatFits:\"","Generally, no need to care about modes, it will automatically choose a proper mode by whether you have set auto layout constrants on cell's content view. If you want to enforce frame layout mode, enable this property in your cell's configuration block:"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        customTableView.delegate = self
        customTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(sender: AnyObject) {
        LiAlertViewController().build(title: "提示", subTitle: "我的网站开了16天，所以baidu-sitemap效果还不是很明显，不过我看了它生成的xml形式的确比sitemap,xml更符合百度标准，我个人觉得sitemap.xml适合提交给谷歌搜素引擎,baidusitemap.xml适合提交百度搜索引擎。", customView: nil, okButtonTitle: "确定") { (alert) -> Void in
            LiAlertViewController().build(title:"哈哈",subTitle:"你点击的确定").show()
        }.show()
    }
    
    @IBAction func showCustom1Aler(sender: AnyObject) {
        customAlertLabel.text = "For example,autolayout需要自己写好"
        LiAlertViewController().build(title: "提示", subTitle: "我的网站开了16天，所以baidu-sitemap效果还不是很明显，不过我看了它生成的xml形式的确比sitemap,xml更符合百度标准，我个人觉得sitemap.xml适合提交给谷歌搜素引擎,baidusitemap.xml适合提交百度搜索引擎。", customView: customWrap1View, okButtonTitle: "确定") { (alert) -> Void in
            LiAlertViewController().build(title:"哈哈",subTitle:"你点击的确定").show()
        }.show()
    }
    @IBAction func showCustomTableViewAlert(sender: AnyObject) {
        customTableView.reloadData()
        LiAlertViewController().build(title: "提示", subTitle:nil, customView: customTableView, okButtonTitle: "确定") { (alert) -> Void in
            LiAlertViewController().build(title:"哈哈",subTitle:"你点击的确定").show()
            }.setupCustomViewHeight().show()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = items[indexPath.row]
        }
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier("cell", cacheByIndexPath: indexPath, configuration: { [unowned self](cell) -> Void in
            if let label = cell.viewWithTag(1) as? UILabel {
                label.text = self.items[indexPath.row]
            }
        })
    }
}

