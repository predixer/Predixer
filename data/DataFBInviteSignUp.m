//
//  DataFBInviteSignUp.m
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import "DataFBInviteSignUp.h"

@implementation DataFBInviteSignUp

@synthesize inviterFBID;
@synthesize inviteeFBID;
@synthesize invitePoints;
@synthesize signUpDate;
@synthesize fbName;
@synthesize fbEmail;
@synthesize inviteDate;

+ (DataFBInviteSignUp *)inviteeWithID:(NSString*)aInviteeFBID inviterFBID:(NSString*)aInviterFBID invitePoints:(int)ainvitePoints signUpDate:(NSDate*)aSignUpDate fbName:(NSString*)afbName fbEmail:(NSString*)afbEmail inviteDate:(NSDate*)aInviteDate {
    
    return [[DataFBInviteSignUp alloc] initWithInviteeID:aInviteeFBID inviterFBID:aInviterFBID invitePoints:ainvitePoints signUpDate:aSignUpDate fbName:afbName fbEmail:afbEmail inviteDate:aInviteDate];
    
}

- (id)initWithInviteeID:(NSString*)aInviteeFBID inviterFBID:(NSString*)aInviterFBID invitePoints:(int)ainvitePoints signUpDate:(NSDate*)aSignUpDate fbName:(NSString*)afbName fbEmail:(NSString*)afbEmail inviteDate:(NSDate*)aInviteDate {
    
    if ((self = [super init])) {
        
        inviterFBID = [aInviterFBID copy];
        inviteeFBID = [aInviteeFBID copy];;
        invitePoints = ainvitePoints;
        signUpDate = [aSignUpDate copy];;
        fbName = [afbName copy];
        fbEmail = [afbEmail copy];
        inviteDate = [aInviteDate copy];
        
	}
	return self;
    
}

@end
