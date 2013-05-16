//
//  DataUserAnswersController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import <Foundation/Foundation.h>

@class DataUserAnswers;

@interface DataUserAnswersController : NSObject {
    
    DataUserAnswers *userAnswer;
    NSMutableArray *arrAnswer;
    NSMutableData *receivedData;
        
    NSNotificationCenter *nc;
    
    bool isGetCorrectAnswers;
}

@property (nonatomic, strong)DataUserAnswers *userAnswer;
@property (readwrite) bool isGetCorrectAnswers;


- (void)getUserAnswers;
- (unsigned)countOfList;
- (DataUserAnswers *)objectInListAtIndex:(unsigned)theIndex;

@end
