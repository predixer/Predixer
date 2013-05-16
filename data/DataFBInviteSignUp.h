//
//  DataFBInviteSignUp.h
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import <Foundation/Foundation.h>

@interface DataFBInviteSignUp : NSObject {
    
    NSString *inviterFBID;
    NSString *inviteeFBID;
	int invitePoints;
	NSDate *signUpDate;
    NSString *fbName;
    NSString *fbEmail;
	NSDate *inviteDate;    
}

@property (nonatomic, strong)NSString *inviterFBID;
@property (nonatomic, strong)NSString *inviteeFBID;
@property(readwrite)int invitePoints;
@property (nonatomic, strong)NSDate *signUpDate;
@property (nonatomic, strong)NSString *fbName;
@property (nonatomic, strong)NSString *fbEmail;
@property (nonatomic, strong)NSDate *inviteDate;


+ (DataFBInviteSignUp *)inviteeWithID:(NSString*)aInviteeFBID inviterFBID:(NSString*)aInviterFBID invitePoints:(int)ainvitePoints signUpDate:(NSDate*)aSignUpDate fbName:(NSString*)afbName fbEmail:(NSString*)afbEmail inviteDate:(NSDate*)aInviteDate;


- (id)initWithInviteeID:(NSString*)aInviteeFBID inviterFBID:(NSString*)aInviterFBID invitePoints:(int)ainvitePoints signUpDate:(NSDate*)aSignUpDate fbName:(NSString*)afbName fbEmail:(NSString*)afbEmail inviteDate:(NSDate*)aInviteDate;


@end
