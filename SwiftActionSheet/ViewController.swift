//
//  ViewController.swift
//  SwiftActionSheet
//
//  Created by JasonHao on 2017/7/18.
//  Copyright © 2017年 JasonHao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var _headView = UIView()//标题头视图
    var _dataArray = NSMutableArray()//表格数组
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        let actionSheetBtn = UIButton.init(frame: CGRect.init(x: 120, y: 200, width: 160, height: 100))
        actionSheetBtn.setTitle("弹出actionSheet", for: .normal)
        actionSheetBtn.setTitleColor(UIColor.blue, for: .normal)
        actionSheetBtn.addTarget(self, action: #selector(actionSheetBtnClick), for: .touchUpInside)
        self.view.addSubview(actionSheetBtn)
        
    }
    //MARK:------ 弹出按钮
    func actionSheetBtnClick() {
        //弹出actionSheet
        weak var weakSelf = self
        let jasonSheetView = JasonActionSheetView.init(aHeadView: (weakSelf?.headView())!, aCellArray: (weakSelf?.dataArray())!, aCancelTitle: "取消", aSelectedClosure: { (index) in
            //点击单元格后的操作
            if index == 0 {
                weakSelf?.view.backgroundColor = UIColor.red
            }else if index == 1 {
                weakSelf?.view.backgroundColor = UIColor.yellow
            }else{
                weakSelf?.view.backgroundColor = UIColor.lightGray
            }
            
        }) { 
            weakSelf?.view.backgroundColor = UIColor.white
        }
        weakSelf?.view.addSubview(jasonSheetView)
        
    }
    //MARK:------ 初始化
    func dataArray() -> NSMutableArray {
        _dataArray = NSMutableArray.init(array: ["红色","黄色","灰色"])
        return _dataArray
    }
    func headView() -> UIView {
        _headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_Width - Space_Line * 2, height: 100))
        _headView.backgroundColor = UIColor.white
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: Screen_Width - Space_Line * 2, height: 30))
        titleLabel.text = "请选择背景颜色"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.init(colorLiteralRed: 73/255, green: 75/255, blue: 90/255, alpha: 1)
        titleLabel.textAlignment = .center
        _headView.addSubview(titleLabel)
        
        let descLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 270, height: 30))
        descLabel.text = "这里根据需要自定义标题头，可以添加图片之类的"
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textAlignment = .center
        descLabel.center = CGPoint.init(x: _headView.center.x, y: 55)
        _headView.addSubview(descLabel)
        
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: 99.5, width: Screen_Width - Space_Line * 2, height: 0.5))
        lineView.backgroundColor = UIColor.init(colorLiteralRed: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        _headView.addSubview(lineView)
        
        
        return _headView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

