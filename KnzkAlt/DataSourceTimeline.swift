//
// Created by mopopo on 2017/11/15.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation
import MastodonKit
import Hydra
import Deque

class DataSourceTimeline {
    private let _loadingLimit = 20

    private var _loadingStatuses: Promise<Result<[Status]>>?
    private var _statuses: Deque<StatusCellOwner> = Deque()

    var statuses: Deque<StatusCellOwner> {
        return _statuses
    }

    func loadStatuses(tlParams: TLParams) {
        let requestRange = _tlParamsToRequestRange(tlParams)

        if _loadingStatuses == nil {
            _loadingStatuses = ClientManager.shared.homeTL(requestRange: requestRange).then(in: .main) {
                [unowned self] result in

                switch result {
                case .success(let ss, _):
                    switch requestRange {
                    case .default, .limit(_):
                        self._statuses = Deque(ss.map(StatusCellOwner.init))

                    case .since(_, _):
                        let topStatuses = ss.map(StatusCellOwner.init)
                        if
                                let newLast = topStatuses.last,
                                let currentFirst = self._statuses.first,
                                newLast.status.id == currentFirst.status.id {
                            self._statuses.popFirst()
                        }

                        self._statuses.insert(contentsOf: topStatuses, at: 0)

                    case .max(_, _):
                        let bottomStatuses = ss.map(StatusCellOwner.init)
                        if
                                let newFirst = bottomStatuses.first,
                                let currentLast = self._statuses.last,
                                newFirst.status.id == currentLast.status.id {
                            self._statuses.popLast()
                        }

                        self._statuses.append(contentsOf: bottomStatuses)
                    }

                    for s in self._statuses {
                        if s.iconImage == nil {
                            IconStorage.shared.loadIcon(
                                    url: URL(string: s.status.account.avatar)!,
                                    for: s)
                        }
                    }
                default:
                    NSLog("Loading home error: \(result)")
                }

                self._loadingStatuses = nil
                Notifications.loadedTL.post(tlParams: tlParams)
            }
        }
    }

    private func _tlParamsToRequestRange(_ tlParams: TLParams) -> RequestRange {
        switch tlParams.pos {
        case .top:
            if let id = _statuses.first?.status.id {
                return .since(id: id, limit: _loadingLimit)
            }
            else {
                return .default
            }
        case .bottom:
            if let id = _statuses.last?.status.id {
                return .max(id: id, limit: _loadingLimit)
            }
            else {
                return .default
            }
        case .unspecified:
            return .default
        }
    }
}
