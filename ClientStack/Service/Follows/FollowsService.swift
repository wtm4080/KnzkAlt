//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum FollowsService {
    /// Following a remote user
    /// Returns the local representation of the followed account, as an Account entity.
    case followRemote(param: ServiceParam, remoteUserURI: String)
}
