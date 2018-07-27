//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    mutating func addContentType(contentType: ContentType) -> [Key: Value] {
        self["Content-Type"] = contentType.rawValue

        return self
    }
}
