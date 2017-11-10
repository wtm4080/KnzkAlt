//
//  FirstViewController.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit
import MastodonKit
import Hydra

class HomeVC: UITableViewController, UITableViewDataSourcePrefetching {
    private var _loadingStatuses: Promise<Result<[Status]>>?
    private var _statuses: [StatusCellOwner] = []

    private var _loadingsIcons: [URL: Promise<Result<Data>>] = [:]
    private var _icons: [URL: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.prefetchDataSource = self

        _loadStatuses()
    }

    override func tableView(_ _: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _statuses[indexPath.row].cell
    }

    override func tableView(_ _: UITableView, numberOfRowsInSection _: Int) -> Int {
        return _statuses.count
    }

    func tableView(_ _: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    }

    func tableView(_ _: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }

    private static func _statusToCell(s: Status) -> StatusCellOwner {
        let co = StatusCellOwner()
        co.displayNameLabel.text = s.account.displayName
        co.userIdLabel.text = s.account.acct

        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .medium
        co.tootDateLabel.text = f.string(from: s.createdAt)

        co.contentLabel.text = s.content

        return co
    }

    private func _loadStatuses() {
        if _loadingStatuses == nil {
            _loadingStatuses = ClientManager.shared.homeTL().then(in: .main) {
                [unowned self] result in

                switch result {
                case .success(let ss, _):
                    self._statuses = ss.map(HomeVC._statusToCell)

                    for (i, s) in self._statuses.enumerated() {
                        if s.iconImageView.image == nil {
                            self._loadIcon(url: URL(string: ss[i].account.avatar)!, at: i)
                        }
                    }

                    self.tableView.reloadData()
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
                    cell.iconImageView.image = image

                    DispatchQueue.main.async {
                        [unowned self] in

                        self.tableView.reloadData()
                    }
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
