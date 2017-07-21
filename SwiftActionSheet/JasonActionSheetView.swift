//
//  JasonActionSheetView.swift
//  SwiftActionSheet
//
//  Created by JasonHao on 2017/7/18.
//  Copyright © 2017年 JasonHao. All rights reserved.
//

import UIKit

class JasonActionSheetView: UIView,UITableViewDelegate,UITableViewDataSource {

    /*---------------如果需要自定义绘图，请执行这个方法
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //创建相关控件
    var maskV = UIView()//半透明背景
    var tableView = UITableView()//表格
    var cellArray = NSArray()//表格数组
    var cancelTitle = NSString()//取消标题设置
    var headView = UIView()//标题头视图
    var selectedClosure:((Int) -> ())?//选中单元格closure
    var cancelClosure:(() -> ())?//取消单元格closure
    
    //初始化方法:参数一：头视图，参数二：表格数组，参数三：取消的标题设置，参数四：选择单元格closure，参数五：取消closure
    
    init(aHeadView:UIView,aCellArray:NSArray,aCancelTitle:NSString,aSelectedClosure:@escaping ((Int) -> ()),aCancelClosure:@escaping (() -> ())) {
        super.init(frame: headView.frame)
        
        headView = aHeadView
        cellArray = aCellArray
        cancelTitle = aCancelTitle
        selectedClosure = aSelectedClosure
        cancelClosure = aCancelClosure
        
        //创建UI视图
        self.createUI()
        
    }
    //MARK: ------------ 创建UI视图
    func createUI() {
        self.frame = UIScreen.main.bounds
        //半透明背景
        maskV = UIView.init(frame: UIScreen.main.bounds)
        maskV.backgroundColor = UIColor.black
        maskV.alpha = 0.5
        maskV.isUserInteractionEnabled = true
        self.addSubview(maskV)
        
        //表格
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        tableView.clipsToBounds = true
        tableView.rowHeight = 44.0
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = self.headView
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: -50, bottom: 0, right: 0)
        
        //注册单元格:+ (Class)class OBJC_SWIFT_UNAVAILABLE("use 'aClass.self' instead");
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "oneCell")
        
        self.addSubview(tableView)
    }
    //MARK:------------ UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? cellArray.count:1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneCell")
        if indexPath.section == 0 {
            cell?.textLabel?.text = cellArray[indexPath.row] as? String
            if indexPath.row == cellArray.count-1 {
                //添加贝塞尔曲线，设计边角样式UIBezierPath与CAShapeLayer
                //注意：Swift中的“或”加了一个rawValue：UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue)
                let maskPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: Screen_Width - Space_Line*2, height: tableView.rowHeight), byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize.init(width: 10, height: 10))
                let maskLayer = CAShapeLayer.init()
                maskLayer.frame = (cell?.contentView.bounds)!
                maskLayer.path = maskPath.cgPath
                cell?.layer.mask = maskLayer
            }
        }else{
            cell?.textLabel?.text = cancelTitle as String
            cell?.layer.cornerRadius = 10
        }
        
        cell?.textLabel?.textAlignment = .center
        cell?.selectionStyle = .none
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (selectedClosure != nil) {
                selectedClosure!(Int(indexPath.row))
            }
        }else{
            if (cancelClosure != nil) {
                cancelClosure!()
            }
        }
        
        self.dismiss()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Space_Line
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.size.width, height: Space_Line))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    //MARK:------绘制视图
    override func layoutSubviews() {
        super.layoutSubviews()
        self.show()
    }
    //滑动弹出
    func show() {
        tableView.frame = CGRect.init(x: Space_Line, y: Screen_Height, width: Screen_Width-Space_Line * 2, height: tableView.rowHeight * CGFloat(cellArray.count + 1) + headView.bounds.size.height + Space_Line * 2)
        UIView.animate(withDuration: 0.5) { 
            var rect:CGRect = self.tableView.frame
            rect.origin.y -= self.tableView.bounds.size.height
            self.tableView.frame = rect
        }
    }
    //滑动消失
    func dismiss() {
        UIView.animate(withDuration: 0.5, animations: { 
            var rect:CGRect = self.tableView.frame
            rect.origin.y += self.tableView.bounds.size.height
            self.tableView.frame = rect
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    //MARK:------触摸屏幕其他位置谈下
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    

}
