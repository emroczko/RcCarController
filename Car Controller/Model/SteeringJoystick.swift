//
//  SteeringJoystick.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 09/12/2020.
//

import UIKit


protocol SteeringDelegate {
    func panSteerEnded(_ sender: SteeringJoystick)
    func turnLeft(_ sender: SteeringJoystick)
    func turnRight(_ sender: SteeringJoystick)
}

class SteeringJoystick: UIView {

    // MARK: - Properties
    var delegate: SteeringDelegate?
    var lastLocation = CGPoint(x: 0, y: 0)
    var originalPosition = CGPoint()
    private let knobMaxDistanceFromOriginalPosition = CGFloat(60)

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(SteeringJoystick.detectPan(_:)))
        self.gestureRecognizers = [panRecognizer]
        
        let imageView = UIImageView(image: UIImage(named: "knob"))
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.addSubview(imageView)
        self.bringSubviewToFront(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // MARK: - Touch methods
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.superview)

        if (hypot(translation.x, translation.y) < knobMaxDistanceFromOriginalPosition) {
            self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y)
        } else {
            self.center = getNewCoords(translation)
            if(translation.x < 0){
                delegate?.turnLeft(self)
            }
            else{
                delegate?.turnRight(self)
            }
        }
        
        if (recognizer.state == .ended) {
            delegate?.panSteerEnded(self)
        }
   
    }
    
    override func touchesBegan(_ touches: (Set<UITouch>?), with event: UIEvent!) {
        self.superview?.bringSubviewToFront(self)
        lastLocation = self.center
        originalPosition = self.center
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.panSteerEnded(self)
    }
    
   
    
    // MARK: - Methods
    
    func getNewCoords(_ translation: CGPoint) -> CGPoint {
        
        var a = knobMaxDistanceFromOriginalPosition * sin(atan(translation.x / translation.y))
        
        if (translation.y < 0) {
            a *= -1
        }
        
        return CGPoint(x: originalPosition.x + a, y: originalPosition.y)
    }

    func moveTo(_ point: CGPoint) {
        self.frame.origin = point
    }
}

