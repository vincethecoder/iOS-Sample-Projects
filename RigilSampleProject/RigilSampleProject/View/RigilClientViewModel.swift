//
//  RigilClientViewModel.swift
//  RigilSampleProject
//
//  Created by Kobe Sam on 1/9/18.
//  Copyright © 2018 vincethecoder. All rights reserved.
//

import Foundation

enum RigilClientError: Error, CustomStringConvertible {
    case NoRigilClientExists
    
    var description: String {
        return "No Rigil client info available at this time. Please enter a client name."
    }
}

struct RigilClientViewModel {
    
    typealias RigilClientCompletionBlock = () -> Void
    
    var reloadLoadTableViewClosure: RigilClientCompletionBlock?
    
    private var currentClient: RigilClient? = nil {
        didSet {
            self.reloadLoadTableViewClosure?()
        }
    }

    var numberOfCells: Int {
        guard let client = currentClient else {
            return 0
        }
        return client.name.count
    }
    
    private func getCurrentClient() throws -> RigilClient {
        guard let client = currentClient else {
            throw RigilClientError.NoRigilClientExists
        }
        return client
    }
    
    func getClientNameChar(at indexPath: IndexPath) -> String {
        var character = ""
        do {
            let clientInfo = try getCurrentClient()
            let clientName = clientInfo.name
            character = String(Array(clientName)[indexPath.row])
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return character
    }
    
    mutating func clientEntered(_ client: RigilClient) {
        currentClient = client
    }
}
