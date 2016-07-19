//
//  OAuthViewController.swift
//  weibo
//
//  Created by ldj on 16/6/13.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    let WB_APPKey = "510193840"
    let WB_APP_Secret = "2889ea897e163392e3f83626ae56381f"
    let WB_APP_redirect_uri = "https://github.com/mumuda"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
        
        // 0.初始化导航图
        navigationItem.title = "木木哒微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(OAuthViewController.close))
        
        // 1.获取未授权的requestToken
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_APPKey)&redirect_uri=\(WB_APP_redirect_uri)"
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
    }

    func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var webView :UIWebView = {
       let wb = UIWebView()
        wb.delegate = self
        return wb
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension OAuthViewController :UIWebViewDelegate
{
    // 返回true正常加载，返回false 取消加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        let urlString = request.URL!.absoluteString
        
        // 1.判断是否是授权回调页
        if !(urlString.hasPrefix(WB_APP_redirect_uri))
        {
            return true
        }
        
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            // 授权成功
            let code = request.URL!.query!.substringFromIndex(codeStr.endIndex)
            
            // 利用已经授权的requestToken换取accessToken
            loadAccessToken(code)
        }else
        {
            // 取消授权
            close()
        }
        
        // 2.判断是否授权成功
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showInfoWithStatus("正在加载。。。")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    /**
     换取AccessToken
     
     - parameter code: 已经授权的requestToken
     */
    private func loadAccessToken(code:String){
        // 1.定义路径
        let path = "oauth2/access_token"
        
        let params = ["client_id":WB_APPKey,"client_secret":WB_APP_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":WB_APP_redirect_uri];
        
        
        // 2.封装参数
        NetWorkTools.shareNetWorkTools().POST(path, parameters: params, success: { (_, JSON) in
            
            // 1.字典转模型
            let account = UserAccount.init(dict: JSON as! [String:AnyObject])
            // 获取用户信息
            account.loadUserInfo({ (account, error) in
                if account != nil
                {
                    account?.saveAccount()
                    // 去欢迎界面
                    NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewController, object: false)
                    return
                }
                SVProgressHUD.showInfoWithStatus("网络不给力。。。")
                
            })
            // 由于加载用户信息是异步的，所以不能再这里保存用户信息
            
            
            }) { (_, error) in
                print(error)
        }
        
    }
}
