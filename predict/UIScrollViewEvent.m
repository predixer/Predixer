//
//  UIScrollViewEvent.m
//  predict
//
//  Created by Joel R Ballesteros on 1/23/13.
//
//

#import "UIScrollViewEvent.h"

@implementation UIScrollViewEvent

@synthesize imgView;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imgView != nil) {
        // center the image as it becomes smaller than the size of the screen
        CGSize boundsSize = self.bounds.size;
        
        //NSLog(@"height %f", self.frame.size.height);
        //NSLog(@"width %f", self.frame.size.width);
        
        
       // NSLog(@"height %f", boundsSize.height);
       // NSLog(@"height %f", boundsSize.width);
        
        
        UIImage * img = imgView.image;
        CGRect  frameToCenter =  CGRectZero;
        
        if (img) {
            // Change orientation: Portrait -> Lanscape : this lets you see the whole image
            if (UIDeviceOrientationIsLandscape( [UIDevice currentDevice].orientation)) {
                frameToCenter = CGRectMake(0, 0, (568.0f*img.size.width)/img.size.height  * self.zoomScale, 568.0f * self.zoomScale);
            } else {
                frameToCenter = CGRectMake(0, 0, self.frame.size.width * self.zoomScale, (self.frame.size.width*img.size.height)/img.size.width  * self.zoomScale);
            }
        } else {
            frameToCenter =  self.imgView.frame;
        }
        
        // center horizontally
        if (frameToCenter.size.width < boundsSize.width)
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
        else
            frameToCenter.origin.x = 0;
        
        // center vertically
        
        if (frameToCenter.size.height < boundsSize.height)
            frameToCenter.origin.y = (568.0f - frameToCenter.size.height) / 2;
        else
            frameToCenter.origin.y = 0;
            
        
        imgView.frame = frameToCenter;
        //imgView.frame.center = self.frame.size.height/2;
        self.contentSize = imgView.frame.size;
    }
}

@end
