//
//  TextView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/07/01.
//

import SwiftUI

/// A wrapper around NSTextView so we can get multiline text editing in SwiftUI.
struct TextView: NSViewRepresentable {
    @Binding private var text: String
    @Binding var dynamicHeight: CGFloat
    private let isEditable: Bool
    private var inputingText: String? = ""
    @Binding var isEditing: Bool
    
    init(text: Binding<String>, isEditing: Binding<Bool>, dynamicHeight: Binding<CGFloat>, isEditable: Bool = true) {
        _text = text
        _isEditing = isEditing
        _dynamicHeight = dynamicHeight
        self.isEditable = isEditable
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let text = NSTextView()
        text.backgroundColor = isEditable ? .textBackgroundColor : .clear
        text.delegate = context.coordinator
        text.isRichText = false
        text.font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        text.autoresizingMask = [.width]
        text.translatesAutoresizingMaskIntoConstraints = true
        text.isVerticallyResizable = true
        text.isHorizontallyResizable = false
        text.isEditable = isEditable
        

        let scroll = NSScrollView()
        scroll.hasVerticalScroller = false
        scroll.documentView = text
        scroll.drawsBackground = false

        return scroll
    }
    
    func updateNSView(_ view: NSScrollView, context: Context) {
        let text = view.documentView as? NSTextView
        text?.string = self.text

        guard context.coordinator.selectedRanges.count > 0 else {
            return
        }

        text?.selectedRanges = context.coordinator.selectedRanges
        
        updateHeight(view: text!)
    }
    
    func updateHeight(view: NSTextView) {
        guard let container = view.textContainer else {
            return
        }
        guard let latestSize = view.layoutManager?.usedRect(for: container).size else {
            return
        }
        let height = latestSize.height
        let gap = abs(self.dynamicHeight - height)
        
        // TODO: 10 하드코딩한거 font 사이즈의 크기로 수정
        if height > 10 && gap > 10 {
            DispatchQueue.main.async {
                self.dynamicHeight = height
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: TextView
        var selectedRanges = [NSValue]()

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            selectedRanges = textView.selectedRanges
            
            parent.updateHeight(view: textView)
        }
        
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            parent.inputingText = replacementString
            return true
        }
        
        func textDidBeginEditing(_ notification: Notification) {
            parent.isEditing = true
        }
        
        func textDidEndEditing(_ notification: Notification) {
            // editing 끝나면 입력중이던 text 붙여주기
            parent.text = parent.text + (parent.inputingText ?? "")
            parent.isEditing = false
        }
    }
}

extension NSTextView{
    var numberOfLines: Int {
        guard let layoutManager = layoutManager else {
            return 0
        }
        
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange = NSRange(location: 0, length: 0)
        var numberOfLines = 0
        
        layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: numberOfGlyphs)) { _, _, _, glyphRange, _ in
            layoutManager.lineFragmentRect(forGlyphAt: glyphRange.location, effectiveRange: &lineRange)
            
            if NSMaxRange(glyphRange) >= NSMaxRange(lineRange) {
                numberOfLines += 1
            }
        }
        
        return numberOfLines
    }

}
