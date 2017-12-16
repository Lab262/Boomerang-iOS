//
//  UserRequest.swift
//  Boomerang
//
//  Created by Felipe perius on 07/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4


class UserRequest: NSObject {
    
    static func facebookLoginUser(completionHandler: @escaping (_ success: Bool, _ msg: String, _ user: PFUser?, _ isWithValidePromoCode: Bool?) -> ()) {
        
        let permissions = [FacebookParams.publicProfile, FacebookParams.email, FacebookParams.userFriends]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            if let user = user, error == nil {
                let query = PFQuery(className: "UserPromoCodes")
                query.whereKey("userGuestPointer", equalTo: user)
                query.findObjectsInBackground(block: { (objectArray, error) in
                    if let objectArray = objectArray, error == nil, objectArray.count > 0 {
                        completionHandler(true, "", user, true)
                    } else {
                        completionHandler(true, "", user,false)
                    }
                })
            } else {
                completionHandler(false, error?.localizedDescription ?? "user nil", nil, false)
            }
        }
    }
    
    
    static func getFacebookUserPhoto (userId: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ file: PFFile?) -> ()) {
        
        var file: PFFile?
        
        DispatchQueue.main.async {
            if let url = URL(string: FacebookUrls.graph + userId + FacebookUrls.pictureLarge) {
                do {
                    let contents = try Data(contentsOf: url)
                    file = PFFile(data: contents, contentType: ImageFile.jpeg)
                    completionHandler(true, "", file)
                } catch {
                    completionHandler(false, "contents could not be loaded", nil)
                }
            } else {
                completionHandler(false, "url not working", nil)
            }
        }
    }

    
    static func requestFacebookParameters(completionHandler: @escaping (_ success: Bool, _ msg: String, _ result: Any?) -> ())  {
        
        let requestParameters = [FacebookParams.fieldsKey: FacebookParams.id + ", " + FacebookParams.email + ", " + FacebookParams.firstName + ", " + FacebookParams.lastName]
        
        let userDetails = FBSDKGraphRequest(graphPath: FacebookParams.meGraphPath, parameters: requestParameters)
        
        userDetails!.start(completionHandler: { (_, result, error) in
            if let result = result, error == nil {
                completionHandler(true, "", result)
            } else {
                completionHandler(false, "", error?.localizedDescription ?? "result is nil")
            }
        })

    }
    
    static func getProfileUser(completionHandler: @escaping (_ sucess: Bool, _ msg: String) -> ()) {
        let user = User.current()!
        user.fetchObjectInBackgroundBy(key: UserKeys.profile) { (success, msg, profile) in
            if success {
                completionHandler(success, msg)
            } else {
                completionHandler(success, msg)
            }
        }
    }
    
    
    
    static func getAllProfiles(profilesDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ profiles: [Profile]?) -> Void)  {
        
        var notContainedObjectIds = [String]()
        notContainedObjectIds.append(User.current()!.objectId!)
        profilesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        var profiles = [Profile]()
        let notContainedObjects = [ObjectKeys.objectId: notContainedObjectIds]
        
        ParseRequest.queryGetAllObjects(className: Profile.parseClassName(), notContainedObjects: notContainedObjects, pagination: pagination, includes: nil) { (success,  msg, objects) in
            if success {
                objects!.forEach {
                    if let profile = $0 as? Profile {
                        profiles.append(profile)
                    }
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
        queryParams[FollowKeys.from] = currentProfile
        queryParams[FollowKeys.to] = otherProfile
        
        
        ParseRequest.queryToUpdateToDeletedWithParams(className: Follow.parseClassName(), params: queryParams) { (success, msg) in
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
        queryParams[FollowKeys.from] = currentProfile
        queryParams[FollowKeys.to] = otherProfile
        
        ParseRequest.queryEqualToValue(className: Follow.parseClassName(), queryParams: queryParams, includes: nil) { (success, msg, objects) in
            if success {
                if let objects = objects {
                    if objects.count > 0 {
                        completionHandler(true, "Success", true)
                    } else {
                        completionHandler(true, "no following", false)
                    }
                }
            } else {
                completionHandler(success, msg, false)
            }
        }
    }
    
    
    static func fetchProfileFriends(fromProfile: Profile, followingDownloaded: [Profile], isFollowers: Bool, pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Profile]?) -> Void) {
        
        var profiles: [Profile] = [Profile]()
        
        let followKey = isFollowers ? FollowKeys.to : FollowKeys.from
        
        let queryParams = [followKey : [fromProfile]]
        
        let includeKey = followKey == FollowKeys.from ? FollowKeys.to : FollowKeys.from
        
        let notContainedObjects = [includeKey: followingDownloaded]
        
        ParseRequest.queryEqualToValueNotContainedObjects(className: Follow.parseClassName(), queryType: .common, whereTypes: [.equal], params: queryParams, cachePolicy: .networkOnly, notContainedObjects: notContainedObjects, includes: [includeKey], pagination: pagination) { (success, msg, objects) in
            if success {
                for object in objects! {
                    if let profile = object.object(forKey: includeKey
                        ) as? Profile {
                        let profile = profile
                        profiles.append(profile)
                    }
                }
                completionHandler(true, "Success", profiles)
            } else {
                completionHandler(false, msg.debugDescription, nil)
            }
        }
    }
    

    static func fetchFollowing(fromProfile: Profile, followingDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Profile]?) -> Void) {
        
        var notContainedObjectIds = [String]()
        notContainedObjectIds.append(User.current()!.objectId!)
        followingDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }

        var profiles = [Profile]()
        let profilesQuery =  PFQuery(className: Profile.parseClassName())
        profilesQuery.whereKey(ObjectKeys.objectId, notContainedIn: notContainedObjectIds)

        let followQuery = PFQuery(className: Follow.parseClassName())
        followQuery.whereKey(FollowKeys.to, matchesQuery: profilesQuery)
        followQuery.whereKey(FollowKeys.from, equalTo: fromProfile)
        followQuery.includeKey(FollowKeys.to)
        followQuery.limit = pagination
        followQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        if let profile = object.object(forKey: FollowKeys.to
                            ) as? Profile {
                            let profile = profile
                            profiles.append(profile)
                        }
                    }
                }
                completionHandler(true, "success", profiles)
            } else {
                completionHandler(false, (error?.localizedDescription)!, nil)
            }
        }
    }

    static func searchProfiles(searchString: String, profilesDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ profiles: [Profile]?) -> Void)  {

        var notContainedObjectIds = [String]()
        notContainedObjectIds.append(User.current()!.objectId!)
        profilesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }

        var profiles = [Profile]()
        let firstNameQuery =  PFQuery(className: Profile.parseClassName()).whereKey(ProfileKeys.firstName, matchesRegex: "(?i)\(searchString)")
        let lastNameQuery =  PFQuery(className: Profile.parseClassName()).whereKey(ProfileKeys.lastName, matchesRegex: "(?i)\(searchString)")
        let orQuery = PFQuery.orQuery(withSubqueries: [firstNameQuery,lastNameQuery])
        orQuery.order(byDescending: ProfileKeys.firstName)
        orQuery.whereKey(ObjectKeys.objectId, notContainedIn: notContainedObjectIds)
        orQuery.limit = pagination

        orQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let profile = object as? Profile
                        profiles.append(profile!)
                    }
                }
                completionHandler(true, "success", profiles)
            } else {
                completionHandler(false, (error?.localizedDescription)!, nil)
            }
        }
    }

    static func searchFriends(searchString: String,fromProfile: Profile, profilesDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ profiles: [Profile]?) -> Void)  {

        var notContainedObjectIds = [String]()
        notContainedObjectIds.append(User.current()!.objectId!)
        profilesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }

        var profiles = [Profile]()
        let firstNameQuery =  PFQuery(className: Profile.parseClassName()).whereKey(ProfileKeys.firstName, matchesRegex: "(?i)\(searchString)")
        let lastNameQuery =  PFQuery(className: Profile.parseClassName()).whereKey(ProfileKeys.lastName, matchesRegex: "(?i)\(searchString)")
        let orQuery = PFQuery.orQuery(withSubqueries: [firstNameQuery,lastNameQuery])
        orQuery.whereKey(ObjectKeys.objectId, notContainedIn: notContainedObjectIds)

        let followQuery = PFQuery(className: Follow.parseClassName())
        followQuery.whereKey(FollowKeys.to, matchesQuery: orQuery)
        followQuery.whereKey(FollowKeys.from, equalTo: fromProfile)
        followQuery.includeKey(FollowKeys.to)
        followQuery.limit = pagination
        followQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        if let profile = object.object(forKey: FollowKeys.to
                            ) as? Profile {
                            let profile = profile
                            profiles.append(profile)
                        }
                    }
                }
                completionHandler(true, "success", profiles)
            } else {
                completionHandler(false, (error?.localizedDescription)!, nil)
            }
        }
    }
}
