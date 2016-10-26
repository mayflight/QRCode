//
//  QRcode.swift
//  二维码生成
//
//  Created by yadong.ye on 16/9/4.
//  Copyright © 2016年 yadong.ye. All rights reserved.
//

import UIKit

class QRcode: NSObject {
    static func  createQRCodeByCIFilterWithString(_ message:String,andImage myImage:UIImage) -> UIImage? {
        if let messageData = message.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            //创建二维码滤镜
            let qrCIFilter = CIFilter(name: "CIQRCodeGenerator")
            //二维码包含的信息
            qrCIFilter!.setValue(messageData, forKey: "inputMessage")
            //L7% M15% Q25% H%30% 纠错级别. 默认值是M
            qrCIFilter!.setValue("H", forKey: "inputCorrectionLevel")
            let qrImage = qrCIFilter?.outputImage
            //创建颜色滤镜主要是了解决二维码不清晰 False color is often used to process astronomical and other scientific data, such as ultraviolet and x-ray images.通常用于处理紫外线，x射线等天文或科学的数据
            let colorFilter = CIFilter(name: "CIFalseColor")
            //输入图片
            colorFilter!.setValue(qrImage, forKey: "inputImage")
            //输入颜色
            colorFilter!.setValue(CIColor(red: 0,green: 0,blue: 0), forKey: "inputColor0")
            colorFilter!.setValue(CIColor(red: 1,green: 1,blue: 1), forKey: "inputColor1")
            var image = UIImage(ciImage: colorFilter!.outputImage!
                .applying(CGAffineTransform(scaleX: 5, y: 5)))
            
            let frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            //开启上下文
            UIGraphicsBeginImageContext(frame.size)
            //二维码图片重绘(二维码图片如果不绘制，获取的图片无法反过来创建CIImage)
            image.draw(in: frame)
            
                //个性图片尺寸
                let mySize = CGSize(width: frame.size.width/4, height: frame.size.height/4)
                //重绘自定义图片
                myImage.draw(in: CGRect(x: frame.size.width/2-mySize.width/2, y: frame.size.height/2-mySize.height/2, width: mySize.width, height: mySize.height))
            
            //从上下文获取图片
            image = UIGraphicsGetImageFromCurrentImageContext()!
            //关闭上下文
            UIGraphicsEndImageContext()
            
            return image
        }
        return nil
    }
    
    static  func decodeQRCode(_ image:UIImage) -> String {
        let decodeImage = CIImage(image: image)
        /*创建探测器 options 是字典key:
         CIDetectorAccuracy 精度
         CIDetectorTracking 轨迹
         CIDetectorMinFeatureSize 特种尺寸
         CIDetectorNumberOfAngles 角度**/
        let dector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(), options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        
        let qrFeatures = dector?.features(in: decodeImage!) as! [CIQRCodeFeature]
        guard let message = qrFeatures.last else {
            return "解析失败"
        }
        guard let string = message.messageString else {
            return "解析失败"
        }
        return string
        
    }


}
