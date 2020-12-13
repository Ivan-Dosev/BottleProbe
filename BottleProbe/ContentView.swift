//
//  ContentView.swift
//  BottleProbe
//
//  Created by Ivan Dimitrov on 13.12.20.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var colorShadow : Color = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    var width : CGFloat {
        let a = UIScreen.main.bounds.width
        if a < 700 {
            return a
        }else{
            return 700
        }
    }
    
    var height : CGFloat {
        let b = UIScreen.main.bounds.width
        if b < 700 {
            return UIScreen.main.bounds.height
        }else{
            return 1000
        }
    }
    
    var magickScene : SKScene {

        let scene = MagicScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .white
        return scene
    }
    
    var body: some View {
        ZStack {
            VStack {
                SpriteView(scene: magickScene)
                  .background(Color.clear)
//                    .frame(width: 480, height: 480, alignment: .center)
                    .disabled(false)
            }
            .frame(width: width / 1.1, height: width / 1.1 , alignment: .center)
            .background(
                ZStack {
                    Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -8.0, y: -8.0) })
             .foregroundColor(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
             .shadow(color: colorShadow, radius: 20, x: 20.0  , y:  20.0)
             .shadow(color: Color.white, radius: 20, x: -20.0 , y: -20.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class MagicScene: SKScene {
    
    let boy = SKSpriteNode(imageNamed: "bottle")
    var shatterNode: ShatterNode?
    var animationTimer: Timer?
    var resolutionXTextField = 10
    var resolutionYTextField = 30
    var animationSlider  : CGFloat = 0

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        loadBoy()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
             resetAndPlayDemoAnimation()
    }
    
    func loadBoy() {
        boy.position  = CGPoint(x: 200, y: 200)
        boy.zPosition = 1
//        boy.setScale(0.001)
        addChild(boy)
        Random.seed()
    }
    
     func updateAnimation() {
         let progress = CGFloat(animationSlider)
         if let shatterPieces = shatterNode?.pieces {
             for piece in shatterPieces {
                 if let animationMetadata = piece.shatterAnimationMetadata {
                    animationMetadata.applyPositionAndRotation(for: progress , to: piece )
                 }
             }
         }
     }
     

     func resetAndPlayDemoAnimation() {
         shatterNode?.removeFromParent()
         shatterNode = nil
         animationTimer?.invalidate()
         animationSlider = 0
         let resolutionX = max(min(resolutionXTextField, 24), 2)
         let resolutionY = max(min(resolutionYTextField, 24), 2)
         shatterNode = boy.shatter(into: CGSize(width: resolutionX, height: resolutionY), animation: .manual, showHeatmap: true)
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
             self?.runDemoAnimation()
         
         })
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
            shatterNode?.removeFromParent()
        }
        
       
     }
     
     func runDemoAnimation() {
         animationTimer?.invalidate()
         animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true, block: { [weak self] timer in
             if let blockSelf = self {
                 if blockSelf.animationSlider < CGFloat(1.0) {
                     blockSelf.animationSlider += CGFloat(0.008)
                    if blockSelf.animationSlider > 1 {
                        blockSelf.animationSlider = 1
                    }
                     blockSelf.updateAnimation()
                 } else {
                    blockSelf.animationSlider = 0
                     timer.invalidate()
                 }
             }
         })
     }
    
}
