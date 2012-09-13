//
//  predixerAboutViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface predixerAboutViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *webView;
}

- (void)pressBack:(id)sender;

@end
