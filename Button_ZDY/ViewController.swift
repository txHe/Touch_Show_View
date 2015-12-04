//
//  ViewController.swift
//  Button_ZDY
//
//  Created by zhhz on 15/11/17.
//  Copyright © 2015年 zhhz. All rights reserved.
//

import UIKit
import QuartzCore

var KEY_CORNER_RADIUS:CGFloat = 6.0

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor();
        
        /*这个View,命名为expandview,宽70.0，高100.0*/
        let expandview = ExpandView(frame: CGRect(x: 20.0, y: 20.0, width: 70.0, height: 100.0));
        
        expandview.setMyTitles(["123键盘","ABC键盘","下一个输入法"]);
     
        self.view.addSubview(expandview);
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

/*扩展view是有三个子视图构成(ExpandLabelView)*/
class ExpandView:UIView
{
    var titles = ["1","2","3"]
    
    var origin_x:CGFloat!
    var origin_y:CGFloat!
    var width:CGFloat!
    var height:CGFloat!
    
    var line_height:CGFloat!
    
    var first_view:ExpandLabelView!
    var second_view:ExpandLabelView!
    var third_view:ExpandLabelView!
    
    var height_part:CGFloat!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.layer.cornerRadius = KEY_CORNER_RADIUS;
        self.clipsToBounds = true; //是否截去圆角
        self.layer.masksToBounds = true; //同上
        self.backgroundColor = UIColor.whiteColor();
        
        origin_x = self.bounds.origin.x;
        origin_y = self.bounds.origin.y;
        
        width = self.bounds.size.width;
        height = self.bounds.size.height;
        
        line_height = 0.2;
        
        height_part = height / 3;
        
        self.layer.borderWidth = 0.75 // = CGSize(width: 1.0, height: 1.0)
        self.layer.borderColor = UIColor(red: 255.0/255, green: 250.0/255, blue: 240.0/255, alpha: 1.0).CGColor;
        
        
    }
    //重新绘制
    override func drawRect(rect: CGRect)
    {
        //加入LabelView和中间的分割线
        first_view = ExpandLabelView(frame: CGRectMake(origin_x,origin_y,width,height_part));
        first_view.setMyTitle(titles[0])
        second_view = ExpandLabelView(frame: CGRectMake(origin_x,origin_y + height_part + line_height,width,height_part));
        second_view.setMyTitle(titles[1])
        third_view = ExpandLabelView(frame: CGRectMake(origin_x,origin_y + 2 * (height_part + line_height),width,height_part))
        third_view.setMyTitle(titles[2])
        let straight_line_first = Straight_Line(frame: CGRectMake(origin_x,origin_y + height_part,width,line_height))
        let straight_line_second = Straight_Line(frame: CGRectMake(origin_x,origin_y + 2 * height_part + line_height,width,line_height))
        
        self.addSubview(first_view);
        self.addSubview(second_view);
        self.addSubview(third_view)
        
        self.addSubview(straight_line_first)
        self.addSubview(straight_line_second)
    }
    
    //设置中间label的文字
    func setMyTitles(labeltitles:[String])
    {
        titles = labeltitles
    }
    
    //触碰重载
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent: event)
        let touch:UITouch = (touches as NSSet).anyObject() as! UITouch;
        let touchpoint:CGPoint = touch.locationInView(self)
        //let index_x = touchpoint.x
        let index_y = touchpoint.y
        //触碰到某个位置，则加上一层背景，以达到按键效果
        if(0 < index_y && index_y < height_part)
        {
            deletebackview()
            let tempview = BackImageView(frame: first_view.frame)
            tempview.setMyTitle(titles[0])
            self.addSubview(tempview)
        }
        else if(height_part < index_y && index_y < 2 * height_part + line_height)
        {
            deletebackview()
            let tempview = BackImageView(frame: second_view.frame)
            tempview.setMyTitle(titles[0])
            self.addSubview(tempview)
        }
        else if(2 * height_part + line_height < index_y && index_y < 3 * height_part + 2 * line_height)
        {
            deletebackview()
            let tempview = BackImageView(frame: third_view.frame)
            tempview.setMyTitle(titles[0])
            self.addSubview(tempview)
        }
        
    }
    
    //移动的过程中先删除覆盖的背景图，然后在新的label上加上背景图
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesMoved(touches, withEvent: event)
        let touch:UITouch = (touches as NSSet).anyObject() as! UITouch;
        let touchpoint:CGPoint = touch.locationInView(self)
        //let index_x = touchpoint.x
        let index_y = touchpoint.y
        
        if(0 < index_y && index_y < height_part)
        {
            deletebackview()
            let tempview = BackImageView(frame: first_view.frame)
            tempview.setMyTitle(titles[0])
            self.addSubview(tempview)
        }
        else if(height_part < index_y && index_y < 2 * height_part + line_height)
        {
            deletebackview()
            let tempview = BackImageView(frame: second_view.frame)
            tempview.setMyTitle(titles[1])
            self.addSubview(tempview)
        }
        else if(2 * height_part + line_height < index_y && index_y < 3 * height_part + 2 * line_height)
        {
            deletebackview()
            let tempview = BackImageView(frame: third_view.frame)
            tempview.setMyTitle(titles[2])
            self.addSubview(tempview)
        }
    }
    
    //按键结束，则删除附加的背景图
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        deletebackview()
    }
    
    //删除附加的背景图
    func deletebackview()
    {
        for v in self.subviews
        {
            if(v.isKindOfClass(BackImageView))
            {
                v.removeFromSuperview()
            }
        }
    }
    
}
//定制一个View
class ExpandLabelView:UIView
{
    var title:NSString = "纵横输入法"
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5);
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor;
        
        self.clipsToBounds = true;
        self.layer.masksToBounds = true;
        self.backgroundColor = UIColor.whiteColor()
        
    }
    func setMyTitle(labeltitle:String)
    {
        title = labeltitle;
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    override func drawRect(rect: CGRect)
    {
        
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByClipping;
        paragraphStyle.alignment = NSTextAlignment.Center;
        let font = UIFont.systemFontOfSize(11); //设置字体大小
        //let fontcolor = UIColor.blackColor();
        let attr:NSDictionary = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.blackColor(),NSParagraphStyleAttributeName:paragraphStyle];
        
        let size = title.sizeWithAttributes(attr as? [String : AnyObject]);
        
        let float_x_pos = (rect.size.width - size.width)/2;
        let float_y_pos = (rect.size.height - size.height)/2;
        let point_title = CGPoint(x: float_x_pos,y: float_y_pos);
        title.drawAtPoint(point_title, withAttributes: attr as? [String : AnyObject]);
        
    }
}

