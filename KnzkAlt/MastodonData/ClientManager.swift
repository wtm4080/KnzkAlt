//
// Created by mopopo on 2017/11/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation
import MastodonKit
import Hydra

enum StatusAction {
    case reblog
    case unreblog
    case favourite
    case unfavourite
}

class ClientManager {
    static let shared = ClientManager()
    private init() {}

    private var _standard: Client {
        return Client(
                baseURL: "https://\(Login.host)",
                accessToken: Keychain.shared.accessToken)
    }

    // for CDN configuration
    private var _media: Client {
        return _standard
    }

    func requestTL(
            tlParams: TLParams,
            firstId: Int?,
            lastId: Int?,
            limit: Int) -> Promise<Result<[Status]>> {

        let requestRange = _tlParamsToRequestRange(
                tlParams,
                firstId: firstId,
                lastId: lastId,
                limit: limit)

        let request: Request<[Status]>
        switch tlParams.kind {
            case .home:
                request = Timelines.home(range: requestRange)
            case .local:
                request = Timelines.public(local: true, range: requestRange)
            case .federation:
                request = Timelines.public(local: false, range: requestRange)
        }

        return Promise<Result<[Status]>>(in: .background) {
            [unowned self] resolve, _, _ in

            self._standard.run(request) {
                resolve($0)
            }
        }
    }

    func performStatusAction(statusId: Int, action: StatusAction) -> Promise<Result<Status>> {
        let request: Request<Status>
        switch action {
            case .reblog:
                request = Statuses.reblog(id: statusId)
            case .unreblog:
                request = Statuses.unreblog(id: statusId)
            case .favourite:
                request = Statuses.favourite(id: statusId)
            case .unfavourite:
                request = Statuses.unfavourite(id: statusId)
        }

        return Promise<Result<Status>>(in: .background) {
            [unowned self] resolve, _, _ in

            self._standard.run(request) {
                resolve($0)
            }
        }
    }

    func logout() {
        var kc = Keychain.shared
        kc.accessToken = nil

        AppNotification.shared.post.logoutPerformed()
    }

    private func _tlParamsToRequestRange(
            _ tlParams: TLParams,
            firstId: Int?,
            lastId: Int?,
            limit: Int) -> RequestRange {

        switch tlParams.pos {
        case .top:
            if let id = firstId {
                return .since(id: id, limit: limit)
            }
            else {
                return .default
            }
        case .bottom:
            if let id = lastId {
                return .max(id: id, limit: limit)
            }
            else {
                return .default
            }
        case .unspecified:
            return .default
        }
    }
}
