//
//  DataUserPoints.h
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import <Foundation/Foundation.h>

@interface DataUserPoints : NSObject {
    
    NSString *fbRecordID;
    NSString *facebookUserID;
	NSString *topCommentPoints;
	NSString *invitePoints;
	NSString *totalPredictPoints;
	NSString *grandTotalPoints;
	NSString *drawPoints;
    
}

@property (nonatomic, strong)NSString *fbRecordID;
@property (nonatomic, strong)NSString *facebookUserID;
@property (nonatomic, strong)NSString *topCommentPoints;
@property (nonatomic, strong)NSString *invitePoints;
@property (nonatomic, strong)NSString *totalPredictPoints;
@property (nonatomic, strong)NSString *grandTotalPoints;
@property (nonatomic, strong)NSString *drawPoints;


+ (DataUserPoints *)recordWithID:(NSString *)aFbRecordID facebookUserID:(NSString *)afacebookUserID topCommentPoints:(NSString *)aTopCommentPoints invitePoints:(NSString *)aInvitePoints totalPredictPoints:(NSString *)aTotalPredictPoints grandTotalPoints:(NSString *)aGrandTotalPoints drawPoints:(NSString *)aDrawPoints;

- (id)initWithRecordID:(NSString *)aFbRecordID facebookUserID:(NSString *)afacebookUserID topCommentPoints:(NSString *)aTopCommentPoints invitePoints:(NSString *)aInvitePoints totalPredictPoints:(NSString *)aTotalPredictPoints grandTotalPoints:(NSString *)aGrandTotalPoints drawPoints:(NSString *)aDrawPoints;


@end
