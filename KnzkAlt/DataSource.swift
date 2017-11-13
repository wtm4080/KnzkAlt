//
// Created by mopopo on 2017/11/13.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation
import MastodonKit
import Hydra

class DataSource: NSObject, UITableViewDataSource{
    static let shared = DataSource()

    func tableView(_ _: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _statuses[indexPath.row].cell
    }

    func tableView(_ _: UITableView, numberOfRowsInSection _: Int) -> Int {
        return _statuses.count
    }

    private override init() {
        super.init()

        Notifications.requestHomeTL.register(
                observer: self,
                selector: #selector(type(of: self)._observeRequestHomeTL(n:)))
    }

    deinit {
        Notifications.unregisterAll(observer: self)
    }

    @objc private func _observeRequestHomeTL(n: Any) {
        _loadStatuses()
    }

    private var _loadingStatuses: Promise<Result<[Status]>>?
    private var _statuses: [StatusCellOwner] = []

    private var _loadingsIcons: [URL: Promise<Result<Data>>] = [:]
    private var _icons: [URL: UIImage] = [:]

    private func _loadStatuses() {
        if _loadingStatuses == nil {
            _loadingStatuses = ClientManager.shared.homeTL().then(in: .main) {
                [unowned self] result in

                switch result {
                case .success(let ss, _):
                    self._statuses = ss.map(StatusCellOwner.init)

                    for (i, s) in self._statuses.enumerated() {
                        if s.iconImage == nil {
                            self._loadIcon(url: URL(string: ss[i].account.avatar)!, at: i)
                        }
                    }

                    Notifications.loadedHomeTL.post()
                default:
                    NSLog("Loading home error: \(result)")
                }

                self._loadingStatuses = nil
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
