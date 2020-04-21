//
//  PKFonts.swift
//  POKORO
//
//  Created by Reza Bina on 2019-11-25.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import SwiftUI

extension UIFont {
    
    struct PKFonts {
        
        static var H1Font : UIFont {
            return UIFont.systemFont(ofSize: 22, weight: .semibold)
        }
        
        static var H2Font : UIFont {
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        static var LargeSB : UIFont {
            return UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
        
        static var LargeRegular : UIFont {
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        static var LargeLight : UIFont {
            return UIFont.systemFont(ofSize: 14, weight: .light)
        }
        
        static var MediumSB : UIFont {
            return UIFont.systemFont(ofSize: 12, weight: .semibold)
        }
        
        static var MediumRegular : UIFont {
            return UIFont.systemFont(ofSize: 12, weight: .regular)
        }
        
        static var MediumLight : UIFont {
            return UIFont.systemFont(ofSize: 12, weight: .light)
        }
        
        static var SmallSB : UIFont {
            return UIFont.systemFont(ofSize: 8, weight: .semibold)
        }
        
        static var SmallRegular : UIFont {
            return UIFont.systemFont(ofSize: 8, weight: .regular)
        }
        
    }
    
}
