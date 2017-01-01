//
//  VisualDomain.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 09/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa

/// Capture the size characteristics of a Visual Element
struct ElementSize {
    let width       : CGFloat
    let height      : CGFloat
    let realWidth   : CGFloat
    let baseline    : CGFloat
    let xHeight     : CGFloat
}

/// Visual style elements
struct VisualStyle {
    let fontSize    : CGFloat
    let drawFrame   : Bool
    let inline      : Bool
    let italic      : Bool
    let bold        : Bool 
}

enum ShapeType {
    case empty
    case path(points: [NSPoint])
    case curve(from: NSPoint, cp1: NSPoint, cp2: NSPoint, to: NSPoint)
    case complexPath(f : (NSRect,VisualStyle) -> NSBezierPath)
}

enum PairPositioning {
    case over
    case under
}

/// The set of elements which can be rendered
indirect enum VisualPart {
    case text(t: String, frame: ElementSize, style: VisualStyle)
    case Spacer(frame: ElementSize)
    case Sequence(items : [VisualPart], frame: ElementSize, style: VisualStyle)
    case Padded(item: VisualPart, left : CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat, frame: ElementSize, style: VisualStyle)
    case Pair(item: VisualPart, positioned: PairPositioning, baselined: VisualPart, frame: ElementSize, style: VisualStyle)
    case Stack(items: [VisualPart], frame: ElementSize, style: VisualStyle)
    case shape(type: ShapeType, frame: ElementSize, style: VisualStyle)
}

/// Protocol for domain types which can be visualised.
protocol VisualPartConvertible {
    func build(withStyle style: VisualStyle) -> VisualPart
}


extension ElementSize {
    var size : NSSize {return NSSize(width: self.width, height: self.height)}
    static var zero : ElementSize { return ElementSize(width: 0, height: 0, realWidth: 0, baseline: 0, xHeight: 0)}
}
