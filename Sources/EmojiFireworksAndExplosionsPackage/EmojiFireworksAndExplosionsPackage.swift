//
//  EmojiFireworksAndExplosionsPackage.swift
//
//  Created by Michael Kucinski on 8/2/20.
//  Copyright © 2020 Michael Kucinski. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageHere = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageHere!
    }
}

public extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

public class EmojiFireworksAndExplosionsPackage: UIViewController, UITextViewDelegate {
    
    public enum Sides {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    var poolOfEmittersAlreadyCreated = false
    public var arrayOfEmitters = [CAEmitterLayer]()
    var arrayOfCells = [CAEmitterCell]()
    
    let emojiLengthPerSide : Int = 100
    
    var lastChosenEmissionLongitude : CGFloat = 2 * CGFloat.pi
    var lastChosenEmissionLatitude : CGFloat = 2 * CGFloat.pi
    var lastChosenEmissionRange : CGFloat = 2 * CGFloat.pi
    var lastChosenAutoReverses : Bool = false
    var lastChosenIsEnabled : Bool = true
    var singlePassInUseAndValid = false
    var countdownForStoppingExpolsion = 2
    var stoppingExpolsionNeeded : Bool = false
    var lastSavedHeartCenter = CGPoint()
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var localTimer = Timer()
        
        if localTimer.isValid
        {
            // This blank if statement gets rid of a nuisance warning about never reading the timer.
        }
        
