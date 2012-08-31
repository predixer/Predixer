//
//  CustomTabBarItem.h
//  predict
//
//  Created by Joel R Ballesteros on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarItem : UITabBarItem
{
    UIImage *customHighlightedImage;
    UIImage *customStdImage;
}

@property (nonatomic, retain) UIImage *customHighlightedImage;
@property (nonatomic, retain) UIImage *customStdImage;

@end
