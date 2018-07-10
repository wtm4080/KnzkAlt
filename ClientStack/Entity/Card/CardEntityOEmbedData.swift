//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// OEmbed data for card entity
/// https://oembed.com
struct CardEntityOEmbedData {
    /// The name of the author/owner of the resource
    let authorName: String?

    /// A URL for the author/owner of the resource
    let authorURL: URL?

    /// The name of the resource provider
    let providerName: String?

    /// The URL of the resource provider
    let providerURL: URL?

    /// # For the `video` type:
    /// The HTML required to embed a video player.
    /// The HTML should have no padding or margins.
    /// Consumers may wish to load the HTML in an off-domain iframe to avoid XSS vulnerabilities.
    ///
    /// # For the rich type:
    /// The HTML required to display the resource.
    /// The HTML should have no padding or margins.
    /// Consumers may wish to load the HTML in an off-domain iframe to avoid XSS vulnerabilities.
    /// The markup should be valid XHTML 1.0 Basic.
    let html: String?

    /// # For the `photo` type:
    /// The width in pixels of the image specified in the URL parameter.
    ///
    /// # For the `video` and `rich` type:
    /// The width in pixels required to display the HTML.
    let width: UInt?

    /// # For the photo type:
    /// The height in pixels of the image specified in the URL parameter.
    ///
    /// # For the `video` and `rich` type:
    /// The height in pixels required to display the HTML.
    let height: UInt?
}
