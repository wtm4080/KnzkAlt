//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension FiltersService {
    private static let provider = MoyaProvider<FiltersService>()

    static func request(service: FiltersService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
