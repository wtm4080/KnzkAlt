//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct MentionEntity: Codable {
    let url: URL
    let username: String
    let acct: String
    let id: String
    
    var usernameWithDomain: String {
        return acct
    }
}
