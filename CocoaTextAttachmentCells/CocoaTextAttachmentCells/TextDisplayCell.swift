//
//  TextDisplayCell.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 04/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa


class TextDisplayCell : NSTextAttachmentCell {
    var style   : VisualStyle
    var size    : ElementSize
    
    init<T : VisualElementRenderer>(item i: VisualPart, style : VisualStyle, usingRenderer rdr: T) where T.RenderType == NSImage {
        self.style = style
        let (img,s) = rdr.render(item: i, withStyle: style)
        self.size = s
        super.init(imageCell: img)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func cellSize() -> NSSize {
        return size.size
    }
    
    override func cellBaselineOffset() -> NSPoint {
        return NSPoint(x: 0, y: -size.baseline)
    }
}
