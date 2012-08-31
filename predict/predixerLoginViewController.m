//
//  predixerLoginViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerLoginViewController.h"
#import "predixerAboutViewController.h"
#import "predixerHowToViewController.h"
#import "predixerGameMenuViewController.h"

@interface predixerLoginViewController ()

@end

@implementation predixerLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view from its nib.
    UIImage *fbImage = [UIImage imageNamed:@"btn_Facebook_up.png"]; 
    [btnFacebook setImage:fbImage forState:UIControlStateHighlighted];
    
    UIImage *submitImage = [UIImage imageNamed:@"btn_Submit_up.png"]; 
    [btnSubmit setImage:submitImage forState:UIControlStateHighlighted];
    
    UIImage *aboutImage = [UIImage imageNamed:@"btn_About_up.png"]; 
    [btnAbout setImage:aboutImage forState:UIControlStateHighlighted];
    
    UIImage *howtoImage = [UIImage imageNamed:@"btn_HowTo_up.png"]; 
    [btnHowTo setImage:howtoImage forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressFacebook:(id)sender
{
    
}

- (IBAction)pressSubmit:(id)sender
{
    predixerGameMenuViewController *menu = [[predixerGameMenuViewController alloc] init];
    [self.navigationController pushViewController:menu animated:YES];
}

- (IBAction)pressAbout:(id)sender
{
    predixerAboutViewController *about = [[predixerAboutViewController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
}

- (IBAction)pressHowTo:(id)sender
{
    predixerHowToViewController *howto = [[predixerHowToViewController alloc]init];
    [self.navigationController pushViewController:howto animated:YES];
}

@end
