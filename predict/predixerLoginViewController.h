//
//  predixerLoginViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface predixerLoginViewController : UIViewController {
    
    IBOutlet UIButton *btnFacebook;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UIButton *btnAbout;
    IBOutlet UIButton *btnHowTo;
    
}

- (IBAction)pressFacebook:(id)sender;
- (IBAction)pressSubmit:(id)sender;
- (IBAction)pressAbout:(id)sender;
- (IBAction)pressHowTo:(id)sender;

@end
