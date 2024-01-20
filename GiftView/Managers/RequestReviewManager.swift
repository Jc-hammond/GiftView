//
//  RequestReviewManager.swift
//  GiftView
//
//  Created by Connor Hammond on 1/18/24.
//

import Foundation

class RequestReviewManager: ObservableObject {
    
    let userDefaults = UserDefaults.standard
    private let lastReviewedVersionKey = "com.ConnorHammond.GiftView.lastReviewedVersion"
    let limit = 3
    
    @Published private(set) var profilesCount = 0
    
    func canAskForReview() -> Bool {
        let mostRecentReviewedVersion = userDefaults.string(forKey: lastReviewedVersionKey)
        
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { fatalError("Expected to find a bundle version in the info dictionary.")}
        
        let hasReachedLimit = profilesCount.isMultiple(of: limit)
        let isNewVersion = currentVersion != mostRecentReviewedVersion
        
        guard profilesCount > 3 && hasReachedLimit && isNewVersion  else {
            return false
        }
        
        userDefaults.setValue(currentVersion, forKey: lastReviewedVersionKey)
        
        return true
    }
    
    func setCount(count: Int) {
        profilesCount = count
    }
    
    
}
