//
//  SocketEndPointType.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation
import SocketIO

protocol SocketEventType {
    var event: String { get }
}
