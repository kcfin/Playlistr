//
//  ProfileViewModel.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/27/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    let user: SpotifyUser;
    var profileImage: UIImage?;
    var name: String?;
    
    init(withPerson person:SpotifyUser) {
        user = person;
        setProfileImage();
        setName();
    }
    
    func setProfileImage() {
        profileImage = user.profileImage;
    }
    
    func setName() {
        name = user.name;
    }
    
    
}
