//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension FollowSuggestionsService {
    private static let provider = MoyaProvider<FollowSuggestionsService>()
    
    static func request(service: FollowSuggestionsService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
