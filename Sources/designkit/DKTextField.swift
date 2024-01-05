//
//  SwiftUIView.swift
//  
//
//  Created by Joschua Marz on 04.01.24.
//

import SwiftUI

public struct DKTextField: View {
    @FocusState private var defaultFocusState
    @Binding private var placeholder: String
    @Binding private var text: String
    
    init(
        placeholder: String? = nil,
        text: Binding<String>
    ) {
        self.init(placeholder: .constant(placeholder ?? ""), text: text)
    }
    
    init(
        placeholder: Binding<String>,
        text: Binding<String>
    ) {
        self._placeholder = placeholder
        self._text = text
    }
    
    private var isFocused: Bool {
        return externalFocusState?.wrappedValue ?? defaultFocusState
    }
    
    private var borderColor: Color {
        isFocused ? borderAccentColor ?? .gray : .gray
    }
    
    // MARK: - Modifiable
    private var backgroundColor: Color? = nil
    private var innerPadding: CGFloat = 8
    private var cornerRadius: CGFloat = 0
    private var borderAccentColor: Color? = nil
    private var borderWidth: CGFloat = 2
    private var externalFocusState: FocusState<Bool>.Binding?
    private var animation: Animation? = nil
    private var feedbackGenerator: HapticFeedbackGenerator? = nil
    
    // MARK: - View
    public var body: some View {
        VStack {
            TextField("textfield", text: $text, prompt: Text(placeholder))
                .padding(innerPadding)
                .tint(.blue)
                .focused(externalFocusState ?? $defaultFocusState)
                .background {
                    if let borderAccentColor {
                        ZStack {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .trim(from: 0.25, to: isFocused ? 0.75 : 0.25)
                                .stroke(lineWidth: borderWidth)
                                .flipped(.horizontal)
                                .foregroundStyle(borderAccentColor)
                                .animation(animation, value: isFocused)
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .trim(from: 0.25, to: isFocused ? 0.75 : 0.25)
                                .stroke(lineWidth: borderWidth)
                                .foregroundStyle(borderAccentColor)
                                .animation(animation, value: isFocused)
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: borderWidth)
                        .foregroundStyle(.gray)
                }
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .onTapGesture {
                    if externalFocusState != nil {
                        externalFocusState?.wrappedValue = true
                    } else {
                        defaultFocusState = true
                    }
                    feedbackGenerator?.generateFeedback()
                }
        }
    }
}

// MARK: - Configurations
extension DKTextField {
    public func defaultConfiguration() -> DKTextField {
        return self
            .edgeCornerRadius(10)
            .innerPadding(12)
            .borderAccentColor(.yellow)
            .borderWidth(2)
            .animated()
            .hapticFeedback(.selection())
    }
}

// MARK: - Modifiers
extension DKTextField {
    
    public func backgroundColor(_ color: Color?) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.backgroundColor = color
        return modifiedSelf
    }
    
    public func edgeCornerRadius(_ radius: CGFloat) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.cornerRadius = radius
        return modifiedSelf
    }
    
    public func innerPadding(_ padding: CGFloat) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.innerPadding = padding
        return modifiedSelf
    }
    
    public func borderAccentColor(_ color: Color?) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.borderAccentColor = color
        return modifiedSelf
    }
    
    public func borderWidth(_ width: CGFloat) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.borderWidth = width
        return modifiedSelf
    }
    
    public func focusState(_ focusState: FocusState<Bool>.Binding) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.externalFocusState = focusState
        return modifiedSelf
    }
    
    public func animated(_ animation: Animation? = .spring(duration: 0.4)) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.animation = animation
        return modifiedSelf
    }
    
    public func hapticFeedback(_ generatorType: HapticFeedbackType) -> DKTextField {
        var modifiedSelf = self
        modifiedSelf.feedbackGenerator = generatorType.generator
        return modifiedSelf
    }
}

#Preview {
    @State var text: String = ""
    @State var placeholder: String = "test"
    @FocusState var isFocused: Bool
    return VStack {
        DKTextField(
            placeholder: $placeholder,
            text: $text
        )
        .defaultConfiguration()
        .backgroundColor(.green)
        .borderWidth(5)
        
        Button("placeholder") {
            isFocused = false
        }
    }
    .padding()
}


extension View {
    func flipped(_ axis: Axis = .horizontal, anchor: UnitPoint = .center) -> some View {
        switch axis {
        case .horizontal:
            return scaleEffect(CGSize(width: -1, height: 1), anchor: anchor)
        case .vertical:
            return scaleEffect(CGSize(width: 1, height: -1), anchor: anchor)
        }
    }
}
