//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension Response {
    private func isSuccessResponse() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }

    func mapEntity<T: Decodable>() -> Result<T, ServiceError> {
        guard isSuccessResponse() else {
            return .failure(.response(response: self))
        }

        do {
            return try .success(self.map(T.self))
        } catch let e {
            return .failure(.parseResponse(e: e))
        }
    }

    func mapAccount() -> Result<AccountEntityCompound, ServiceError> {
        return mapEntity()
    }

    func mapAccounts() -> Result<[AccountEntityCompound], ServiceError> {
        return mapEntity()
    }

    func mapStatuses() -> Result<[StatusEntityCompound], ServiceError> {
        return mapEntity()
    }

    func mapRelationship() -> Result<RelationshipEntity, ServiceError> {
        return mapEntity()
    }

    func mapRelationships() -> Result<[RelationshipEntity], ServiceError> {
        return mapEntity()
    }

    func mapStrings() -> Result<[String], ServiceError> {
        return mapEntity()
    }

    func mapEmpty() -> Result<(), ServiceError> {
        guard isSuccessResponse() else {
            return .failure(.response(response: self))
        }

        return .success(())
    }

    func mapFilters() -> Result<[FilterEntity], ServiceError> {
        return mapEntity()
    }

    func mapFilter() -> Result<FilterEntity, ServiceError> {
        return mapEntity()
    }
}
