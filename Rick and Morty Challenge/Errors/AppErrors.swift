//
//  AppErrors.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 28/01/2024.
//

import Foundation


/**
 We'll use this class to clasify any errors we receive on the app and that we want to handle appropiately.
 */
enum AppErrorType: Error {
    case unknown(String)
}