        // start the timer
        localTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(handleTimerEvent), userInfo: nil, repeats: true)
    }
    
    // starts handleTimer...
    @objc func handleTimerEvent()
    {
        if stoppingExpolsionNeeded
        {
            if countdownForStoppingExpolsion == 0
            {
                hideAllEmitters() // Just set the scale and scale speed to zero
                
                stoppingExpolsionNeeded = false
            }
        }
        
        countdownForStoppingExpolsion -= 1
        
    } // ends handleTimerEvent
    
    public func createPoolOfEmitters(
        maxCountOfEmitters : Int,
        someEmojiCharacter : String)
    {
        if poolOfEmittersAlreadyCreated
        {
            return
        }
        
        countOfEmittersInPool = maxCountOfEmitters
        
        var seedCurrent = 0
        
        let emojiString = someEmojiCharacter
        let textOrEmojiToUIImage = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        textOrEmojiToUIImage.textColor = UIColor.red
        textOrEmojiToUIImage.backgroundColor = UIColor.clear
        
        textOrEmojiToUIImage.text = emojiString
        textOrEmojiToUIImage.sizeToFit()
        
        for _ in 1...maxCountOfEmitters {
            
            let thisEmitter = CAEmitterLayer()
            
            thisEmitter.isHidden = false
            thisEmitter.emitterPosition = CGPoint(x: -1000, y: 0)
            
            thisEmitter.emitterShape = .point
            thisEmitter.emitterSize = CGSize(width: 50, height: 50)
            thisEmitter.renderMode = CAEmitterLayerRenderMode.oldestFirst
            
            let emojiString = someEmojiCharacter
            let textOrEmojiToUIImage = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            
            textOrEmojiToUIImage.text = emojiString
            textOrEmojiToUIImage.sizeToFit()
            
            let tempImageToUseWhenChangingCellImages  =  UIImage.imageWithLabel(label: textOrEmojiToUIImage)
            
            let aCell = makeCell(thisEmitter: thisEmitter, newColor: .white, contentImage: tempImageToUseWhenChangingCellImages)
            
            thisEmitter.emitterCells = [aCell]
            
            seedCurrent += 1
            thisEmitter.seed = UInt32(seedCurrent)
            
            arrayOfEmitters.append(thisEmitter)
            arrayOfCells.append(aCell)
        }
        
        hideAllEmitters()  // Make sure they are hidden at initialization
        
        poolOfEmittersAlreadyCreated = true
        
    } // ends createPoolOfEmitters
    
    func makeCell(
        thisEmitter     : CAEmitterLayer,
        newColor        : UIColor,
        contentImage    : UIImage) -> CAEmitterCell
    {
        let cell = CAEmitterCell()
        
        cell.birthRate          = 0
        cell.lifetime           = 0
        cell.lifetimeRange      = 0
        cell.color              = newColor.cgColor
        cell.emissionLongitude  = lastChosenEmissionLongitude
        cell.emissionLatitude   = lastChosenEmissionLatitude
        cell.emissionRange      = lastChosenEmissionRange
        cell.spin               = 0
        cell.spinRange          = 0
        cell.scale              = 0
        cell.scaleRange         = 0
        cell.scaleSpeed         = 0
        cell.alphaSpeed         = 0
        cell.alphaRange         = 0
        cell.autoreverses       = lastChosenAutoReverses
        cell.isEnabled          = lastChosenIsEnabled
        cell.velocity           = 0
        cell.velocityRange      = 0
        cell.xAcceleration      = 0
        cell.yAcceleration      = 0
        cell.zAcceleration      = 0
        cell.contents           = contentImage.cgImage
        cell.name               = "myCellName"
        
        return cell
        
    } // ends makeCell
    
    func makeCellBasedOnPreviousCell(
        thisEmitter : CAEmitterLayer,
        oldCell     : CAEmitterCell) -> CAEmitterCell
    {
        let cell = CAEmitterCell()
        
        cell.birthRate              = oldCell.birthRate
        cell.lifetime               = oldCell.lifetime
        cell.lifetimeRange          = oldCell.lifetimeRange
        cell.color                  = oldCell.color
        cell.emissionLongitude      = oldCell.emissionLongitude
        cell.emissionLatitude       = oldCell.emissionLatitude
        cell.emissionRange          = oldCell.emissionRange
        cell.spin                   = oldCell.spin
        cell.spinRange              = oldCell.spinRange
        cell.scale                  = oldCell.scale
        cell.scaleRange             = oldCell.scaleRange
        cell.scaleSpeed             = oldCell.scaleSpeed
        cell.alphaSpeed             = oldCell.alphaSpeed
        cell.alphaRange             = oldCell.alphaRange
        cell.autoreverses           = oldCell.autoreverses
        cell.isEnabled              = oldCell.isEnabled
        cell.velocity               = oldCell.velocity
        cell.velocityRange          = oldCell.velocityRange
        cell.xAcceleration          = oldCell.xAcceleration
        cell.yAcceleration          = oldCell.yAcceleration
        cell.zAcceleration          = oldCell.zAcceleration
        cell.name                   = oldCell.name
        cell.contents               = oldCell.contents
        
        return cell
        
    } // ends makeCellBasedOnPreviousCell
    
    func makeZeroSizeCell(
        thisEmitter : CAEmitterLayer,
        oldCell     : CAEmitterCell) -> CAEmitterCell
    {
        let cell = CAEmitterCell()
        
        cell.birthRate              = 0
        cell.lifetime               = 0
        cell.lifetimeRange          = 0
        cell.color                  = oldCell.color
        cell.emissionLongitude      = oldCell.emissionLongitude
        cell.emissionLatitude       = oldCell.emissionLatitude
        cell.emissionRange          = oldCell.emissionRange
        cell.spin                   = oldCell.spin
        cell.spinRange              = oldCell.spinRange
        cell.scale                  = 0
        cell.scaleRange             = 0
        cell.scaleSpeed             = 0
        cell.alphaSpeed             = oldCell.alphaSpeed
        cell.alphaRange             = 0
        cell.autoreverses           = oldCell.autoreverses
        cell.isEnabled              = oldCell.isEnabled
        cell.velocity               = oldCell.velocity
        cell.velocityRange          = oldCell.velocityRange
        cell.xAcceleration          = oldCell.xAcceleration
        cell.yAcceleration          = oldCell.yAcceleration
        cell.zAcceleration          = oldCell.zAcceleration
        cell.name                   = oldCell.name
        cell.contents               = oldCell.contents
        
        return cell
        
    } // ends makeZeroSizeCell
    
    
    public func hideAllEmitters()
    {
        // Just set the scale and scale speed to zero
        
        for thisIndex in 0...countOfEmittersInPool - 1
        {
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            thisEmitter.emitterPosition = CGPoint(x: -3000, y: -3000)
            
            let aCell = makeZeroSizeCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends hideAllEmitters
    
    public func alternateImageContentsWithGivenArray(
        desiredArrayAsText  : [String])
    {
        var indexIntoArray = 0
        
        for thisIndex in 0...countOfEmittersInPool - 1
        {
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            let newStringToImage = desiredArrayAsText[indexIntoArray]
            let textOrEmojiToUIImage = UILabel(frame: CGRect(x: 0, y: 0, width: emojiLengthPerSide, height: emojiLengthPerSide))
            
            textOrEmojiToUIImage.text = newStringToImage
            textOrEmojiToUIImage.sizeToFit()
            
            let tempImageToUseWhenChangingCellImages  =  UIImage.imageWithLabel(label: textOrEmojiToUIImage)
            
            indexIntoArray += 1
            
            if indexIntoArray >= desiredArrayAsText.count
            {
                indexIntoArray = 0
            }
            
            thisCell.contents = tempImageToUseWhenChangingCellImages.cgImage
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends alternateImageContentsWithGivenArray
    
    public func alternateImageTintWithGivenArray(
        desiredArray  : [UIColor])
    {
        var indexIntoArray = 0
        
        for thisIndex in 0...countOfEmittersInPool - 1
        {
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            let newColor = desiredArray[indexIntoArray]
            
            indexIntoArray += 1
            
            if indexIntoArray >= desiredArray.count
            {
                indexIntoArray = 0
            }
            
            thisCell.color = newColor.cgColor
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends alternateImageTintWithGivenArray
    
    var countOfEmittersInPool : Int = 200
    
    // Before this API is called, the developer needs to set the emoji to use for the explosion.
    public func detonate(
        thisCountOfEmittersGeneratingSparks : Int,
        thisVelocity : CGFloat,
        thisVelocityRange : CGFloat,
        thisSpin : CGFloat,
        thisSpinRange : CGFloat,
        thisStartingScale : CGFloat,
        thisStartingScaleRange : CGFloat = 0,
        thisEndingScale : CGFloat,
        thisAccelerationIn_X : CGFloat = 0,
        thisAccelerationIn_Y : CGFloat = 0,
        thisCellBirthrate: CGFloat,
        thisCellLifetime: CGFloat,
        thisCellLifetimeRange: CGFloat,
        thisExplosionDuration : CGFloat,
        thisTint              : UIColor = .white
    )
    {
        var countToDetonate : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToDetonate = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToDetonate = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToDetonate = countOfEmittersInPool
        }
        
        stoppingExpolsionNeeded = true
        countdownForStoppingExpolsion = Int(thisExplosionDuration * 60)
        
        var tempMinimum : Int = countOfEmittersInPool
        
        // Make sure we don't try to use more emitters than we have allocated.
        if countToDetonate < countOfEmittersInPool
        {
            tempMinimum = countToDetonate
        }
        
        for thisIndex in 0...tempMinimum - 1
        {
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            thisEmitter.isHidden = false
            
            let scaleChangeSpeed = -1 *  (thisStartingScale - thisEndingScale) / thisCellLifetime
            
            thisCell.velocity = thisVelocity
            thisCell.velocityRange = thisVelocityRange
            thisCell.scale = thisStartingScale
            thisCell.scaleSpeed = scaleChangeSpeed
            thisCell.scaleRange = thisStartingScaleRange
            thisCell.spin = thisSpin
            thisCell.spinRange = thisSpinRange
            thisCell.xAcceleration = thisAccelerationIn_X
            thisCell.yAcceleration = thisAccelerationIn_Y
            thisCell.birthRate = Float(thisCellBirthrate)
            thisCell.lifetime = Float(thisCellLifetime)
            thisCell.lifetimeRange = Float(thisCellLifetimeRange)
            thisCell.color = thisTint.cgColor
            
            thisEmitter.beginTime = CACurrentMediaTime()
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter,
                                                    oldCell: thisCell)
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
            
            thisEmitter.emitterCells = [thisCell]
        }
    } // ends detonate
    
    var lastUsedCountForCirclePlacement : Int = 2
    var lastUsedCountForHeartPlacement : Int = 2

    public func placeEmittersOnSpecifiedCircleOrArc(
        thisCircleCenter        : CGPoint,
        thisCircleRadius        : CGFloat,
        thisCircleArcFactor     : CGFloat = 1.0,
        offsetAngleInDegrees    : CGFloat = 0,
        scaleFactor             : CGFloat = 1.0,
        thisCountOfEmittersGeneratingSparks         : Int = -1)
    {
        var countToPlace : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToPlace = countOfEmittersInPool
        }
        
        lastUsedCountForCirclePlacement = countToPlace
        
        let angleBetweenEmitters : CGFloat = 360.0 / CGFloat(countToPlace) * thisCircleArcFactor
        var currentSumOfAngles : CGFloat = 0
        
        for thisIndex in 0...countToPlace - 1
        {
            arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: thisCircleCenter.x + scaleFactor * thisCircleRadius * sin(currentSumOfAngles.degreesToRadians + offsetAngleInDegrees.degreesToRadians), y: thisCircleCenter.y + scaleFactor * thisCircleRadius * cos(currentSumOfAngles.degreesToRadians + offsetAngleInDegrees.degreesToRadians))
            
            currentSumOfAngles += angleBetweenEmitters
        }
        
    } // ends placeEmittersOnSpecifiedCircleOrArc
    
    public func placeEmittersOnSpecifiedHeart(
        thisHeartCenter        : CGPoint,
        thisHeartScaleFactor   : CGFloat,
        thisCountOfEmittersGeneratingSparks         : Int = -1)
    {
        lastSavedHeartCenter = thisHeartCenter
        
        var countToPlace : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToPlace = countOfEmittersInPool
        }
        
        lastUsedCountForHeartPlacement = countToPlace

        let angleBetweenEmitters : CGFloat = 360.0 / CGFloat(countToPlace)
        var currentSumOfAngles : CGFloat = 0
        
        for thisIndex in 0...countToPlace - 1
        {
            let angleInRadians = currentSumOfAngles.degreesToRadians
            
            let cubedTerm = sin(angleInRadians) * sin(angleInRadians) * sin(angleInRadians)
            
            let pointX = thisHeartCenter.x + thisHeartScaleFactor * 16.0 * cubedTerm
            
            let pointY = thisHeartCenter.y + thisHeartScaleFactor * (-13*(cos(angleInRadians)) + 5*(cos(2*angleInRadians)) + 2*(cos(3*angleInRadians)) + 1*(cos(4*angleInRadians)))
                                    
            arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: pointX, y: pointY)
            
            print(arrayOfEmitters[thisIndex].emitterPosition)
            
            currentSumOfAngles += angleBetweenEmitters
        }
        
    } // ends placeEmittersOnSpecifiedHeart
    
    public func placeEmittersOnSpecifiedEllipse(
        thisCenter                          : CGPoint,
        thisMajorRadius                     : CGFloat,
        thisMinorRadius                     : CGFloat,
        alphaAngleInDegrees                 : CGFloat,
        omegaAngleInDegreesUsedForRotation  : CGFloat = 0,
        thisScaleFactor                     : CGFloat = 1.0,
        thisCountOfEmittersGeneratingSparks : Int = -1)
    {
        // From https://math.stackexchange.com/questions/2645689/what-is-the-parametric-equation-of-a-rotated-ellipse-given-the-angle-of-rotatio
        
        var countToPlace : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToPlace = countOfEmittersInPool
        }
        
        lastUsedCountForCirclePlacement = countToPlace // since it is ellipse I think it applies
        
        let angleBetweenEmitters : CGFloat = 360.0 / CGFloat(countToPlace)
        var currentSumOfAngles : CGFloat = 0
        
        for thisIndex in 0...countToPlace - 1
        {
            arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: thisScaleFactor * (thisMajorRadius * cos(currentSumOfAngles.degreesToRadians) * cos(omegaAngleInDegreesUsedForRotation.degreesToRadians) - thisMinorRadius * sin(currentSumOfAngles.degreesToRadians) * sin(omegaAngleInDegreesUsedForRotation.degreesToRadians)) + thisCenter.x, y: thisScaleFactor * (thisMajorRadius * cos(currentSumOfAngles.degreesToRadians) * sin(omegaAngleInDegreesUsedForRotation.degreesToRadians) + thisMinorRadius * sin(currentSumOfAngles.degreesToRadians) * cos(omegaAngleInDegreesUsedForRotation.degreesToRadians)) + thisCenter.y)
            
            currentSumOfAngles += angleBetweenEmitters
        }
        
    } // ends placeEmittersOnSpecifiedEllipseOrArc
    
    public func placeEmittersRandomlyInsideSpecifiedCircle(
        thisCircleCenter        : CGPoint,
        thisCircleRadius        : CGFloat,
        thisCountOfEmittersGeneratingSparks         : Int = -1)
    {
        var countToPlace : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToPlace = countOfEmittersInPool
        }
        
        for thisIndex in 0...countToPlace - 1
        {
            // Get some randomness based on the radius
            
            var withinRadiusPointNotFound = true
            
            var someRandom : UInt32
            
            var xRandomAsInt : Int = 1
            var yRandomAsInt : Int = 1
            
            while withinRadiusPointNotFound && thisCircleRadius > 4
                // No one in their right mind would call this with a radius less than 5
            {
                someRandom = arc4random() % UInt32(thisCircleRadius + 1)
                
                xRandomAsInt = Int(someRandom)
                
                if arc4random() % 2 == 0
                {
                    xRandomAsInt = -1 * xRandomAsInt
                }
                
                someRandom = arc4random() % UInt32(thisCircleRadius + 1)
                
                yRandomAsInt = Int(someRandom)
                
                if arc4random() % 2 == 0
                {
                    yRandomAsInt = -1 * yRandomAsInt
                }
                
                if sqrt((Double(yRandomAsInt * yRandomAsInt + xRandomAsInt * xRandomAsInt))) < Double(thisCircleRadius)
                {
                    withinRadiusPointNotFound = false
                }
                
            }
            arrayOfEmitters[thisIndex].emitterPosition =
                CGPoint(
                    x: thisCircleCenter.x + CGFloat(xRandomAsInt),
                    y: thisCircleCenter.y + CGFloat(yRandomAsInt))
        }
        
    } // ends placeEmittersRandomlyInsideSpecifiedCircle
    
    public func placeEmittersOnSpecifiedLine(
        startingPoint   : CGPoint,
        endingPoint     : CGPoint,
        thisCountOfEmittersGeneratingSparks : Int = -1)
    {
        var countToPlace : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToPlace = countOfEmittersInPool
        }
        
        var lastPosition_X : CGFloat = startingPoint.x
        var lastPosition_Y : CGFloat = startingPoint.y
        
        let horizontalDistanceToCoverPerPlacement : CGFloat = (endingPoint.x - startingPoint.x) / CGFloat((countToPlace - 1))
        
        let verticalDistanceToCoverPerPlacement : CGFloat = (endingPoint.y - startingPoint.y) / CGFloat((countToPlace - 1))
        
        for thisIndex in 0...countToPlace - 1
        {
            arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: lastPosition_X, y: lastPosition_Y)
            
            lastPosition_X += horizontalDistanceToCoverPerPlacement
            lastPosition_Y += verticalDistanceToCoverPerPlacement
        }
        
    } // ends placeEmittersOnSpecifiedLine
    
    public func placeEmittersOnSpecifiedSideOfRectangle(
        thisSide        : Sides,
        thisRectangle   : CGRect,
        thisCountOfEmittersGeneratingSparks : Int = -1)
    {
        var countToPlace : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToPlace = countOfEmittersInPool
        }
        
        var startingPoint = thisRectangle.origin
        var endingPoint = thisRectangle.origin
        
        if thisSide == Sides.Top
        {
            startingPoint = thisRectangle.origin
            endingPoint = CGPoint(x: startingPoint.x + thisRectangle.width, y: startingPoint.y)
        }
        else if thisSide == Sides.Bottom
        {
            endingPoint = CGPoint(x: startingPoint.x, y: startingPoint.y + thisRectangle.height)
            startingPoint = CGPoint(x: startingPoint.x + thisRectangle.width, y: startingPoint.y + thisRectangle.height)
        }
        else if thisSide == Sides.Right
        {
            endingPoint = CGPoint(x: startingPoint.x + thisRectangle.width, y: startingPoint.y + thisRectangle.height)
            startingPoint = CGPoint(x: startingPoint.x + thisRectangle.width, y: startingPoint.y)
        }
        else if thisSide == Sides.Left
        {
            endingPoint = CGPoint(x: startingPoint.x, y: startingPoint.y)
            startingPoint = CGPoint(x: startingPoint.x, y: startingPoint.y + thisRectangle.height)
        }
        
        var lastPosition_X : CGFloat = startingPoint.x
        var lastPosition_Y : CGFloat = startingPoint.y
        
        let horizontalDistanceToCoverPerPlacement : CGFloat = (endingPoint.x - startingPoint.x) / CGFloat((countToPlace - 1))
        
        let verticalDistanceToCoverPerPlacement : CGFloat = (endingPoint.y - startingPoint.y) / CGFloat((countToPlace - 1))
        
        for thisIndex in 0...countToPlace - 1
        {
            arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: lastPosition_X, y: lastPosition_Y)
            
            lastPosition_X += horizontalDistanceToCoverPerPlacement
            lastPosition_Y += verticalDistanceToCoverPerPlacement
        }
    } // ends placeEmittersOnSpecifiedSideOfRectangle
    
    public func placeEmittersOnSpecifiedRectangle(
        thisRectangle   : CGRect,
        scaleFactor     : CGFloat = 1.0,
        thisCountOfEmittersGeneratingSparks : Int = -1,
        combEmittersDesired : Bool = false,
        topDesiredCombingRelativeAngle : CGFloat = 0,
        topConeWideningFactorNormallyZero : CGFloat = 0,
        bottomDesiredCombingRelativeAngle : CGFloat = 0,
        bottomConeWideningFactorNormallyZero : CGFloat = 0,
        leftDesiredCombingRelativeAngle : CGFloat = 0,
        leftConeWideningFactorNormallyZero : CGFloat = 0,
        rightDesiredCombingRelativeAngle : CGFloat = 0,
        rightConeWideningFactorNormallyZero : CGFloat = 0)
    {
        var countToPlace : Int = thisCountOfEmittersGeneratingSparks
        
        var currentCombAngle : CGFloat = 0
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks > countOfEmittersInPool
        {
            countToPlace = countOfEmittersInPool
        }
        else if thisCountOfEmittersGeneratingSparks < -1
        {
            countToPlace = countOfEmittersInPool
        }
        
        // Rectange must be level with no offsetting angle.
        
        // This version places an equal number of emitters on all 4 sides if possible, but 3 sides may have one less emitter.
        
        // Figure out how many emitters per side
        let emittersPerSide : Int = ((countToPlace) / 4)
        
        var emittersTopSide : Int = emittersPerSide
        var emittersRightSide : Int = emittersPerSide
        var emittersBottomSide : Int = emittersPerSide
        let emittersLeftSide : Int = emittersPerSide
        
        if (countToPlace) % 4 != 0
        {
            emittersTopSide += 1
        }
        if (countToPlace) % 4 == 2
        {
            emittersRightSide += 1
        }
        if (countToPlace) % 4 == 3
        {
            emittersRightSide += 1
            emittersBottomSide += 1
        }
        
        var countOfEmittersPlacedSoFar : Int = 0
        var countOfHorizontalEmittersPlacedForThisSide : CGFloat = 0
        var countOfVerticalEmittersPlacedForThisSide : CGFloat = 0
        
        var horizontalDistanceToCoverPerPlacement : CGFloat = scaleFactor  * thisRectangle.width / 4
        var verticalDistanceToCoverPerPlacement : CGFloat = scaleFactor * thisRectangle.height / 4
        
        let origin_X_AdjustmentDueToScaleFactor = -(thisRectangle.width * scaleFactor - thisRectangle.width) / 2
        let origin_Y_AdjustmentDueToScaleFactor = -(thisRectangle.height * scaleFactor - thisRectangle.height) / 2
        
        var lastPosition_X : CGFloat = thisRectangle.origin.x + origin_X_AdjustmentDueToScaleFactor
        var lastPosition_Y : CGFloat = thisRectangle.origin.y + origin_Y_AdjustmentDueToScaleFactor
        
        for thisIndex in 0...countToPlace - 1
        {
            if countOfEmittersPlacedSoFar < emittersTopSide
            {
                horizontalDistanceToCoverPerPlacement = scaleFactor * thisRectangle.width /  CGFloat(emittersTopSide)
                
                arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: lastPosition_X, y: lastPosition_Y)
                
                lastPosition_X = lastPosition_X + horizontalDistanceToCoverPerPlacement
                
                countOfHorizontalEmittersPlacedForThisSide += 1
                
                currentCombAngle = -90  + topDesiredCombingRelativeAngle
                
                if combEmittersDesired
                {
                    let tempAngle : CGFloat = currentCombAngle.degreesToRadians
                    
                    // comb it
                    let thisCell = arrayOfCells[thisIndex]
                    let thisEmitter = arrayOfEmitters[thisIndex]
                    
                    let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
                    
                    aCell.emissionRange = CGFloat.pi * topConeWideningFactorNormallyZero
                    aCell.emissionLatitude = 0
                    
                    aCell.emissionLongitude = tempAngle
                    
                    thisEmitter.emitterCells = [aCell]
                    
                    // Update the array
                    arrayOfCells[thisIndex] = aCell
                }
            }
            else if countOfEmittersPlacedSoFar < emittersTopSide + emittersRightSide
            {
                verticalDistanceToCoverPerPlacement = thisRectangle.height /  CGFloat(emittersRightSide) * scaleFactor
                
                arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: lastPosition_X, y: lastPosition_Y)
                
                lastPosition_Y = lastPosition_Y + verticalDistanceToCoverPerPlacement
                
                countOfVerticalEmittersPlacedForThisSide += 1
                countOfHorizontalEmittersPlacedForThisSide = 0
                
                currentCombAngle = 0  + rightDesiredCombingRelativeAngle
                
                if combEmittersDesired
                {
                    let tempAngle : CGFloat = currentCombAngle.degreesToRadians
                    
                    // comb it
                    let thisCell = arrayOfCells[thisIndex]
                    let thisEmitter = arrayOfEmitters[thisIndex]
                    
                    let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
                    
                    aCell.emissionRange = CGFloat.pi * rightConeWideningFactorNormallyZero
                    aCell.emissionLatitude = 0
                    
                    aCell.emissionLongitude = tempAngle
                    
                    thisEmitter.emitterCells = [aCell]
                    
                    // Update the array
                    arrayOfCells[thisIndex] = aCell
                }
            }
            else if countOfEmittersPlacedSoFar < emittersTopSide + emittersRightSide + emittersBottomSide
            {
                horizontalDistanceToCoverPerPlacement = thisRectangle.width /  CGFloat(emittersBottomSide) * scaleFactor
                
                arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: lastPosition_X, y: lastPosition_Y)
                
                lastPosition_X = lastPosition_X - horizontalDistanceToCoverPerPlacement
                
                countOfHorizontalEmittersPlacedForThisSide += 1
                countOfVerticalEmittersPlacedForThisSide = 0
                
                currentCombAngle = 90  + bottomDesiredCombingRelativeAngle
                
                if combEmittersDesired
                {
                    let tempAngle : CGFloat = currentCombAngle.degreesToRadians
                    
                    // comb it
                    let thisCell = arrayOfCells[thisIndex]
                    let thisEmitter = arrayOfEmitters[thisIndex]
                    
                    let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
                    
                    aCell.emissionRange = CGFloat.pi * bottomConeWideningFactorNormallyZero
                    aCell.emissionLatitude = 0
                    
                    aCell.emissionLongitude = tempAngle
                    
                    thisEmitter.emitterCells = [aCell]
                    
                    // Update the array
                    arrayOfCells[thisIndex] = aCell
                }
            }
            else
            {
                verticalDistanceToCoverPerPlacement = thisRectangle.height /  CGFloat(emittersLeftSide) * scaleFactor
                
                arrayOfEmitters[thisIndex].emitterPosition = CGPoint(x: lastPosition_X, y: lastPosition_Y)
                
                lastPosition_Y = lastPosition_Y - verticalDistanceToCoverPerPlacement
                
                countOfVerticalEmittersPlacedForThisSide += 1
                countOfHorizontalEmittersPlacedForThisSide = 0
                
                currentCombAngle = 180  + leftDesiredCombingRelativeAngle
                
                if combEmittersDesired
                {
                    let tempAngle : CGFloat = currentCombAngle.degreesToRadians
                    
                    // comb it
                    let thisCell = arrayOfCells[thisIndex]
                    let thisEmitter = arrayOfEmitters[thisIndex]
                    
                    let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
                    
                    aCell.emissionRange = CGFloat.pi * leftConeWideningFactorNormallyZero
                    aCell.emissionLatitude = 0
                    
                    aCell.emissionLongitude = tempAngle
                    
                    thisEmitter.emitterCells = [aCell]
                    
                    // Update the array
                    arrayOfCells[thisIndex] = aCell
                }
            }
            
            countOfEmittersPlacedSoFar += 1
        }
        
    } // ends placeEmittersOnSpecifiedRectangle
    
    public func combCircularEmittersToPointInDesiredDirections(
        desiredOffsetAngleForCellFlow  : CGFloat = 0,
        desiredOffsetAngleForShape  : CGFloat = 0,
        coneWideningFactorNormallyZero     : CGFloat,
        combArcFactor       : CGFloat = 0,
        overrideAngleIncrementWithThisManyDegrees : CGFloat = 123456)
    {
        var currentAngleForEmissions : CGFloat = desiredOffsetAngleForCellFlow + 90 - desiredOffsetAngleForShape
        
        // How many?
        let countOfThem = lastUsedCountForCirclePlacement
        
        var AngleIncrementPerCount : CGFloat = combArcFactor * CGFloat(360.0 / Double(countOfThem))
        
        if overrideAngleIncrementWithThisManyDegrees != 123456
        {
            AngleIncrementPerCount = overrideAngleIncrementWithThisManyDegrees
        }
        
        var tempAngle : CGFloat
        
        tempAngle = currentAngleForEmissions.degreesToRadians
        
        for thisIndex in 0...lastUsedCountForCirclePlacement - 1
        {
            // comb them
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            aCell.emissionRange = CGFloat.pi * coneWideningFactorNormallyZero
            aCell.emissionLatitude = 0
            
            tempAngle = currentAngleForEmissions.degreesToRadians
            
            aCell.emissionLongitude = tempAngle
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
            
            currentAngleForEmissions -= AngleIncrementPerCount
        }
        
    } // ends combCircularEmittersToPointInDesiredDirections
    
    public func combHeartEmittersTowardsHeartCenter(
        desiredOffsetAngleForCellFlowInDegrees  : CGFloat = 0,
        coneWideningFactorNormallyZero     : CGFloat)
    {
        var tempAngle : CGFloat
        
        let offsetInRadians = desiredOffsetAngleForCellFlowInDegrees.degreesToRadians
        
        for thisIndex in 0...lastUsedCountForHeartPlacement - 1
        {
            // comb them
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            aCell.emissionRange = CGFloat.pi * coneWideningFactorNormallyZero
            aCell.emissionLatitude = 0
            
            // comb them towards the specified point
            let thisDeltaX = lastSavedHeartCenter.x - thisEmitter.emitterPosition.x
            let thisDeltaY = lastSavedHeartCenter.y - thisEmitter.emitterPosition.y
            
            tempAngle = atan2(thisDeltaY, thisDeltaX)
            
            aCell.emissionLongitude = tempAngle + offsetInRadians
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends combHeartEmittersTowardsHeartCenter
    
    public func combEmittersTowardsOrAwayFromSpecifiedPoint(
        thisPoint        : CGPoint,
        desiredOffsetAngleForCellFlowInDegrees  : CGFloat = 0,
        coneWideningFactorNormallyZero     : CGFloat,
        thisCountOfEmittersGeneratingSparks         : Int = -1)
    {
        var countHere : Int = thisCountOfEmittersGeneratingSparks
        
        if thisCountOfEmittersGeneratingSparks == -1
        {
            countHere = countOfEmittersInPool
        }
        else if countHere > countOfEmittersInPool
        {
            countHere = countOfEmittersInPool
        }
        else if countHere < -1
        {
            countHere = countOfEmittersInPool
        }
        
        var tempAngle : CGFloat
        
        let offsetInRadians = desiredOffsetAngleForCellFlowInDegrees.degreesToRadians
        
        for thisIndex in 0...countHere - 1
        {
            // comb them
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            aCell.emissionRange = CGFloat.pi * coneWideningFactorNormallyZero
            aCell.emissionLatitude = 0
            
            // comb them towards the specified point
            let thisDeltaX = thisPoint.x - thisEmitter.emitterPosition.x
            let thisDeltaY = thisPoint.y - thisEmitter.emitterPosition.y
            
            tempAngle = atan2(thisDeltaY, thisDeltaX)
            
            aCell.emissionLongitude = tempAngle + offsetInRadians
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends combEmittersTowardsOrAwayFromSpecifiedPoint
    
    var X_ValueForPriorPointOnElliptical : CGFloat = 0
    var Y_ValueForPriorPointOnElliptical : CGFloat = 0
    
    var countOfEllipticalTangentPointsProcessed : Int = 0
    
    public func combEllipticalEmittersToPointInDesiredDirections(
        desiredOffsetAngleForCellFlow  : CGFloat = 0,
        coneWideningFactorNormallyZero : CGFloat = 0)
    {
        for thisIndex in 0...countOfEmittersInPool - 1
        {
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            var tangentAngle : CGFloat = 0
            
            if thisIndex > 0 // wont be able to get tangent for index 0 until later
            {
                // comb them
                let thisDeltaX = X_ValueForPriorPointOnElliptical - thisEmitter.emitterPosition.x
                let thisDeltaY = Y_ValueForPriorPointOnElliptical - thisEmitter.emitterPosition.y
                
                tangentAngle = atan2(thisDeltaY, thisDeltaX)
            }
            else
            {
                // Its the first one, use the
                let lastEmitter = arrayOfEmitters[countOfEmittersInPool - 1]
                
                X_ValueForPriorPointOnElliptical = lastEmitter.emitterPosition.x
                Y_ValueForPriorPointOnElliptical = lastEmitter.emitterPosition.y
                
                // comb them
                let thisDeltaX = X_ValueForPriorPointOnElliptical - thisEmitter.emitterPosition.x
                let thisDeltaY = Y_ValueForPriorPointOnElliptical - thisEmitter.emitterPosition.y
                
                tangentAngle = atan2(thisDeltaY, thisDeltaX)
            }
            
            X_ValueForPriorPointOnElliptical = thisEmitter.emitterPosition.x
            Y_ValueForPriorPointOnElliptical = thisEmitter.emitterPosition.y
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            aCell.emissionRange = CGFloat.pi * coneWideningFactorNormallyZero
            aCell.emissionLatitude = 0
            
            aCell.emissionLongitude = tangentAngle + desiredOffsetAngleForCellFlow.degreesToRadians
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends combCircularEmittersToPointInDesiredDirections
    
    public func combAllEmittersToPointInDesiredDirectionWithDesiredCone(
        directionAngleForCellFlow       : CGFloat,
        coneWideningFactorNormallyZero  : CGFloat)
    {
        var tempAngle : CGFloat
        
        tempAngle = directionAngleForCellFlow.degreesToRadians
        
        for thisIndex in 0...countOfEmittersInPool - 1
        {
            // comb them
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            aCell.emissionRange = CGFloat.pi * coneWideningFactorNormallyZero
            aCell.emissionLatitude = 0
            
            aCell.emissionLongitude = tempAngle
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends combAllEmittersToPointInDesiredDirectionWithDesiredCone
    
    public func stopCombingTheEmitters()
    {
        for thisIndex in 0...lastUsedCountForCirclePlacement - 1
        {
            // randomize them
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            aCell.emissionRange = 2 * CGFloat.pi
            aCell.emissionLatitude = 2 * CGFloat.pi
            aCell.emissionLongitude = 2 * CGFloat.pi
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends stopCombingTheEmitters
    
    public func useSpecifiedImageAsContentsForAllEmitters(
        specifiedImage  : UIImage)
    {
        for thisIndex in 0...countOfEmittersInPool - 1
        {
            let thisCell = arrayOfCells[thisIndex]
            let thisEmitter = arrayOfEmitters[thisIndex]
            
            thisCell.contents = specifiedImage.cgImage
            
            let aCell = makeCellBasedOnPreviousCell(thisEmitter: thisEmitter, oldCell: thisCell)
            
            thisEmitter.emitterCells = [aCell]
            
            // Update the array
            arrayOfCells[thisIndex] = aCell
        }
        
    } // ends useSpecifiedImageAsContentsForAllEmitters
    
} // ends file