class BackImageView: UIView {
    
    var title = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor(red: 30.0/255, green: 144.0/255, blue: 255.0/255, alpha: 1.0)
        self.alpha = 1.0
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    func setMyTitle(labeltitle:String)
    {
        title = labeltitle;
        
    }
    override func drawRect(rect: CGRect) {
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByClipping;
        paragraphStyle.alignment = NSTextAlignment.Center;
        let font = UIFont.systemFontOfSize(11); //设置字体大小
        //let fontcolor = UIColor.blackColor();
        let attr:NSDictionary = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.whiteColor(),NSParagraphStyleAttributeName:paragraphStyle];
        
        let size = title.sizeWithAttributes(attr as? [String : AnyObject]);
        
        let float_x_pos = (rect.size.width - size.width)/2;
        let float_y_pos = (rect.size.height - size.height)/2;
        let point_title = CGPoint(x: float_x_pos,y: float_y_pos);
        title.drawAtPoint(point_title, withAttributes: attr as? [String : AnyObject]);
        
        
    }
}


//背景图，为按键添加“效果”
func BackImage()->UIImage
{
    let rect:CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size)
    
    let context:CGContextRef = UIGraphicsGetCurrentContext()!
    
    //CGContextSetFillColorWithColor(context, UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 0.8).CGColor)
    CGContextSetFillColorWithColor(context, UIColor.lightGrayColor().CGColor)
    CGContextFillRect(context, rect)
    //var roundedRect:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: KEY_CORNER_RADIUS)
    //UIColor(white: 0, alpha: 0.5).setFill()
    //UIColor.lightGrayColor().setFill()
    //roundedRect .fillWithBlendMode(kCGBlendModeNormal, alpha: 1)
    
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//绘制分割线
class Straight_Line:UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect)
    {
        //获得处理的上下文
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        //指定直线样式
        CGContextSetLineCap(context,CGLineCap.Square);
        //直线宽度
        CGContextSetLineWidth(context,2.0);
        //设置颜色
        CGContextSetRGBStrokeColor(context,220, 220, 220, 1.0);
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context,31, 70);
        //下一点
        CGContextAddLineToPoint(context,129, 148);
        //下一点
        CGContextAddLineToPoint(context,159, 148);
        //绘制完成
        CGContextStrokePath(context);
    }
}
