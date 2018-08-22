//
//  ContactCard.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 22.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct ContactCard: Decodable {
    let label: String?
    let value: String?
    let primary: Bool?
}
