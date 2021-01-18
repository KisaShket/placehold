//
//  GFError.swift
//  TestExcApp
//
//  Created by Kisa Shket on 16.01.2021.
//

import Foundation

enum GFError:Error{
    case unableToComplete
    case wrongRequest(statusCode: Int)
    case wrongData
    case noUrl
}

