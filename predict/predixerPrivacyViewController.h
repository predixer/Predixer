//
//  predixerPrivacyViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import <UIKit/UIKit.h>

@interface predixerPrivacyViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *webView;
}

- (void)pressBack:(id)sender;

@end
