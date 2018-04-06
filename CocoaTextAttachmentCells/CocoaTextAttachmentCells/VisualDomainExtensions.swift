//
//  VisualDomainExtensions.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 17/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa

/// Helper to provide information on visual elements
extension VisualPart {
    static func textSize(forText symbol: String, withFont font: NSFont) -> ElementSize {
        let displaySize = symbol.size(withAttributes: [NSAttributedStringKey.font: font], constrainedTo: NSSize(width: 5000, height: 5000), padding: 0.0)
        let h = max(displaySize.height, font.ascender + fabs(font.descender))
        return ElementSize(width: displaySize.width, height: h, realWidth: displaySize.width, baseline: fabs(font.descender), xHeight: font.xHeight)
    }
    
    var frame : ElementSize {
        switch self {
        case let .text(_,frame,_) : return frame
        case let .Spacer(frame) : return frame
        case let .Sequence(_,frame,_) : return frame
        case let .Padded(_,_,_,_,_,frame,_) : return frame
        case let .Pair(_,_,_,frame,_) : return frame
        case let .Stack(_,frame,_) : return frame
        case let .shape(_,frame,_) : return frame 
        }
    }
    
    static func line(_ sp: NSPoint, ep: NSPoint, fr: ElementSize, withStyle style : VisualStyle) -> VisualPart {
        let lns = ShapeType.path(points: [sp,ep])
        return VisualPart.shape(type: lns, frame: fr, style: style)
    }
    
    static func sequence(_ parts: [VisualPart], withStyle style: VisualStyle, withSpacing spc: CGFloat? = .none) -> VisualPart {
        guard parts.count > 0 else {return VisualPart.Sequence(items: [], frame: ElementSize.zero , style: style)}
        
        var elements = parts
        if let s = spc {
            let spacer = VisualPart.spacer(s, height: 0)
            elements = elements.intersperse(spacer)
        }
        
        let font = style.displayFont()
        let (w,a,b) = elements.reduce((0,0,0), { (a, p) -> (CGFloat,CGFloat,CGFloat) in
            let f = p.frame
            let asc = f.height - f.baseline
            return (a.0 + f.width, max(a.1,asc), max(a.2,f.baseline))
        })
        
        let size = ElementSize(width: w, height: (a+b), realWidth: w, baseline: b, xHeight: font.xHeight)
        return VisualPart.Sequence(items: elements, frame: size, style: style)
    }
    
    static func stack(_ parts : [VisualPart], withStyle style: VisualStyle) -> VisualPart {
        func height(ofSlice s: Range<Int>) -> CGFloat {
            return parts[s].reduce(0, { (a, p) -> CGFloat in
                let f = p.frame
                return a + f.height
            })
        }
        
        switch parts.count {
        case 0: return VisualPart.Stack(items: [], frame: ElementSize.zero, style: style)
        case 1: return parts[0]
        case let n:
            let font = style.displayFont()
            let (w,h) = parts.reduce((0,0), { (a, p) -> (CGFloat,CGFloat) in
                let f = p.frame
                return (max(a.0, f.width), a.1 + f.height)
            })
            
            let mid = n / 2
            let bs : CGFloat
            if n % 2 == 0 {
                bs = height(ofSlice: mid..<n) - font.xHeight/2
            }
            else {
                let f = parts[mid].frame
                bs = height(ofSlice: (mid + 1)..<n) + f.baseline
            }
            
            let frame = ElementSize(width: w, height: h, realWidth: w, baseline: bs, xHeight: font.xHeight)
            return VisualPart.Stack(items: parts, frame: frame, style: style)
        }
    }
    
    static func spacer(_ width: CGFloat, height: CGFloat) -> VisualPart {
        return VisualPart.Spacer(frame: ElementSize(width: width, height: height, realWidth: width, baseline: 0, xHeight: 0))
    }
    
    static func padded(_ item: VisualPart, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat, style: VisualStyle) -> VisualPart {
        let f = item.frame
        let w = f.width + left + right
        let h = f.height + top + bottom
        let b = f.baseline + bottom
        let frame = ElementSize(width: w, height: h, realWidth: f.width, baseline: b, xHeight: f.xHeight)
        return VisualPart.Padded(item: item, left: left, right: right, top: top, bottom: bottom, frame: frame, style: style)
    }
    
    static func pair(_ item: VisualPart, positioning pos: PairPositioning, base: VisualPart, withStyle style: VisualStyle) -> VisualPart {
        let bf = base.frame
        let of = item.frame
        let h = bf.height + of.height
        let w = max(bf.width, of.width)
        switch pos {
        case .over :
            let frame = ElementSize(width: w, height: h, realWidth: w, baseline: bf.baseline, xHeight: bf.xHeight)
            return VisualPart.Pair(item: item, positioned: pos, baselined: base, frame: frame, style: style)

        case .under:
            let frame = ElementSize(width: w, height: h, realWidth: w, baseline: bf.baseline + of.height, xHeight: bf.xHeight)
            return VisualPart.Pair(item: item, positioned: pos, baselined: base, frame: frame, style: style)
        }
    }
    
    static func under(_ item: VisualPart, base: VisualPart, withStyle style: VisualStyle) -> VisualPart {
        return pair(item, positioning: .under, base: base, withStyle: style)
    }
    
    static func over(_ item: VisualPart, base: VisualPart, withStyle style: VisualStyle) -> VisualPart {
        return pair(item, positioning: .over, base: base, withStyle: style)
    }

}


/// Modify the Visual Styling (simply allow font size change at the moment)
extension VisualStyle {
    // frame the element
    func framed(_ f: Bool) -> VisualStyle {
        return VisualStyle(fontSize: self.fontSize, drawFrame: f, inline: self.inline, italic: self.italic, bold: self.bold)
    }
    
    func italisised(_ i: Bool) -> VisualStyle {
        return VisualStyle(fontSize: self.fontSize, drawFrame: self.drawFrame, inline: self.inline, italic: i, bold: self.bold)
    }
    
    func bolded(_ b: Bool) -> VisualStyle {
        return VisualStyle(fontSize: self.fontSize, drawFrame: self.drawFrame, inline: self.inline, italic: self.italic, bold: b)
    }
    
    func inlined(_ i : Bool) -> VisualStyle {
        return VisualStyle(fontSize: self.fontSize, drawFrame: self.drawFrame, inline: i, italic: self.italic, bold: self.bold)
    }

    // Reduce the fontSize
    var smaller : VisualStyle {
        let fs = self.fontSize > 6 ? self.fontSize * 0.8 : self.fontSize
        return VisualStyle(fontSize: fs, drawFrame: self.drawFrame, inline: self.inline, italic: self.italic, bold: self.bold)
    }
    
    // Increase the fontSize
    var bigger : VisualStyle {
        return VisualStyle(fontSize: self.fontSize * 1.2, drawFrame: self.drawFrame, inline: self.inline, italic: self.italic, bold: self.bold)
    }
    
    func displayFont() -> NSFont {
        var traits : NSFontTraitMask = NSFontTraitMask()
        if italic {
            traits.insert(NSFontTraitMask.italicFontMask)
        }
        
        if bold {
            traits.insert(NSFontTraitMask.boldFontMask)
        }
        
        let fm = NSFontManager.shared
        if let fnt = fm.font(withFamily: "Times New Roman", traits: traits, weight: 1, size: fontSize) {
            return fnt
        }
        
        return NSFont.systemFont(ofSize: fontSize)
    }
}
