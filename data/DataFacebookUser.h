//
//  DataFacebookUser.h
//  predict
//
//  Created by Joel R Ballesteros on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFacebookUser : NSObject {    
    
    NSString *fbRecordID;
    NSString *userID;
    NSString *facebookUserID;
	NSString *facebookUserEmail;
	NSString *facebookName;
	NSString *facebookUserFirstName;
	NSString *facebookUserLastName;
	NSString *facebookUserName;
	NSString *facebookUserGender;
	NSString *facebookUserLocation;
	NSDate *dateEntered;
	NSDate *lastLogin;
}

@property (nonatomic, strong)NSString *fbRecordID;
@property (nonatomic, strong)NSString *userID;
@property (nonatomic, strong)NSString *facebookUserID;
@property (nonatomic, strong)NSString *facebookUserEmail;
@property (nonatomic, strong)NSString *facebookName;
@property (nonatomic, strong)NSString *facebookUserFirstName;
@property (nonatomic, strong)NSString *facebookUserLastName;
@property (nonatomic, strong)NSString *facebookUserName;
@property (nonatomic, strong)NSString *facebookUserGender;
@property (nonatomic, strong)NSString *facebookUserLocation;
@property (nonatomic, strong)NSDate *dateEntered;
@property (nonatomic, strong)NSDate *lastLogin;


+ (DataFacebookUser *)recordWithID:(NSString *)aFbRecordID userID:(NSString *)auserID facebookUserID:(NSString *)afacebookUserID facebookUserEmail:(NSString *)afacebookUserEmail facebookName:(NSString *)afacebookName facebookUserFirstName:(NSString *)afacebookUserFirstName facebookUserLastName:(NSString *)afacebookUserLastName facebookUserName:(NSString *)afacebookUserName facebookUserGender:(NSString *)afacebookUserGender facebookUserLocation:(NSString *)afacebookUserLocation dateEntered:(NSDate *)adateEntered lastLogin:(NSDate *)alastLogin;

- (id)initWithRecordID:(NSString *)aFbRecordID userID:(NSString *)auserID facebookUserID:(NSString *)afacebookUserID facebookUserEmail:(NSString *)afacebookUserEmail facebookName:(NSString *)afacebookName facebookUserFirstName:(NSString *)afacebookUserFirstName facebookUserLastName:(NSString *)afacebookUserLastName facebookUserName:(NSString *)afacebookUserName facebookUserGender:(NSString *)afacebookUserGender facebookUserLocation:(NSString *)afacebookUserLocation dateEntered:(NSDate *)adateEntered lastLogin:(NSDate *)alastLogin;

@end
