//: Playground - noun: a place where people can play

import UIKit

// https://s3.amazonaws.com/lyft/ios/imgs/uiview-rectangle-selection.gif

/***
 Assumptions:
 * Storyboard with views
 * Access array of views
 
 TODO
 * view overlay of our views
 
 
 Determine 2 things - view overlay overlap
 * horizontalOverlap
 * vertialOverlap
 
 Case Scenarios:
 #1 - Access the rectangle: Overlay
 #2 - Determine the overlaps given our rectangle overlay (UIView) Create a CGRect: (x,y,width,height)
 
 Using that info - determine intersects AND color with desired UIColor
 
 **/

final class RectangleSelectionViewController: UIViewController {
    @IBOutlet private var views: [UIView]!
    
    fileprivate var overlay: CGRect?
    fileprivate var startLocation: CGPoint!
    fileprivate var endLocation: CGPoint!
    
    // Touches Begin
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        self.startLocation = touch.location(in: self.view)
    }
    
    // Touches Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        self.endLocation = touch.location(in: self.view)
        constructOverlay(startLocation, endLocation)
    }
    
    fileprivate func constructOverlay(_ startLocation: CGPoint, _ endLocation: CGPoint) {
        
        // Start Location
        let xValue = startLocation.x
        let yValue = startLocation.y
        
        // End Location
        let width = endLocation.x - xValue
        let height = endLocation.y - yValue
        
        // Determine the rectangle
        let rectangle = CGRect(x: xValue, y: yValue, width: width, height: height)
        
        // Determines the intersects
        for view in views {
            if rectangle.intersects(view.frame) {
                view.backgroundColor = UIColor.magenta
            }
        }
    }
    
}

