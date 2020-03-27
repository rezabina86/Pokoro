//
//  BarcodeMaker.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-27.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

func qrMaker(_ namespace: String, scale: CGAffineTransform = .identity) -> CIImage? {
    let namespaceString = "http://pokoro.app/code/\(namespace)"
    let data = namespaceString.data(using: String.Encoding.ascii)
    guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    qrFilter.setValue(data, forKey: "inputMessage")
    guard let qrImage = qrFilter.outputImage else { return nil }
    return qrImage.transformed(by: scale)
}
