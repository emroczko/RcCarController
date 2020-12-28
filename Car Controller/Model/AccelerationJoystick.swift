//
//  AccelerationJoystick.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 09/12/2020.
//
import UIKit

protocol AccelerationDelegate {
    func panAccEnded(_ sender: AccelerationJoystick)
    
    func accelerate(_ sender: AccelerationJoystick)
    func accelerate400(_ sender: AccelerationJoystick)
    func reverse(_ sender: AccelerationJoystick)
    func reverse400(_ sender: AccelerationJoystick)
}

class AccelerationJoystick: UIView {

    var delegate: AccelerationDelegate?
    var lastLocation = CGPoint(x: 0, y: 0)
    var originalPosition = CGPoint()
    private let knobMaxDistanceFromOriginalPosition = CGFloat(60)
//    private var totalTranslationX = CGFloat(0.0)
//    private var totalTranslationY = CGFloat(0.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialization code
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(AccelerationJoystick.detectPan(_:)))
        self.gestureRecognizers = [panRecognizer]
        
        let imageView = UIImageView(image: UIImage(named: "knob"))
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.addSubview(imageView)
        self.bringSubviewToFront(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.superview)

        if (hypot(translation.x, translation.y) < knobMaxDistanceFromOriginalPosition) {
             if(translation.y < 0){
                 delegate?.accelerate400(self)
             }
             else{
                 delegate?.reverse400(self)
             }
            self.center = CGPoint(x: lastLocation.x , y: lastLocation.y + translation.y)
           
        } else{
            self.center = getNewCoords(translation)
            //delegate?.accelerate(self)
            if(translation.y < 0){
                delegate?.accelerate(self)
            }
            else{
                delegate?.reverse(self)
            }
        }
        
        if (recognizer.state == .ended) {
            delegate?.panAccEnded(self)
            
        }
    }
    
    func getNewCoords(_ translation: CGPoint) -> CGPoint {
        let a2 = translation.x
        let b2 = translation.y
        let d1 = knobMaxDistanceFromOriginalPosition
        var a1 = d1 * sin(atan(a2 / b2))
        var b1 = d1 * cos(atan(a2 / b2))
        
        // the following statement deals the sign uncertainty after the trig functions
        if translation.x > 0 {
            if translation.y < 0 {
                a1 *= -1
                b1 *= -1
            }
        } else {
            if (translation.y < 0) {
                a1 *= -1
                b1 *= -1
            }
        }
        
        let x = originalPosition.x
        let y = originalPosition.y + b1

        return CGPoint(x: x, y: y)
    }
    func accelerate(){
        
    }
    
    override func touchesBegan(_ touches: (Set<UITouch>?), with event: UIEvent!) {
        // Promote the touched view
        self.superview?.bringSubviewToFront(self)
        
        // Remember original location
        lastLocation = self.center
        originalPosition = self.center
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.panAccEnded(self)
    }
    
    func moveTo(_ point: CGPoint) {
        self.frame.origin = point
    }
}
