//
//  GameObjectRendering.swift
//  TestSwift
//
//  Created by aship on 2020/11/13.
//

import SceneKit
import SpriteKit

extension GameObject {
    // MARK: - Configure rendering quality
    
    func configureRenderingQuality(_ view: SCNView) {
        
        #if os( tvOS )
        self.turnOffEXR()  //tvOS doesn't support exr maps
        // the following things are done for low power device(s) only
        self.turnOffNormalMaps()
        self.turnOffHDR()
        self.turnOffDepthOfField()
        self.turnOffSoftShadows()
        self.turnOffPostProcess()
        self.turnOffOverlay()
        self.turnOffVertexShaderModifiers()
        self.turnOffVegetation()
        #endif
    }
    
    func turnOffEXRForMAterialProperty(property: SCNMaterialProperty) {
        if var propertyPath = property.contents as? NSString {
            if propertyPath.pathExtension == "exr" {
                propertyPath = ((propertyPath.deletingPathExtension as NSString).appendingPathExtension("png")! as NSString)
                property.contents = propertyPath
            }
        }
    }
    
    func turnOffEXR() {
        self.turnOffEXRForMAterialProperty(property: scene!.background)
        self.turnOffEXRForMAterialProperty(property: scene!.lightingEnvironment)
        
        scene?.rootNode.enumerateChildNodes { (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            if let materials = child.geometry?.materials {
                for material in materials {
                    self.turnOffEXRForMAterialProperty(property: material.selfIllumination)
                }
            }
        }
    }
    
    func turnOffNormalMaps() {
        scene?.rootNode.enumerateChildNodes({ (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            if let materials = child.geometry?.materials {
                for material in materials {
                    material.normal.contents = SKColor.black
                }
            }
        })
    }
    
    func turnOffHDR() {
        scene?.rootNode.enumerateChildNodes({ (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            child.camera?.wantsHDR = false
        })
    }
    
    func turnOffDepthOfField() {
        scene?.rootNode.enumerateChildNodes({ (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            child.camera?.wantsDepthOfField = false
        })
    }
    
    func turnOffSoftShadows() {
        scene?.rootNode.enumerateChildNodes({ (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            if let lightSampleCount = child.light?.shadowSampleCount {
                child.light?.shadowSampleCount = min(lightSampleCount, 1)
            }
        })
    }
    
    func turnOffPostProcess() {
        scene?.rootNode.enumerateChildNodes({ (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            if let light = child.light {
                light.shadowCascadeCount = 0
                light.shadowMapSize = CGSize(width: 1024, height: 1024)
            }
        })
    }
    
    func turnOffOverlay() {
        sceneRenderer?.overlaySKScene = nil
    }
    
    func turnOffVertexShaderModifiers() {
        scene?.rootNode.enumerateChildNodes({ (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            if var shaderModifiers = child.geometry?.shaderModifiers {
                shaderModifiers[SCNShaderModifierEntryPoint.geometry] = nil
                child.geometry?.shaderModifiers = shaderModifiers
            }
            
            if let materials = child.geometry?.materials {
                for material in materials where material.shaderModifiers != nil {
                    var shaderModifiers = material.shaderModifiers!
                    shaderModifiers[SCNShaderModifierEntryPoint.geometry] = nil
                    material.shaderModifiers = shaderModifiers
                }
            }
        })
    }
    
    func turnOffVegetation() {
        scene?.rootNode.enumerateChildNodes({ (child: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
            guard let materialName = child.geometry?.firstMaterial?.name as NSString? else { return }
            if materialName.hasPrefix("plante") {
                child.isHidden = true
            }
        })
    }
}
