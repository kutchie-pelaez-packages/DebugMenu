import CoreUI
import UIKit

enum DebugMenuConstants {
    enum FileViewer {
        static let font = System.Fonts.Mono.regular(10)
        static let color = System.Colors.Label.primary

        enum Lines {
            static let leftInset: Double = 6
            static let rightInset: Double = 6
        }
    }

    enum LogsViewer {
        enum Colors {
            static let warning = UIColor(hex: 0xFFF3CB59)
            static let error = UIColor(hex: 0xF9D5D256)
        }
    }
}
