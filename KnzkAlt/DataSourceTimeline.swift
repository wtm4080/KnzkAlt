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
        if _loadingStatuses == nil {
            _loadingStatuses = ClientManager.shared.requestTL(
                    tlParams: tlParams,
                    firstId: _statuses.first?.status.id,
                    lastId: _statuses.last?.status.id,
                    limit: _loadingLimit
            ).then(in: .main) {
                [unowned self] result in

                switch result {
                case .success(let ss, _):
                    switch tlParams.pos {
                    case .unspecified:
                        self._statuses = Deque(ss.map(StatusCellOwner.init))

                    case .top:
                        let topStatuses = ss.map(StatusCellOwner.init)
                        if
                                let newLast = topStatuses.last,
                                let currentFirst = self._statuses.first,
                                newLast.status.id == currentFirst.status.id {
                            self._statuses.popFirst()
                        }

                        self._statuses.insert(contentsOf: topStatuses, at: 0)

                    case .bottom:
                        let bottomStatuses = ss.map(StatusCellOwner.init)
                        if
                                let newFirst = bottomStatuses.first,
                                let currentLast = self._statuses.last,
                                newFirst.status.id == currentLast.status.id {
                            self._statuses.popLast()
                        }

                        self._statuses.append(contentsOf: bottomStatuses)
                    }
                default:
                    NSLog("Loading home error: \(result)")
                }

                self._loadingStatuses = nil
                Notifications.loadedTL.post(tlParams: tlParams)
            }
        }
    }
}
