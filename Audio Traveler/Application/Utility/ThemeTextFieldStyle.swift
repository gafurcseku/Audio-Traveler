//
//  ThemeTextFieldStyle.swift
//  DhamakaShopping
//
//  Created by Invariant on 24/2/21.
//

import Foundation
import FloatingLabelTextFieldSwiftUI


struct ThemeTextFieldStyle: FloatingLabelTextFieldStyle {
    func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        content
            .spaceBetweenTitleText(15) // Sets the space between title and text.
            .textAlignment(.leading) // Sets the alignment for text.
            .lineHeight(1) // Sets the line height.
            .selectedLineHeight(1.5) // Sets the selected line height.
            .lineColor(.gray) // Sets the line color.
            .selectedLineColor(.white) // Sets the selected line color.
            .titleColor(.white) // Sets the title color.
            .selectedTitleColor(.white) // Sets the selected title color.
            .titleFont(.system(size: 14)) // Sets the title font.
            .textColor(.white) // Sets the text color.
            .selectedTextColor(.white) // Sets the selected text color.
            .textFont(.system(size: 14)) // Sets the text font.
            .placeholderColor(.white) // Sets the placeholder color.
            .placeholderFont(.system(size: 14)) // Sets the placeholder font.
            .errorColor(.red) /// Sets the error color.
            .addDisableEditingAction([.paste]) /// Disable text field editing action. Like cut, copy, past, all etc.
    }
}
