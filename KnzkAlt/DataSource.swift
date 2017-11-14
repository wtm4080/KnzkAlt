//
// Created by mopopo on 2017/11/13.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation
import MastodonKit
import Hydra
import Deque

class DataSource: NSObject, UITableViewDataSource{
    static let shared = DataSource()

    func tableView(_ _: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _statuses[indexPath.row].view
    }

    func tableView(_ _: UITableView, numberOfRowsInSection _: Int) -> Int {
        return _statuses.count
    }

    private override init() {
        super.init()

        Notifications.requestHomeTL.register(
                observer: self,
                selector: #selector(type(of: self)._observeRequestHomeTL(n:)))
        Notifications.requestHomeTLTop.register(
                observer: self,
                selector: #selector(type(of: self)._observeRequestHomeTLTop(n:)))
        Notifications.requestHomeTLBottom.register(
                observer: self,
                selector: #selector(type(of: self)._observeRequestHomeTLBottom(n:)))
    }

    deinit {
        Notifications.unregisterAll(observer: self)
    }

    @objc private func _observeRequestHomeTL(n: Any) {
        _loadStatuses(requestRange: .default)
    }

    private let _loadingLimit = 20

    @objc private func _observeRequestHomeTLTop(n: Any) {
        if let id = _statuses.first?.status.id {
            _loadStatuses(requestRange: .since(id: id, limit: _loadingLimit))
        }
        else {
            _loadStatuses(requestRange: .default)
        }
    }

    @objc private func _observeRequestHomeTLBottom(n: Any) {
        if let id = _statuses.last?.status.id {
            _loadStatuses(requestRange: .max(id: id, limit: _loadingLimit))
        }
        else {
            _loadStatuses(requestRange: .default)
        }
    }

    private var _loadingStatuses: Promise<Result<[Status]>>?
    private var _statuses: Deque<StatusCellOwner> = Deque()

    private var _loadingsIcons: [URL: Promise<Result<Data>>] = [:]
    private var _icons: [URL: UIImage] = [:]

    private func _loadStatuses(requestRange: RequestRange) {
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

                    for (i, s) in self._statuses.enumerated() {
                        if s.iconImage == nil {
                            self._loadIcon(url: URL(string: self._statuses[i].status.account.avatar)!, at: i)
                        }
                    }
                default:
                    NSLog("Loading home error: \(result)")
                }

                self._loadingStatuses = nil
                Notifications.loadedHomeTL.post()
            }
        }
    }

    private func _loadIcon(url: URL, at: Int) {
        let updateIcon = {
            [unowned self] (result: Result<Data>) in

            switch result {
            case .success(let data, _):
                let image = UIImage(data: data)
                self._icons[url] = image

                if at < self._statuses.count {
                    let cell = self._statuses[at]
                    cell.iconImage = image

                    Notifications.loadedHomeTL.post()
                }
            default:
                NSLog("Loading image error: \(result)")
            }
        }

        if let currentLoading = _loadingsIcons[url] {
            currentLoading.then(in: .main) {
                updateIcon($0)
            }
        }
        else {
            _loadingsIcons[url] = Promise<Result<Data>>(in: .background) {
                resolved, _, _ in

                URLSession.shared.dataTask(with: url) {
                    data, _, error in

                    if let data = data {
                        resolved(.success(data, nil))
                    }
                    else {
                        resolved(.failure(error!))
                    }
                }.resume()
            }.then(in: .main) {
                updateIcon($0)
            }
        }
    }
}
