//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// The most important part of error response is the HTTP status code.
/// Standard semantics are followed.
/// The body of an error is a JSON object with this structure.
struct ErrorEntity {
    /// A textual description of the error
    let error: String
}
