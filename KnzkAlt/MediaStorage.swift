//
// Created by mopopo on 2017/11/15.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit
import Hydra
import MastodonKit
import SwiftGifOrigin

class MediaStorage {
    static let shared = MediaStorage()
    private init() {}

    private var _loadingsMedia: [URL: Promise<Result<Data>>] = [:]
    private var _media: [URL: UIImage] = [:]

    func loadIcon(url: URL, for s: StatusCellOwner) {
        _loadMedia(url: url) {
            s.iconImage = $0
        }
    }

    func loadBtByIcon(url: URL, for s: StatusCellOwner) {
        _loadMedia(url: url) {
            s.btByIconImage = $0
        }
    }

    func loadAttachment(url: URL, for mediaView: MediaView) {
        _loadMedia(url: url) {
            if let img = $0 {
                mediaView.setImage(image: img)
            }
        }
    }

    private func _loadMedia(url: URL, for statusCellSetter: @escaping (UIImage?) -> ()) {
        let updateMedia = {
            [unowned self] (result: Result<Data>) in

            switch result {
            case .success(let data, _):
                let image = UIImage.gif(data: data)
                self._media[url] = image
                statusCellSetter(image)
            default:
                NSLog("Loading image error: \(result)")
            }
        }

        if let currentLoading = _loadingsMedia[url] {
            currentLoading.then(in: .main) {
                updateMedia($0)
            }
        }
        else {
            _loadingsMedia[url] = Promise<Result<Data>>(in: .background) {
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
                updateMedia($0)
            }
        }
    }
}
