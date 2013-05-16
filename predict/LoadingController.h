//
//  LoadingController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/18/12.
//
//

#import <UIKit/UIKit.h>

@interface LoadingController : UIViewController
{
    UIImageView *activityImageView;
    UILabel *lblLoadingText;
    NSString *strLoadingText;
}

@property(nonatomic, strong)NSString *strLoadingText;

@end
