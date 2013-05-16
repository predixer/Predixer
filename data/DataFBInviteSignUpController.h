//
//  DataFBInviteSignUpController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import <Foundation/Foundation.h>

@class DataFBInviteSignUp;

@interface DataFBInviteSignUpController : NSObject {
    
    DataFBInviteSignUp *fbInvitee;
    NSMutableArray *arrInvitees;
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong) DataFBInviteSignUp *fbInvitee;


- (void)getInvitees;
- (unsigned)countOfList;
- (DataFBInviteSignUp *)objectInListAtIndex:(unsigned)theIndex;

@end
