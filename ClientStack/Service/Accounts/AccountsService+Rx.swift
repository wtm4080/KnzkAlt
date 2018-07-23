//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension AccountsService {
    private static let provider = MoyaProvider<AccountsService>()

    func request(service: AccountsService) -> Single<Response> {
        return AccountsService.provider.rx.request(service)
    }
}

extension Response {
    func mapAccount() -> Result<AccountEntityCompound, ServiceError> {
        guard statusCode >= 200 && statusCode < 300 else {
            return .failure(.response(response: self))
        }

        do {
            return try .success(self.map(AccountEntityCompound.self))
        } catch let e {
            return .failure(.parseResponse(e: e))
        }
    }
}
