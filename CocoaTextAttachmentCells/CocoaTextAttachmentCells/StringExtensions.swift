//
//  StringExtensions.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 04/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa

extension String {
    func size(withAttributes attrs: [String:AnyObject], constrainedTo box: NSSize, padding: CGFloat = 0.0) -> NSSize {
        let storage = NSTextStorage(string: self)
        let container = NSTextContainer(containerSize: NSSize(width: box.width, height: box.height))
        let layout = NSLayoutManager()
        layout.addTextContainer(container)
        storage.addLayoutManager(layout)
        storage.addAttributes(attrs, range: NSMakeRange(0, storage.length))
        container.lineFragmentPadding = padding
        let _ = layout.glyphRange(for: container)
        let ur = layout.usedRect(for: container)
        
        return NSSize(width: ur.width, height: ur.height)
    }
}


extension String : VisualPartConvertible {
    func build(withStyle style: VisualStyle) -> VisualPart {
        let size = VisualPart.textSize(forText: self, withFont: style.displayFont())
        return VisualPart.text(t: self, frame: size, style: style)
    }
}
