//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct ContextEntity: Codable {
    let ancestors: [StatusEntity]
    let descenders: [StatusEntity]
}
