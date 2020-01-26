//
//  ViewController.swift
//  Project_27_CoreGraphics
//
//  Created by Rafael VSM on 24/01/20.
//  Copyright © 2020 Rafael Scalzo. All rights reserved.
//

import UIKit
//


@available(iOS 10.0, *)
class ViewController: UIViewController {
    
    var currentDrawType = 0
    //var ctx: CIContext!
    //var currentFilter: CIFilter!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 10 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0: drawRectangle()
        case 1: drawCircle()
        case 2: drawCheckboard()
        case 3: drawRotatedSquares()
        case 4: drawLines()
        case 5: drawImagesAndText()
        case 6: drawStar()
        case 7: drawTwin()
        case 10: drawLoucura()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
        // Do any additional setup after loading the view.
    }
    
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            let ctx = context.cgContext
            ctx.setStrokeColor(UIColor.black.cgColor)
            
            let topMargin = 30
            let center = 45
            let bottomMargin = 60
            
            ctx.move(to: CGPoint(x: 30, y: topMargin))
            ctx.addLine(to: CGPoint(x: 60, y: topMargin))
            ctx.move(to: CGPoint(x: 45, y: topMargin))
            ctx.addLine(to: CGPoint(x: 45, y: bottomMargin))
            
            ctx.move(to: CGPoint(x: 90, y: topMargin))
            ctx.addLine(to: CGPoint(x: 100, y: bottomMargin))
            ctx.move(to: CGPoint(x: 100, y: bottomMargin))
            ctx.addLine(to: CGPoint(x: 110, y: topMargin))
            ctx.move(to: CGPoint(x: 110, y: topMargin))
            
            ctx.addLine(to: CGPoint(x: 120, y: bottomMargin))
            ctx.move(to: CGPoint(x: 120, y: bottomMargin))
            ctx.addLine(to: CGPoint(x: 130, y: topMargin))
            
            ctx.move(to: CGPoint(x: 160, y: topMargin))
            ctx.addLine(to: CGPoint(x: 160, y: bottomMargin))
            
            ctx.move(to: CGPoint(x: 190, y: topMargin))
            ctx.addLine(to: CGPoint(x: 190, y: bottomMargin))
            ctx.move(to: CGPoint(x: 190, y: topMargin))
            ctx.addLine(to: CGPoint(x: 210, y: bottomMargin))
            ctx.move(to: CGPoint(x: 210, y: topMargin))
            ctx.addLine(to: CGPoint(x: 210, y: bottomMargin))
            
            let leftEye = CGRect(x: 240, y: topMargin, width: 5, height: 5)
            ctx.addEllipse(in: leftEye)
            let rightEye = CGRect(x: 265, y: topMargin, width: 5, height: 5)
            ctx.addEllipse(in: rightEye)
            
            ctx.move(to: CGPoint(x: 240, y: center))
            ctx.addCurve(to: CGPoint(x: 270, y: center), control1: CGPoint(x: 251, y: bottomMargin), control2: CGPoint(x: 259, y: bottomMargin))
            
            ctx.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    
    func drawStar() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let imageData = renderer.pngData { context in
            context.cgContext.translateBy(x: 256, y: 256)
            let cgImage = UIImage(named: "star")!.cgImage!
            context.cgContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: 64, height: 64))
        }
        imageView.image = UIImage(data: imageData)
    }
    
    func drawLoucura() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            
            let path = UIBezierPath(arcCenter: CGPoint(x: 512, y: 256), radius: 256, startAngle: CGFloat.pi / 3   , endAngle: CGFloat.pi, clockwise: true)
            context.cgContext.setFillColor(UIColor.brown.cgColor)
            context.cgContext.addPath(path.cgPath)
            context.cgContext.setLineWidth(10)
            context.cgContext.setStrokeColor(UIColor.red.cgColor)
            context.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    
    func drawImagesAndText() {
        // Create a renderer at the correct size.
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            // Define a paragraph style that aligns text to the center.
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // Create an attributes dictionary containing that paragraph style, and also a font.
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle]
            
            // Wrap that attributes dictionary and a string into an instance of NSAttributedString.
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            
            // Load an image from the project and draw it to the context.
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageView.image = image
    }
    
    // move(to:) and addLine(to:). These are the Core Graphics equivalents to the UIBezierPath paths
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (context) in
            context.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length:CGFloat = 256
            
            for _ in 0 ..< 256 {
                context.cgContext.rotate(by: .pi / 2)
                
                if first {
                    context.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    context.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        imageView.image = image
    }
    
    // In UIKit, you rotate drawing around the center of your view, as if a pin was stuck right through the middle. In Core Graphics, you rotate around the top-left corner, so to avoid that we're going to move the transformation matrix half way into our image first so that we've effectively moved the rotation point.
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            // translateBy() translates (moves) the current transformation matrix.
            context.cgContext.translateBy(x: 256, y: 256)
            // let rotations = 16
            let rotations = 128
            let amount = Double.pi / Double(rotations)
            
            for _ in  0 ..< rotations {
                // rotate(by:) rotates the current transformation matrix.
                context.cgContext.rotate(by: CGFloat(amount))
                context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            // strokePath() strokes the path with your specified line width, which is 1 if you don't set it explicitly.
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawCheckboard() {
        
        // can draw checkboard with CoreImage:
        // ctx = CIContext()
        // currentFilter = CIFilter(name: "CICheckerboardGenerator", parameters: ["inputColor0": CIColor.white, "inputColor1":CIColor.black, "inputCenter":CIVector(cgRect: CGRect(x: 0, y: 0, width: 512, height: 512))])
        
        // if let cgImage = ctx.createCGImage(currentFilter.outputImage!, from: CGRect(x: 0, y: 0, width: 512, height: 512)) {
            // imageView.image = UIImage(cgImage: cgImage)
        // }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        // get image or pngData from render will be transparent white space because haven’t specified that our renderer is opaque, this means those places where we haven't filled anything will be transparent. jpgData will get white
        let imageData = renderer.jpegData(withCompressionQuality: 0.7) { context in
            context.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        imageView.image = UIImage(data: imageData)
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let imageData = renderer.pngData { context in
            //let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addEllipse(in: rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = UIImage(data: imageData)
    }
    
    func drawRectangle() {
        // In that code, we create a UIGraphicsImageRenderer with the size 512x512, leaving it with default values for scale and opacity – that means it will be the same scale as the device (e.g. 2x for retina) and transparent.
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { context in
            // let rectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 512, height: 512))
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            // setFillColor() sets the fill color of our context, which is the color used on the insides of the rectangle we'll draw.
            context.cgContext.setFillColor(UIColor.red.cgColor)
            // setStrokeColor() sets the stroke color of our context, which is the color used on the line around the edge of the rectangle we'll draw.
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            // setLineWidth() adjusts the line width that will be used to stroke our rectangle. Note that the line is drawn centered on the edge of the rectangle, so a value of 10 will draw 5 points inside the rectangle and five points outside.
            context.cgContext.setLineWidth(10)
            // addRect() adds a CGRect rectangle to the context's current path to be drawn.
            //context.cgContext.addPath(retangle.cgPath)
            context.cgContext.addRect(rectangle)
            // drawPath() draws the context's current path using the state you have configured.
            context.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
}

