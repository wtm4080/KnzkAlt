# KnzkAlt

## Overview

[Knzk.me Advent Calendar 20th (in Japanese)](https://knzk.me/@mopopo/99201565685082964)

## Requirement

* iOS 11.2 or above.
* Xcode 9.2 or above.

## Prepare dependencies

`$ pod install`

## Licence

[KnzkApp License (Restricted BSD License)](https://github.com/wtm4080/KnzkAlt/blob/develop/LICENSE)

## To-Do list

### For first release

* Refactor and add unit tests
* HockeyApp
* Fastlane
* CI

* Timeline
  * Read more cell
  * Attachment detail view navigation
  * Bottom cell with activity indicator for auto past status loading
  * Connect WebSocket when scroll offset is nearly zero
  * Tap link to open Safari VC
  * Tap @ mention to open AccountDetailVC
  * Tap # tag to open Hashtag Timeline
  * Status created date refine
  * Coloring statuses by visibility
  * BT and Fav counts
  * Auto collapse content
  * Empty timeline cell
  * Convert BBCode to HTML

* Status detail view
  * User icon
  * Display name
  * Account ID
  * Content
  * Attachments
  * External link details by OpenGraphProtocol
  * Created detailed date
  * Posting app name
  * BT and Fav counts
  * Visibility status
  * Action buttons
    * Rep, BT, Fav
    * Menu Action
      * Embed, reply, mute, block, report to admin
  * Update BT and Fav counts when showing status detail
    * Status on timeline should also be updated
  * Auto update by WebSocket or polling

* Account detail view
  * Background image
  * Icon
  * Follow status
  * Follow button
  * Display name
  * Account ID
  * Content by BBCodeView
  * Two-Column table for itemized profile
  * Action menu button
    * Reply
    * Media
    * Mute BT
    * Mute
    * Block
    * Report to admin
  * Post count
  * Follow count
  * Follower count
  * Fixed toots
  * Post statuses (like Timeline)
  * Auto update by WebSocket or polling

* Attachment detail view
  * for image
  * for video
  * consider NSFW status

* Notification view
  * Category switch: All, Mention, Follow, BT, Fav
  * Notification sammary label
  * User icon
  * Other account icon
  * User display name
  * User account ID
  * User status visibility
  * Content sammary
  * Status detail view navigation
  * Account detail view navigation
  * Auto update by WebSocket or polling
  * Clear button
  * Sound effect

* Toot view
  * Toot content text view
  * Emoji input view
  * Toolbar for insert BBCode
  * Visibility
  * CW
  * Post local only
  * Attachment button
    * Resize image
  * Input validation
  * Characters count
  * Toot button

* User profile view
  * Like account detail view
  * Editing
    * Display name
    * Profile text
    * Icon
    * Background image (header)
    * Toggle private account
    * Account migration
    * Save button
  * Auto update by WebSocket or polling

* Media cache to storage
  * Expiration handling

* Toot cache to DB
  * Expiration handling

* Menu view
  * Music player
  * Default toot visibility
  * Default NSFW status
  * Default CW
  * Default local only
  * Timeline filter
    * Keyword mute
    * Regex
  * Fav statuses
  * List feature
  * Hashtag Timeline
  * Follow requests
  * Muted users
  * Blocked users
  * Logout
  * Help
  * Cache management
  * Instance about page
  * Privacy policy
  * App version
  * Developer info
  * License info

* Connection status handling

* User search view

* App icons
  * App icon
  * Tab bar icons
  * Rep, BT, Fav icons
  * Menu dots icon

* Launch image

* UI theme manager
  * Default dark theme

* UI animations

* Refine BBCodeView
  * Support to display user display name

* Refine Timeline attachments stack view to collection view

* Force touch media preview

* Support latest Mastodon API features
  * Refine MastodonKit

* iPad testing

* Prepare for first release
  * GitHub
    * README
    * Lincense
  * AppStore

### For later releases

* Multi account support

* Copy & Paste media to toot view

* Receive media from other apps

* Custom URI Scheme support

* Support other Mastodon instances
  * Disable Knzk specific features (like local only toot)

* Show favicon aside URL link
  * Fetch favicon by using OpenGraphProtocol

* Show user icon aside @ mention link

* Markdown support

* Advanced toot view
  * Text selection menu for BBCode
  * Syntax highlight for @ mention, BBCode, Markdown
  * Preview
  * Draw picture
  * Hashtag auto completion
  * Prepend emoji to indicate BBCode and @ mention user

* iPad UI
  * Pallarax scrolling for multiple timelies

* Tutorial

* Pleroma support

* Diaspora support
