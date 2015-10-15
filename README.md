# LiAlert

一个简单的可支持自定义弹出的alert,并且支持autolayout;使用swift 2.
![alert1](https://raw.githubusercontent.com/kuanglijun312/LiAlert/master/screenshot/alert1.png) 
![alert2](https://raw.githubusercontent.com/kuanglijun312/LiAlert/master/screenshot/alert2.png) 
![alert3](https://raw.githubusercontent.com/kuanglijun312/LiAlert/master/screenshot/alert3.png)
![alert4](https://raw.githubusercontent.com/kuanglijun312/LiAlert/master/screenshot/alert4.png)
![alert5](https://raw.githubusercontent.com/kuanglijun312/LiAlert/master/screenshot/alert5.png)

参考了： [SCLAlertView-Swift](https://github.com/vikmeup/SCLAlertView-Swift),
[codestergit/SweetAlert-iOS](https://github.com/codestergit/SweetAlert-iOS),这两个很类似，但都没有支持autolayout，而是用frame自己去算布局，也不支持的自定义--改过一次，但由于不支持autolayout,自定义view居中等等的实现很麻烦。

### 使用
提示:

	LiAlertViewController().build(title: "提示", subTitle: "我的网站开了16天，所以baidu-sitemap效果还不是很明显，不过我看了它生成的xml形式的确比sitemap,xml更符合百度标准，我个人觉得sitemap.xml适合提交给谷歌搜素引擎,baidusitemap.xml适合提交百度搜索引擎。", customView: nil, okButtonTitle: "确定") { (alert) -> Void in
            LiAlertViewController().build(title:"哈哈",subTitle:"你点击的确定").show()
        }.show()
        
自定义:
	
	customAlertLabel.text = "For example,autolayout需要自己写好"
        LiAlertViewController().build(title: "提示", subTitle: "我的网站开了16天，所以baidu-sitemap效果还不是很明显，不过我看了它生成的xml形式的确比sitemap,xml更符合百度标准，我个人觉得sitemap.xml适合提交给谷歌搜素引擎,baidusitemap.xml适合提交百度搜索引擎。", customView: customWrap1View, okButtonTitle: "确定") { (alert) -> Void in
            LiAlertViewController().build(title:"哈哈",subTitle:"你点击的确定").show()
        }.show()
        
另外一个自定义:

       	customTableView.reloadData()
        LiAlertViewController().build(title: "提示", subTitle:nil, customView: customTableView, okButtonTitle: "确定") { (alert) -> Void in
            LiAlertViewController().build(title:"哈哈",subTitle:"你点击的确定").show()
            }.setupCustomViewHeight().show()
            
具体的实现看demo；
欢迎大家提意见！