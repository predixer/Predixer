//
//  DataAddImageView.h
//  predict
//
//  Created by Joel R Ballesteros on 2/1/13.
//
//

#import <Foundation/Foundation.h>

@interface DataAddImageView : NSObject
{
    NSMutableArray *arrData;
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
    
}

- (void)addImageView:(NSString *)imageID isImageView:(BOOL)isView;
- (unsigned)countOfList;
@end
