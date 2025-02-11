//
//  FontManager.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 11/2/25.
//

import Foundation
import FontBlaster

public class FontManager {
    func loadCustomFonts() {
        FontBlaster.debugEnabled = true
        
        FontBlaster.blast() { (fonts) in
          print(fonts)
        }
    }
}

