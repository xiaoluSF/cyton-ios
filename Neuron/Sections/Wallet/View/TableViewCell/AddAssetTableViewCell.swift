//
//  AddAssetTableViewCell.swift
//  Neuron
//
//  Created by XiaoLu on 2018/5/24.
//  Copyright © 2018年 cryptape. All rights reserved.
//

import UIKit

@objc protocol AddAssetTableViewCellDelegate:NSObjectProtocol {
    @objc optional func didClickSelectCoinBtn()//点击选择币种
    @objc optional func didClickQRCodeBtn()//点击扫码
    func didGetTextFieldTextWithIndexAndText(text:String,index:NSIndexPath)
}

class AddAssetTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    weak var delegate:AddAssetTableViewCellDelegate?
    
    var indexP = NSIndexPath.init()
    // 设置属性来确定不同的cell有不同的状态
    var _selectRow:NSInteger = 0
    let placeholserAttributes = [NSAttributedStringKey.foregroundColor : ColorFromString(hex: "#999999"),NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)]
    
    let firstBtn = UIButton.init(type: UIButtonType.custom)
    let secBtn = UIButton.init(type: UIButtonType.custom)
    
    
    @IBOutlet weak var headLable: UILabel!
    @IBOutlet weak var rightTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //使用KVO监听textfield.text
        rightTextField.addObserver(self, forKeyPath: "text", options:.new, context: nil)

    }
    
    //重写set方法
    var placeHolderStr:String?{
        didSet{
            rightTextField.attributedPlaceholder = NSAttributedString(string: placeHolderStr!,attributes: placeholserAttributes)
        }
    }
    var selectRow:NSInteger = 0{//传入0就是下拉样式  传入1就是点击二维码
        didSet{
            if selectRow == 0 {
                rightTextField.rightViewMode = .always
                firstBtn.setImage(UIImage.init(named: "Triangle"), for: .normal)
                firstBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 50)
                firstBtn.addTarget(self, action: #selector(didSetUpPickView), for: .touchUpInside)
                rightTextField.rightView = firstBtn
                rightTextField.delegate = self
                rightTextField.tag = 2000 // 根据tag来跟别的textfield区分
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(didSetUpPickView))
                rightTextField.addGestureRecognizer(tap)
                
            }else if selectRow == 1{
                rightTextField.rightViewMode = .always
                secBtn.setImage(UIImage.init(named: "qrCode"), for: .normal)
                secBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15)
                secBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                secBtn.addTarget(self, action: #selector(didPushQRCodeView), for: .touchUpInside)
                rightTextField.rightView = secBtn
            }else{
                
            }
        }
    }
    
    //KVO监听结果
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" && object is UITextField {

            delegate?.didGetTextFieldTextWithIndexAndText(text: rightTextField.text!, index: indexP)
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
    
    //点击第一行按钮弹出pickerview选择币种
    @objc func didSetUpPickView() {
        print("点击第一个")
        delegate?.didClickSelectCoinBtn!()
    }
    //点击第二行按钮跳转扫描二维码界面
    @objc func didPushQRCodeView() {
        print("点击第二个")
        delegate?.didClickQRCodeBtn!()
    }
    
    @objc func textFieldValueChange(){
        
    }
    
    //textfidel代理
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 2000
        {
            return false
        }else{
            return true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    deinit {
        rightTextField.removeObserver(self, forKeyPath: "text")
    }
}
