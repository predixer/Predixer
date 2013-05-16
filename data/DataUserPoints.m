//
//  DataUserPoints.m
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import "DataUserPoints.h"

@implementation DataUserPoints

@synthesize fbRecordID;
@synthesize facebookUserID;
@synthesize topCommentPoints;
@synthesize invitePoints;
@synthesize totalPredictPoints;
@synthesize grandTotalPoints;
@synthesize drawPoints;

+ (DataUserPoints *)recordWithID:(NSString *)aFbRecordID facebookUserID:(NSString *)afacebookUserID topCommentPoints:(NSString *)aTopCommentPoints invitePoints:(NSString *)aInvitePoints totalPredictPoints:(NSString *)aTotalPredictPoints grandTotalPoints:(NSString *)aGrandTotalPoints drawPoints:(NSString *)aDrawPoints {
    
    return [[DataUserPoints alloc] initWithRecordID:aFbRecordID facebookUserID:afacebookUserID topCommentPoints:aTopCommentPoints invitePoints:aInvitePoints totalPredictPoints:aTotalPredictPoints grandTotalPoints:aGrandTotalPoints drawPoints:aDrawPoints];
}

- (id)initWithRecordID:(NSString *)aFbRecordID facebookUserID:(NSString *)afacebookUserID topCommentPoints:(NSString *)aTopCommentPoints invitePoints:(NSString *)aInvitePoints totalPredictPoints:(NSString *)aTotalPredictPoints grandTotalPoints:(NSString *)aGrandTotalPoints drawPoints:(NSString *)aDrawPoints {
    
    if ((self = [super init])) {
        fbRecordID = [aFbRecordID copy];
        facebookUserID = [afacebookUserID copy];
        topCommentPoints = [aTopCommentPoints copy];
        invitePoints = [aInvitePoints copy];
        totalPredictPoints = [aTotalPredictPoints copy];
        grandTotalPoints = [aGrandTotalPoints copy];
        drawPoints = [aDrawPoints copy];

        
	}
	return self;
    
}

@end
