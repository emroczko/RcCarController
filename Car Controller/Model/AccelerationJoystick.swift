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

    // MARK: - Properties
    var delegate: AccelerationDelegate?
    var lastLocation = CGPoint(x: 0, y: 0)
    var originalPosition = CGPoint()
    private let knobMaxDistanceFromOriginalPosition = CGFloat(60)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    // MARK: - Touch methods
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.superview)

        if (hypot(translation.x, translation.y) < knobMaxDistanceFromOriginalPosition){
             
            if(translation.y < 0){
                delegate?.accelerate400(self)
            }
            else{
                delegate?.reverse400(self)
            }
            self.center = CGPoint(x: lastLocation.x , y: lastLocation.y + translation.y)
           
        }
        else{
            self.center = getNewCoords(translation)
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
    
    override func touchesBegan(_ touches: (Set<UITouch>?), with event: UIEvent!) {
        self.superview?.bringSubviewToFront(self)
        lastLocation = self.center
        originalPosition = self.center
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.panAccEnded(self)
    }
    
    // MARK: - Methods
    func getNewCoords(_ translation: CGPoint) -> CGPoint {
       
        var b = knobMaxDistanceFromOriginalPosition * cos(atan(translation.x / translation.y))
        
        if translation.y < 0 {
            b *= -1
        }

        return CGPoint(x: originalPosition.x, y: originalPosition.y + b)
    }
    
    func moveTo(_ point: CGPoint) {
        self.frame.origin = point
    }
}
