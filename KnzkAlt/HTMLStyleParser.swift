//
// Created by mopopo on 2017/12/03.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

struct HTMLStyleParser {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    lazy var keyValues: [String: [String]] = {
        let kvs = rawValue.split(separator: ";")

        let kvPairs: [(String, [String])] = kvs.map {

            let pair = $0.split(separator: ":")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            let values = (pair.dropFirst().first ?? "")
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "'\"")) }

            return (
                    String(pair.first ?? ""),
                    values
            )
        }.filter { !$0.0.isEmpty }

        return [String: [String]](uniqueKeysWithValues: kvPairs)
    }()

    lazy var foregroundColor: UIColor? = {
        return UIColor.black
    }()
}
