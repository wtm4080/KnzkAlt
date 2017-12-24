//
// Created by mopopo on 2017/11/15.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit
import Hydra
import MastodonKit
import SwiftGifOrigin

class IconStorage {
    static let shared = IconStorage()
    private init() {}

    private var _loadingsIcons: [URL: Promise<Result<Data>>] = [:]
    private var _icons: [URL: UIImage] = [:]

    func loadIcon(url: URL, for s: StatusCellOwner) {
        _loadIcon(url: url) {
            s.iconImage = $0
        }
    }

    func loadBtByIcon(url: URL, for s: StatusCellOwner) {
        _loadIcon(url: url) {
            s.btByIconImage = $0
        }
    }

    private func _loadIcon(url: URL, for statusCellSetter: @escaping (UIImage?) -> ()) {
        let updateIcon = {
            [unowned self] (result: Result<Data>) in

            switch result {
            case .success(let data, _):
                let image = UIImage.gif(data: data)
                self._icons[url] = image
                statusCellSetter(image)
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
