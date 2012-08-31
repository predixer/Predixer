//
//  DataFacebookUser.m
//  predict
//
//  Created by Joel R Ballesteros on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataFacebookUser.h"

@implementation DataFacebookUser

@synthesize fbRecordID;
@synthesize userID;
@synthesize facebookUserID;
@synthesize facebookUserEmail;
@synthesize facebookName;
@synthesize facebookUserFirstName;
@synthesize facebookUserLastName;
@synthesize facebookUserName;
@synthesize facebookUserGender;
@synthesize facebookUserLocation;
@synthesize dateEntered;
@synthesize lastLogin;

+ (DataFacebookUser *)recordWithID:(NSString *)aFbRecordID userID:(NSString *)auserID facebookUserID:(NSString *)afacebookUserID facebookUserEmail:(NSString *)afacebookUserEmail facebookName:(NSString *)afacebookName facebookUserFirstName:(NSString *)afacebookUserFirstName facebookUserLastName:(NSString *)afacebookUserLastName facebookUserName:(NSString *)afacebookUserName facebookUserGender:(NSString *)afacebookUserGender facebookUserLocation:(NSString *)afacebookUserLocation dateEntered:(NSDate *)adateEntered lastLogin:(NSDate *)alastLogin {
    
    return [[DataFacebookUser alloc] initWithRecordID:aFbRecordID userID:auserID facebookUserID:afacebookUserID facebookUserEmail:afacebookUserEmail facebookName:afacebookName facebookUserFirstName:afacebookUserFirstName facebookUserLastName:afacebookUserLastName facebookUserName:afacebookUserName facebookUserGender:afacebookUserGender facebookUserLocation:afacebookUserLocation dateEntered:adateEntered lastLogin:alastLogin];
    
}

- (id)initWithRecordID:(NSString *)aFbRecordID userID:(NSString *)auserID facebookUserID:(NSString *)afacebookUserID facebookUserEmail:(NSString *)afacebookUserEmail facebookName:(NSString *)afacebookName facebookUserFirstName:(NSString *)afacebookUserFirstName facebookUserLastName:(NSString *)afacebookUserLastName facebookUserName:(NSString *)afacebookUserName facebookUserGender:(NSString *)afacebookUserGender facebookUserLocation:(NSString *)afacebookUserLocation dateEntered:(NSDate *)adateEntered lastLogin:(NSDate *)alastLogin {
    
    if ((self = [super init])) {		
        fbRecordID = [aFbRecordID copy];
        userID = [auserID copy];
        facebookUserID = [afacebookUserID copy];
		facebookUserEmail = [afacebookUserEmail copy];	
        facebookName = [afacebookName copy];
        facebookUserFirstName = [afacebookUserFirstName copy];
        facebookUserLastName = [afacebookUserLastName copy];
        facebookUserName = [afacebookUserName copy];
        facebookUserGender = [afacebookUserGender copy];
        facebookUserLocation = [afacebookUserLocation copy];
		dateEntered = [adateEntered copy];
		lastLogin = [alastLogin copy];
	}
	return self;
    
}

@end
