//
//  NameSpacesBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-27.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation
import UIKit

struct NameSpacesBusinessModel {
    
    struct Fetch {
        
        struct Request {
            let page: Int
            
            var parameters: Parameters {
                return ["page" : page]
            }
        }
        
        struct Response: Decodable {
            let count: Int
            let next_page_number: Int?
            let previous_page_number: Int?
            let results: [Namespace]
        }
        
        struct ViewModel {
            
            let results: [NameSpaceQR]
            
            init(response: Response) {
                self.results = response.results.map({ NameSpaceQR(namespace: $0) })
            }

        }
        
    }
    
    struct Namespace: Decodable {
        let id: String
        let name: String
        let creator_id: String
    }
    
    struct NameSpaceQR {
        let id: String
        let name: String
        let creator_id: String
        let qr: CIImage?
        
        init(namespace: Namespace) {
            self.id = namespace.id
            self.name = namespace.name
            self.creator_id = namespace.creator_id
            self.qr = qrMaker(namespace.id)
        }
        
        func makeQR() -> CIImage? {
            return qrMaker(id, scale: CGAffineTransform(scaleX: 5.94, y: 5.94))
        }
    }
    
}
