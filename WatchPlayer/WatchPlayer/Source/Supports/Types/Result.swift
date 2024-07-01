//
//  Result.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/1/24.
//

import Foundation

protocol CommonResult {}

@frozen
public enum ResultwithError: CommonResult {
    case success(Any)
    case error(Error)
}

public enum ResultWithFail: CommonResult {
    case success(Any)
    case fail(Any)
}
