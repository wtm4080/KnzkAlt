//
// Created by mopopo on 2017/12/25.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit
import AVFoundation

class MediaView: UIView {
    private let _contentView: UIView
    private var _blurView: UIVisualEffectView?
    private var _indicatorView: UIActivityIndicatorView?

    init(frame: CGRect, videoURL: URL?, isNSFW: Bool) {
        let contentView: UIView
        if let vURL = videoURL {
            contentView = MediaVideoView(frame: frame, url: vURL)
        }
        else {
            let imageView = UIImageView(image: nil)

            contentView = imageView

            let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.hidesWhenStopped = true
            indicatorView.startAnimating()
            _indicatorView = indicatorView

            contentView.addSubview(indicatorView)
            contentView.bounds.size = CGSize(width: frame.width, height: indicatorView.bounds.height)

            NSLayoutConstraint.activate([
                indicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                indicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                indicatorView.widthAnchor.constraint(equalToConstant: indicatorView.bounds.size.width),
                indicatorView.heightAnchor.constraint(equalToConstant: indicatorView.bounds.size.height)
            ])
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.contentMode = .scaleAspectFill
        _contentView = contentView

        super.init(frame: frame)

        setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])

        addSubview(contentView)

        let fitConstraint = {
            (subView: UIView, superView: UIView) -> () in

            NSLayoutConstraint.activate([
                subView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                subView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                subView.topAnchor.constraint(equalTo: superView.topAnchor),
                subView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
            ])
        }

        fitConstraint(contentView, self)

        if isNSFW {
            let effect = UIBlurEffect(style: .dark)

            let blurView = UIVisualEffectView(effect: effect)
            blurView.frame = frame
            blurView.translatesAutoresizingMaskIntoConstraints = false
            _blurView = blurView

            addSubview(blurView)
            fitConstraint(blurView, self)

            let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: effect))
            vibrancyView.frame = blurView.bounds
            vibrancyView.translatesAutoresizingMaskIntoConstraints = false

            blurView.contentView.addSubview(vibrancyView)
            fitConstraint(vibrancyView, blurView.contentView)

            let nsfwLabel = UILabel(frame: vibrancyView.bounds)
            nsfwLabel.translatesAutoresizingMaskIntoConstraints = false
            nsfwLabel.text = "＿人人人人人人人＿\n" + "＞　N　S　F　W　＜\n" + "￣Y^Y^Y^Y^Y^Y￣"
            nsfwLabel.textAlignment = .center
            nsfwLabel.numberOfLines = 0
            nsfwLabel.font = UIFont.boldSystemFont(ofSize: 24)

            vibrancyView.contentView.addSubview(nsfwLabel)
            fitConstraint(nsfwLabel, vibrancyView.contentView)

            let showButton = UIButton(type: .infoLight)
            showButton.tintColor = UIColor(white: 0.8, alpha: 0.8)
            showButton.translatesAutoresizingMaskIntoConstraints = false
            showButton.addTarget(
                    self,
                    action: #selector(type(of: self)._showAction(sender:)),
                    for: .touchUpInside
            )

            addSubview(showButton)

            NSLayoutConstraint.activate([
                showButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                showButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                showButton.widthAnchor.constraint(equalToConstant: showButton.bounds.size.width),
                showButton.heightAnchor.constraint(equalToConstant: showButton.bounds.size.height)
            ])
        }

        clipsToBounds = true
        layer.cornerRadius = StatusCellOwner.imageCornerRadius
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("MediaView does not support init?(coder:).")
    }

    override var intrinsicContentSize: CGSize {
        return _contentView.intrinsicContentSize
    }

    func setImage(image: UIImage) {
        _contentView.bounds.size = image.size

        let imageView = _contentView as! UIImageView
        imageView.image = image

        invalidateIntrinsicContentSize()

        _indicatorView!.stopAnimating()

        Notifications.loadedAttachment.post()
    }

    @objc private func _showAction(sender: Any) {
        let blurView = _blurView!
        let isHiddenPrev = blurView.isHidden

        let fromAlpha = CGFloat(blurView.isHidden ? 0.0 : 1.0)
        let toAlpha = CGFloat(blurView.isHidden ? 1.0 : 0.0)

        blurView.alpha = fromAlpha
        if isHiddenPrev {
            blurView.isHidden = false
        }

        UIView.animate(
                withDuration: 0.15,
                animations: {
                    blurView.alpha = toAlpha
                },
                completion: {
                    (finished: Bool) in

                    if !isHiddenPrev {
                        blurView.isHidden = true
                    }

                    blurView.alpha = toAlpha
                }
        )
    }
}

fileprivate class MediaVideoView: UIView {
    private var _playerLooper: AVPlayerLooper?
    private let _player = AVQueuePlayer()

    init(frame: CGRect, url: URL) {
        super.init(frame: frame)

        _player.isMuted = true

        playerLayer.player = _player
        playerLayer.videoGravity = .resizeAspectFill

        let playerItem = AVPlayerItem(url: url)

        _playerLooper = AVPlayerLooper(player: _player, templateItem: playerItem)

        _player.addObserver(
                self,
                forKeyPath: #keyPath(AVQueuePlayer.status),
                options: .new,
                context: nil
        )
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    deinit {
        _player.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.status))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("MediaVideoView does not support init?(coder:).")
    }

    fileprivate override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    fileprivate override var intrinsicContentSize: CGSize {
        return _playerLooper?.loopingPlayerItems.first?.asset.tracks.first?.naturalSize ?? CGSize.zero
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        let callSuper = {
            super.observeValue(
                    forKeyPath: keyPath,
                    of: object,
                    change: change,
                    context: context
            )
        }

        if let object = object {
            let keyPath = keyPath ?? ""

            if object is AVQueuePlayer && keyPath == #keyPath(AVQueuePlayer.status) {
                if _player.status == .readyToPlay {
                    _player.play()

                    invalidateIntrinsicContentSize()
                }
            }
            else {
                callSuper()
            }
        }
        else {
            callSuper()
        }
    }
}
