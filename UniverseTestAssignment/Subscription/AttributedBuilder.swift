//
//  AttributedTextBuilder.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 17.04.2025.
//

import UIKit

final class AttributedTextBuilder {
    
    // MARK: - Private Properties
    private let attributed = NSMutableAttributedString()
    private let baseAttributes: [NSAttributedString.Key: Any]
    private let paragraphStyle = NSMutableParagraphStyle()
    
    // MARK: - Init
    init(baseFont: UIFont, baseColor: UIColor) {
        self.baseAttributes = [
            .font: baseFont,
            .foregroundColor: baseColor
        ]
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = baseFont.pointSize + 2
        paragraphStyle.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Paragraph Style Modifiers
    
    @discardableResult
    func setParagraphAlignment(_ alignment: NSTextAlignment) -> AttributedTextBuilder {
        self.paragraphStyle.alignment = alignment
        return self
    }
    
    @discardableResult
    func setLineHeight(_ height: CGFloat) -> AttributedTextBuilder {
        self.paragraphStyle.minimumLineHeight = height
        return self
    }
    
    @discardableResult
    func setLineSpacing(_ spacing: CGFloat) -> AttributedTextBuilder {
        self.paragraphStyle.lineSpacing = spacing
        return self
    }
    
    @discardableResult
    func setLineBreakMode(_ mode: NSLineBreakMode) -> AttributedTextBuilder {
        self.paragraphStyle.lineBreakMode = mode
        return self
    }
    
    // MARK: - Content Building
    
    @discardableResult
    func append(_ text: String, style: [NSAttributedString.Key: Any]? = nil) -> AttributedTextBuilder {
        var finalAttributes = baseAttributes
        style?.forEach { finalAttributes[$0] = $1 }
        
        let chunk = NSAttributedString(string: text, attributes: finalAttributes)
        attributed.append(chunk)
        return self
    }
    
    @discardableResult
    func bold(_ text: String, color: UIColor? = nil) -> AttributedTextBuilder {
        let fontSize = (baseAttributes[.font] as? UIFont)?.pointSize ?? 16
        var boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize)
        ]
        if let color = color {
            boldAttributes[.foregroundColor] = color
        }
        return append(text, style: boldAttributes)
    }
    
    @discardableResult
    func makeLink(_ text: String, url: URL) -> AttributedTextBuilder {
        return append(text, style: [.link: url])
    }
    
    @discardableResult
    func newLine() -> AttributedTextBuilder {
        return append("\n")
    }
    
    // MARK: - Build Output
    
    func build() -> NSAttributedString {
        let range = NSRange(location: 0, length: attributed.length)
        attributed.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return attributed
    }
}
