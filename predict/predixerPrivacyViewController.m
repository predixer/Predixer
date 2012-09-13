//
//  predixerPrivacyViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import "predixerPrivacyViewController.h"

@interface predixerPrivacyViewController ()

@end

@implementation predixerPrivacyViewController

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
    
    //LEFT NAV BUTTON
    // Set the custom back button
	UIImage *backButtonNormalImage = [UIImage imageNamed:@"btn_Back.png"];
	UIImage *backButtonHighlightImage = [UIImage imageNamed:@"btn_Back_up.png"];
    
	//create the button and assign the image
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:backButtonNormalImage forState:UIControlStateNormal];
	[backButton setImage:backButtonHighlightImage forState:UIControlStateHighlighted];
    
    
	//set the frame of the button to the size of the image (see note below)
	backButton.frame = CGRectMake(0, 0, backButtonNormalImage.size.width, backButtonNormalImage.size.height);
    
	[backButton addTarget:self action:@selector(pressBack:) forControlEvents:UIControlEventTouchUpInside];
    
	//create a UIBarButtonItem with the button as a custom view
	UIBarButtonItem *customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = customBackBarItem;
    
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.predixer.com/privacy.aspx"]]];
}

- (void)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	
     UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle
     :UIActivityIndicatorViewStyleGray];
     av.frame=CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 50.0f, 50.0f);
     av.tag  = 1;
     [self.view addSubview:av];
     [av startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
     UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
     [tmpimg removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

@end
