//
//  BuildingNode.swift
//  Project_29_hues_textureAtlases_transitioning_SpriteKitUIkit
//
//  Created by Rafael VSM on 30/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//
/*
 setup() will do the basic work required to make this thing a building: setting its name, texture, and physics.
 configurePhysics() will set up per-pixel physics for the sprite's current texture.
 drawBuilding() will do the Core Graphics rendering of a building, and return it as a UIImage.
 */
import SpriteKit

class BuildingNode: SKSpriteNode {
    
    var currentImage: UIImage!
    
    func setup() {
        name = "building"
        
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    /*
     Create a new Core Graphics context the size of our building.
     Fill it with a rectangle that's one of three colors.
     Draw windows all over the building in one of two colors: there's either a light on (yellow) or not (gray).
     Pull out the result as a UIImage and return it for use elsewhere.
     
     We will use HSB color to control saturation and brightness (to achieve pastel-colors)
     We will use stride(), which lets you loop from one number to another with a specific interval
     
     We're going to use this to count from the left edge of the building to the right edge in intervals of 40, to position our windows. We'll also do this vertically, to position the windows across the whole height of the building. To make it a little more attractive, we'll actually indent the left and right edges by 10 points.
     That means "count from 10 up to the height of the building minus 10, in intervals of 40." So, it will go 10, 50, 90, 130, and so on. Note that stride() has two variants: stride(from:to:by:) and stride(from:through:by). The first counts up to but excluding the to parameter, whereas the second counts up to and including the through parameter. We'll be using stride(from:to:by:) below.
     */
    func drawBuilding(size: CGSize) -> UIImage {
        // 1
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let ctx = context.cgContext
            ctx.setFillColor(UIColor.black.cgColor)
            
            // 2
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let color: UIColor
            
            switch Int.random(in: 0...2) {
            case 0 : color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1: color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default : color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            color.setFill()
            ctx.addRect(rectangle)
            ctx.drawPath(using: .fill)
            
            // 3
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                    if Bool.random() {
                        lightOnColor.setFill()
                    } else {
                        lightOffColor.setFill()
                    }
                    ctx.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
            
            // 4
        }
        
        return image
    }
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    /* 
     And now for the part where we handle destroying chunks of the building. With your current knowledge of Core Graphics, this is something you can do with only one new thing: blend modes. When you draw anything to a Core Graphics context, you can set how it should be drawn. For example, should it be be drawn normally, or should it add to what's there to create a combination?

     Core Graphics has quite a few blend modes that might look similar, but we're going to use one called .clear, which means "delete whatever is there already." When combined with the fact that we already have a property called currentImage you might be able to see how our destructible terrain technique will work!

     Put simply, when we create the building we save its UIImage to a property of the BuildingNode class. When we want to destroy part of the building, we draw that image into a new context, draw an ellipse using .clear to blast a hole, then save that back to our currentImage property and update our sprite's texture.
     
     Figure out where the building was hit. Remember: SpriteKit's positions things from the center and Core Graphics from the bottom left!
     Create a new Core Graphics context the size of our current sprite.
     Draw our current building image into the context. This will be the full building to begin with, but it will change when hit.
     Create an ellipse at the collision point. The exact co-ordinates will be 32 points up and to the left of the collision, then 64x64 in size - an ellipse centered on the impact point.
     Set the blend mode .clear then draw the ellipse, literally cutting an ellipse out of our image.
     Convert the contents of the Core Graphics context back to a UIImage, which is saved in the currentImage property for next time we’re hit, and used to update our building texture.
     Call configurePhysics() again so that SpriteKit will recalculate the per-pixel physics for our damaged building.
 */
    func hit(at point: CGPoint) {
        let convertedPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            let ctx = context.cgContext
            
            currentImage.draw(at: .zero)
            
            ctx.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64))
            ctx.setBlendMode(.clear)
            ctx.drawPath(using: .fill)
        }
        
        texture = SKTexture(image: image)
        currentImage = image
        configurePhysics()
    }
}
