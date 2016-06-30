//
//  QRCodeViewController.swift
//  weibo
//
//  Created by ldj on 16/6/6.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import AVFoundation
class QRCodeViewController: UIViewController, UITabBarDelegate{

    // 冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    // 扫描容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var resultLabel: UILabel!
    // 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置底部视图，默认选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }

    @IBOutlet weak var customTabBar: UITabBar!

    @IBAction func onCloseBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onMyCardBtn(sender: AnyObject) {
        let vc = QRCodeCardViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 1.开始冲击波动画
        startAnimation()
        
        // 2.开始扫描
        startScan()
    }
    /**
     扫描二维码
     */
    private func startScan(){
        // 1.判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput)
        {
            return
        }
        // 2.判断是否能奖输出添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        // 3.奖输入输出添加到会话中
        session.addInput(deviceInput)
        print(output.metadataObjectTypes)
        session.addOutput(output)
        print(output.metadataObjectTypes)
        
        // 4.设置输出能够解析的数据类型
        // 设置能够解析的数据类型一定要在输出对象添加到会话中后，否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        // 5.设置输出对象的代理，只要解析成功救回通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 如果想实现只扫描一张图片，系统自带的二维码不是不支持的，
        // 只有设置让二维码只出现在某一块区域才扫描
//        output.rectOfInterest = CGRectMake(0.0, 0.0, 0.5, 0.5)
        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 添加绘制图层道预览图层上
        previewLayer.addSublayer(drawLayer)
        
        // 6.告诉session开始扫描
        session.startRunning()
    }
    
    /**
     执行动画
     */
    func startAnimation() {
        // 让约束从顶部开始
        scanLineCons.constant = -self.containerHeightCons.constant
        view.layoutIfNeeded()
        // 执行冲击波动画
        UIView.animateWithDuration(2.0, animations: {
            
            // 1.修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // 2.强制更新界面
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    // MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        // 修改容器的高度
        if item.tag == 1 {
            self.containerHeightCons.constant = 300
        }else
        {
            self.containerHeightCons.constant = 150
        }
        
        // 停止动画
        scanLineView.layer.removeAllAnimations()
        startAnimation()
    }
    
    // MARK: - 懒加载
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()

    // 输入设备
    private lazy var deviceInput :AVCaptureDeviceInput? = {
        // 1.获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do{
            // 2.创建输入对象
            let intput = try AVCaptureDeviceInput(device: device)
            return intput
        }catch
        {
            print(error)
            return nil
        }
    }()
    
    // 拿到输出对象
    private lazy var output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 创建预览图层
    private lazy var previewLayer:AVCaptureVideoPreviewLayer = {
       let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    // 创建用语绘制边线的图层
    private lazy var drawLayer:CALayer = {
        let layer = CALayer()
        layer.frame = self.view.frame
        return layer
    }()

}

extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate{
    // 只要解析道数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        
        // 0.清空图层
        clearConers()
        
        // 1.获取扫描到的数据
        // 注意：要使用stringValue
        resultLabel.text = metadataObjects.last?.stringValue
        resultLabel.sizeToFit()
        
        // 2.获取扫描道的二维码的位置
        // 2.1转换左边
        for object in metadataObjects {
            // 2.1.1判断当前获取道的数据，是否是机器可以识别的
            if object is AVMetadataMachineReadableCodeObject {
                // 2.1.2 将坐标系转换为界面可识别坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
//                print(codeObject)
                // 2.1.3绘制图形
                drawCorners(codeObject)
            }
        }
        
    }
    
    /**
     *  绘制图形
     *  codeObject：保存了图形的坐标
     */
    func drawCorners(codeObject: AVMetadataMachineReadableCodeObject) {
        if codeObject.corners.isEmpty {
            return
        }
        
        // 1.创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2.绘制路径
        
        let path = UIBezierPath()
        var point = CGPointZero
        var index:Int = 0
        
        // 2.1移动道第一个点
        print(codeObject.corners.last)
        // 从corners数组中取出第0个元素，将这个字典中的x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[0] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        // 2.2移动到其他的点
        while index < codeObject.corners.count {
            
            CGPointMakeWithDictionaryRepresentation(codeObject.corners[index] as! CFDictionary, &point)
            index += 1
            path.addLineToPoint(point)
        }
        path.closePath()
        
        // 2.4绘制路径
        layer.path = path.CGPath
        // 3.将绘制好的图层添加道drawLayer上
        drawLayer.addSublayer(layer)
        return
    }
    
    /**
     *  清空边线
     */
    private func clearConers(){
        // 1.判断drawLayer上是否有其他图层
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0 {
            return
        }
        
        // 2.移除所有子图层
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}