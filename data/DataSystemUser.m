//
//  DataSystemUser.m
//  predict
//
//  Created by Joel R Ballesteros on 10/1/12.
//
//

#import "DataSystemUser.h"

@implementation DataSystemUser

@synthesize userID;
@synthesize userName;
@synthesize email;
@synthesize dateEntered;
@synthesize isWrongPassword;

+ (DataSystemUser *)recordWithID:(NSString *)aUserID userName:(NSString *)aUserName email:(NSString *)aEmail dateEntered:(NSDate *)aDateEntered isWrongPassword:(NSString *)aWrongPassword {
    
    return [[DataSystemUser alloc] initWithUserID:aUserID userName:aUserName email:aEmail dateEntered:aDateEntered isWrongPassword:aWrongPassword];
    
}

- (id)initWithUserID:(NSString *)aUserID userName:(NSString *)aUserName email:(NSString *)aEmail dateEntered:(NSDate *)aDateEntered isWrongPassword:(NSString *)aWrongPassword {
    
    if ((self = [super init])) {
        
        userID = [aUserID copy];
        userName = [aUserName copy];
        email = [aEmail copy];;
        dateEntered = [aDateEntered copy];
        isWrongPassword = aWrongPassword;
	}
	return self;
    
}

@end
