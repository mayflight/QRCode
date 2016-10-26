//
//  ViewController.swift
//  二维码生成
//
//  Created by yadong.ye on 16/9/4.
//  Copyright © 2016年 yadong.ye. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var textView:UITextView?
    
    var imageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView =  UIImageView(frame: CGRect(x: 100,y: 300, width: 200, height: 200))
        
        textView = UITextView(frame: CGRect(x: 50, y: 50, width: 200, height: 100))
        textView!.backgroundColor = UIColor.clear
        textView!.layer.borderColor = UIColor.green.cgColor
        textView!.layer.borderWidth = 2
        textView!.textColor = UIColor.red
        textView!.layer.cornerRadius = 5
        textView!.font = UIFont.systemFont(ofSize: 16)
        self.view .addSubview(textView!)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 260, y: 50, width: 100, height: 50)
        button .setTitle("选择图片", for: UIControlState())
        button.setTitleColor(UIColor.red, for: UIControlState())
        button .addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.view .addSubview(button)
        
        let buttonqr = UIButton(type: .custom)
        buttonqr.frame = CGRect(x: 260, y: 150, width: 100, height: 50)
        buttonqr .setTitle("生成二维码", for: UIControlState())
        buttonqr.setTitleColor(UIColor.red, for: UIControlState())
        buttonqr .addTarget(self, action: #selector(qRCreate), for: .touchUpInside)
        self.view .addSubview(buttonqr)
        
        let decode = UIButton(type: .custom)
        decode.frame = CGRect(x: 260, y: 200, width: 100, height: 50)
        decode .setTitle("解析二维码", for: UIControlState())
        decode.setTitleColor(UIColor.red, for: UIControlState())
        decode .addTarget(self, action: #selector(decodefunction), for: .touchUpInside)
        self.view .addSubview(decode)

    }
    
    func decodefunction () {
        guard let myImage = imageView!.image else {
            return
        }
        
        let string = QRcode.decodeQRCode(myImage)
        let alert = UIAlertController.init(title: "解析二维码", message: string, preferredStyle: .alert);
        alert.addAction(UIAlertAction.init(title: "知道了", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        

    }
    
    func qRCreate() {
        guard let myImage = imageView!.image else {
            return
        }
        
        imageView!.image = QRcode.createQRCodeByCIFilterWithString(textView!.text, andImage: myImage)
    }
    
    func buttonClick() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pick = UIImagePickerController()
            pick.sourceType = .photoLibrary
            pick.delegate = self
            pick.allowsEditing = true
            self.present(pick, animated: true, completion: nil)
        }else {
            let controller = UIAlertController(title: "提示", message: "图库不可用", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            
        }
        
    }
    
    //取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //结束选择的媒体
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        imageView!.image = image
        self.view .addSubview(imageView!)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

