//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum AccountsService {
    /// Fetching an account
    /// Returns an Account entity
    case account(param: ServiceParam, id: String)

    /// Getting the current user
    /// Returns the authenticated user's Account entity with an extra attribute
    case currentUser(param: ServiceParam)

    /// Updating the current user
    /// Returns the authenticated user's Account
    case updateCurrentUser(param: ServiceParam, form: AccountUpdateForm)

    /// Getting an account's followers
    /// Returns an array of Account entities
    case followers(param: ServiceParam, accountID: String, query: RangeQuery)

    /// Getting who account is following
    /// Returns an array of Account entities
    case following(param: ServiceParam, accountID: String, query: RangeQuery)

    /// Getting an account's statuses
    /// Returns an array of Status entities
    case statuses(param: ServiceParam, accountID: String, query: AccountStatusesQuery)

    /// Following an account
    /// Returns the target account's Relationship entity
    case follow(param: ServiceParam, targetAccountID: String, isIncludeReblogs: Bool?)

    /// Unfollowing an account
    /// Returns the target account's Relationship entity
    case unfollow(param: ServiceParam, targetAccountID: String)

    /// Blocking an account
    /// Returns the target account's Relationship entity
    case block(param: ServiceParam, targetAccountID: String)

    /// Unblocking an account
    /// Returns the target account's Relationship entity
    case unblock(param: ServiceParam, targetAccountID: String)

    /// Muting an account
    /// Returns the target account's Relationship entity
    case mute(param: ServiceParam, targetAccountID: String, isMutingNotifications: Bool?)

    /// Unmuting an account
    /// Returns the target account's Relationship entity
    case unmute(param: ServiceParam, targetAccountID: String)

    /// Getting an account's relationships
    /// Returns an array of Relationship entities of the current user to a list of given accounts
    case relationships(param: ServiceParam, ids: [String])

    /// Searching for accounts
    /// Will lookup an account remotely if the search term is in the `username@domain` format and not yet in the DB.
    /// Returns an array of matching Account entities
    case search(param: ServiceParam, query: String, limit: UInt?, isLimitedFollowing: Bool?)
}
