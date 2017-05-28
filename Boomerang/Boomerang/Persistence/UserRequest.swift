//
//  UserRequest.swift
//  Boomerang
//
//  Created by Felipe perius on 07/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


class UserRequest: NSObject {
    
    static func createAccountUser(user: User, pass: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        let pfUser = PFUser()
        
        pfUser.password = pass
        pfUser.email = user.email
        
        pfUser.signUpInBackground { (success, error) in
            if error == nil {
                completionHandler(true, "Sucesso")
            } else {
                
                completionHandler(false, error.debugDescription)
            }
        }
    }
    
    static func getProfileUser(completionHandler: @escaping (_ sucess: Bool, _ msg: String) -> ()) {
        let user = PFUser.current()!
        user.fetchObjectInBackgroundBy(key: "profile") { (success, msg, profile) in
            if success {
                ApplicationState.sharedInstance.currentUser = PFUser.current() as? User
                ApplicationState.sharedInstance.currentUser!.profile = Profile(object: profile!)
                completionHandler(success, msg)
            } else {
                completionHandler(success, msg)
            }
        }
    }
    
    static func getAllProfiles(profilesDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ profiles: [Profile]?) -> Void)  {
        
        var notContainedObjectIds = [String]()
        notContainedObjectIds.append(ApplicationState.sharedInstance.currentUser!.profile!.objectId!)
        profilesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        var profiles = [Profile]()
        let notContainedObjects = [ObjectKeys.objectId: notContainedObjectIds]
        
        ParseRequest.queryGetAllObjects(className: Profile.parseClassName(), notContainedObjects: notContainedObjects, pagination: pagination, includes: nil) { (success,  msg, objects) in
            if success {
                objects!.forEach {
                    let profile = $0 as? Profile
                    profiles.append(profile!)
                }
                completionHandler(success, msg, profiles)
            } else {
                completionHandler(success, msg, nil)
            }
        }
    }
    
    static func getProfileByFacebookIds(facebookIds: [String], friendsDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ facebookFriends: [Profile]?) -> Void)  {
        
        var friends: [Profile] = [Profile]()
        let queryParams = [ProfileKeys.facebookId: facebookIds]
        var notContainedObjectIds = [String]()
        
        friendsDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        let notContainedObjects = [ObjectKeys.objectId: notContainedObjectIds]
        
        ParseRequest.queryContainedIn(className: Profile.parseClassName(), queryType: .common, whereType: .containedIn, includes: nil, cachePolicy: .networkElseCache, params: queryParams, notContainedObjects: notContainedObjects, pagination: pagination) { (success, msg, objects) in
            if success {
                objects!.forEach {
                    let friend = $0 as? Profile
                    friends.append(friend!)
                }
                completionHandler(success, msg, friends)
            } else {
                completionHandler(success, msg, nil)
            }
        }
    }
    
    static func loginUserWithFacebook(id: String, email: String,userName: String ,mediaType:Int,completionHandler: @escaping (_ sucess: Bool, _ msg: String, _ user: User?) -> Void) {
        
        
    }
    
    static func loginUser(email: String, pass: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        PFUser.logInWithUsername(inBackground: email, password: pass) { (success, error) in
            
            if error == nil {
                completionHandler(true, "Sucesso")
            } else {
                completionHandler(false, error.debugDescription)
            }
        }
    }
    
    
    static func getUserCountOfDictionary(keysCount: [String: [String]], user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        
        
    }
    
    func getUserImage(profile: Profile, imageView: UIImageView, completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void) {
        
        guard let image = profile.profileImage else {
            imageView.loadAnimation()
            profile.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                if success {
                    completionHandler(true, "Success", UIImage(data: data!)!)
                } else {
                    completionHandler(false, msg, nil)
                }
                imageView.unload()
            })
            return
        }
        completionHandler(true, "Success", image)
    }
    
    
    static func unfollowUser(currentProfile: Profile, otherProfile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["from"] = currentProfile
        queryParams["to"] = otherProfile
        
        
        ParseRequest.queryToUpdateToDeletedWithParams(className: "Follow", params: queryParams) { (success, msg) in
            completionHandler(success, "success")
        }
    }
    
    
    static func getProfileCountOf(key: String, className: String, profile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        
        ParseRequest.queryCountEqualToValue(className: className, key: key, value: profile) { (success, msg, count) in
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(true, msg, nil)
            }
        }
    }
    
    static func verifyAlreadyFollowingFor(currentProfile: Profile, otherProfile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String, _ alreadyFollow: Bool) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["from"] = currentProfile
        queryParams["to"] = otherProfile
        print ("OTHER PROFILE\(otherProfile)")
        
        ParseRequest.queryEqualToValue(className: "Follow", queryParams: queryParams, includes: nil) { (success, msg, objects) in
            if success {
                if objects!.count > 0 {
                    completionHandler(true, "Success", true)
                } else {
                    completionHandler(true, msg, false)
                }
            }
        }
    }
    

    static func fetchFollowing(fromProfile: Profile, followingDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Profile]?) -> Void) {
        
        var following: [Profile] = [Profile]()
        let queryParams = ["from" : [fromProfile]]
    
        var notContainedObjectIds = [String]()
        
        followingDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        let notContainedObjects = ["objectId": notContainedObjectIds]
        
        
        ParseRequest.queryEqualToValueNotContainedObjects(className: "Follow", queryType: .common, whereTypes: [.equal], params: queryParams, cachePolicy: .networkElseCache, notContainedObjects: notContainedObjects, includes: ["to"], pagination: pagination) { (success, msg, objects) in
            if success {
                for object in objects! {
                    
                    let follow = Profile(object: object.object(forKey: "to")! as! PFObject)
                    following.append(follow)
                }
                completionHandler(true, "Success", following)
            } else {
                completionHandler(false, msg.debugDescription, nil)
            }
        }
    }
}
