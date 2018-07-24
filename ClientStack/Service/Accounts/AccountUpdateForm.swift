//
// Created by mopopo on 2018/07/24.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

struct AccountUpdateForm {
    /// The name to display in the user's profile
    let displayName: String?

    /// A new biography for the user
    let note: String?

    /// An avatar for the user (encoded using `multipart/form-data`)
    let avatarImage: Data?

    /// A header image for the user (encoded using `multipart/form-data`)
    let headerImage: Data?

    /// Manually approve followers?
    let isLocked: Bool?

    /// (2.4 or later) Label and value of profile metadata fields
    let profileMetadata: [(label: String, value: String)]?

    func toFormData() -> [MultipartFormData] {
        var data = [MultipartFormData]()

        let addData = {
            (name: String, d: Data?) in

            if let d = d {
                data.append(MultipartFormData(provider: .data(d), name: name))
            }
        }

        let addString = {
            (name: String, s: String?) in

            if let s = s {
                addData(name, s.data(using: .utf8))
            }
        }

        addString("display_name", displayName)
        addString("note", note)
        addData("avatar", avatarImage)
        addData("header", headerImage)

        if let isLocked = isLocked {
            let value = isLocked ? "on" : "off"

            data.append(MultipartFormData(provider: .data(value.data(using: .utf8)!), name: "locked"))
        }

        if let pD = profileMetadata {
            for item in pD.prefix(4).enumerated() {
                let prefix = "fields_attributes[\(item.offset)]"

                addString(prefix + "[name]", item.element.label)
                addString(prefix + "[value]", item.element.value)
            }
        }

        return data
    }
}
