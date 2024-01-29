//
//  DecoratedCharacterStatusLabel.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit


class DecoratedCharacterStatusLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    
    func styleForStatus(_ status: StatusType) {
        self.text = "  \(status.outputName)  "
        self.textColor = ColorsPalette.whiteColor
        self.backgroundColor = status.statusColor   // BG color is the same but with less opacity.
    }
    
}
