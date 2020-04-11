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
            return UIFont(name: "Metropolis-Semibold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .semibold)
        }
        
        static var H2Font : UIFont {
            return UIFont(name: "Metropolis-Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        static var LargeSB : UIFont {
            return UIFont(name: "Metropolis-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
        
        static var LargeRegular : UIFont {
            return UIFont(name: "Metropolis-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        static var LargeLight : UIFont {
            return UIFont(name: "Metropolis-Light", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
        }
        
        static var MediumSB : UIFont {
            return UIFont(name: "Metropolis-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .semibold)
        }
        
        static var MediumRegular : UIFont {
            return UIFont(name: "Metropolis-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        }
        
        static var MediumLight : UIFont {
            return UIFont(name: "Metropolis-Light", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .light)
        }
        
        static var SmallSB : UIFont {
            return UIFont(name: "Metropolis-Semibold", size: 8) ?? UIFont.systemFont(ofSize: 8, weight: .semibold)
        }
        
        static var SmallRegular : UIFont {
            return UIFont(name: "Metropolis-Regular", size: 8) ?? UIFont.systemFont(ofSize: 8, weight: .regular)
        }
        
    }
    
}
