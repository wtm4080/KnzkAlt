//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension FavouritesService {
    private static let provider = MoyaProvider<FavouritesService>()

    static func request(service: FavouritesService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
