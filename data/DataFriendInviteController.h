//
//  DataFriendInviteController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import <Foundation/Foundation.h>

@interface DataFriendInviteController : NSObject {
    
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
}

- (void)inviteFriend:(NSString *)inviteeFB;

@end
