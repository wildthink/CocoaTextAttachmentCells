//
//  ImageRenderer.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 13/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa



class GraphicalImageRender : VisualElementRenderer, VisualElementLayoutHandler {
    typealias RenderType = NSImage
    
    func text(_ text: String, atPoint p: NSPoint, withStyle style: VisualStyle) {
        guard let ctx = NSGraphicsContext.current else {return}
        ctx.cgContext.saveGState()
        defer {ctx.cgContext.restoreGState()}

        let ns = text as NSString
        let font = style.displayFont()
        ns.draw(at: p, withAttributes: [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:NSColor.black])
    }
    
    func box(_ origin: NSPoint, size: NSSize, withStyle style: VisualStyle) {
        guard let ctx = NSGraphicsContext.current else {return}
        ctx.cgContext.saveGState()
        defer {ctx.cgContext.restoreGState()}

        let r = NSRect(origin: origin, size: size)
        let p = NSBezierPath(rect: r)
        NSColor.black.setStroke()
        p.lineWidth = 1
        p.stroke()
    }
        
    func shape(_ type: ShapeType, frame f: NSRect, withStyle style: VisualStyle) {
        guard let ctx = NSGraphicsContext.current else {return}
        ctx.cgContext.saveGState()
        defer {ctx.cgContext.restoreGState()}
        
        switch type {
        case .empty: ()

        case let .path(pts) :
            switch pts.count {
            case 0: return  // no path
            case 1 : return // single point
            case let n :
                let p = NSBezierPath()
                p.lineWidth = 1.0
                p.move(to: pts[0] + f.origin)
                for i in 1..<n {
                    p.line(to: pts[i] + f.origin)
                }
                
                p.stroke()
            }
            
        case let .curve(from,cp1,cp2,to) :
            let p = NSBezierPath()
            p.lineWidth = 1
            p.move(to: from + f.origin)
            p.curve(to: to + f.origin, controlPoint1: cp1 + f.origin, controlPoint2: cp2 + f.origin)
            p.stroke()
            
        case let .complexPath(path) :
            let p = path(f,style)
            p.stroke()
        }
    }

    
    func render(item i: VisualPart, withStyle style: VisualStyle) -> (RenderType,ElementSize) {
        let f = i.frame
        let inlineImg = NSImage(size: NSSize(width: f.width, height: f.height), flipped: false) {(r) -> Bool in
            self.layout(i, x: 0, y:0, containerSize: f, withStyle: style)
            return true
        }
        return (inlineImg,f)
    }
}
