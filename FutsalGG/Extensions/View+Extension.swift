//
//  View+Extension.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/21/25.
//

import SwiftUI

// MARK: - Font Style
enum PretendardStyle {
    case L_15_100
    case L_17_200
    case L_20_300
    case R_15_100
    case R_17_200
    case R_20_300
    case R_24_400
    case B_15_100
    case B_17_200
    case B_20_300
    case B_24_400
    case B_40_500
    
    var fontName: String {
        switch self {
        case .L_15_100, .L_17_200, .L_20_300:
            return "Pretendard-Light"
        case .R_15_100, .R_17_200, .R_20_300, .R_24_400:
            return "Pretendard-Regular"
        case .B_15_100, .B_17_200, .B_20_300, .B_24_400, .B_40_500:
            return "Pretendard-SemiBold"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .L_15_100, .R_15_100, .B_15_100:
            return 15
        case .R_17_200, .B_17_200, .L_17_200:
            return 17
        case .R_20_300, .B_20_300, .L_20_300:
            return 20
        case .R_24_400, .B_24_400:
            return 24
        case .B_40_500:
            return 40
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .L_15_100, .L_17_200, .L_20_300:
            return 1.4
        default:
            return 1.5
        }
    }
    
    var letterSpacing: CGFloat {
        switch self {
        default:
            return -0.8
        }
    }
}

// MARK: - Font Extension
extension Font {
    static func pretendard(_ style: PretendardStyle) -> Font {
        .custom(style.fontName, size: style.size)
    }
}

// MARK: - View Extension
extension View {
    func pretendardStyle(_ style: PretendardStyle) -> some View {
        Group {
            self
                .font(.pretendard(style))
                .lineSpacing(style.lineHeight - style.size)
                .tracking(style.letterSpacing)
        }
    }
    
    func whiteShadowSoft(radius: CGFloat) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: radius)
                .fill(.black)
                .shadow(color: Color.init("FBFBFB").opacity(0.05), radius: 2, x: 0, y: 1)
                .shadow(color: Color.init("FBFBFB").opacity(0.25), radius: 8, x: 0, y: 2)
        )
    }
    
    func blackShadowHard(radius: CGFloat) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: radius)
                .fill(.white)
                .shadow(color: .black.opacity(0.10), radius: 4, x: 0, y: 2)
                .shadow(color: Color.init("222222").opacity(0.10), radius: 8, x: 0, y: 4)
        )
    }
    
    func blackShadowSoft(radius: CGFloat) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: radius)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .shadow(color: Color.init("222222").opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
}
