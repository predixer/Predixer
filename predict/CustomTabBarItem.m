//
//  CustomTabBarItem.m
//  predict
//
//  Created by Joel R Ballesteros on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarItem.h"

@implementation CustomTabBarItem

@synthesize customHighlightedImage;
@synthesize customStdImage;

-(UIImage *) selectedImage
{
    return self.customHighlightedImage;
}

-(UIImage *) unselectedImage
{
    return self.customStdImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
