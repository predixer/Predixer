//
//  LoadingController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/18/12.
//
//

#import "LoadingController.h"

@interface LoadingController ()

@end

@implementation LoadingController

@synthesize strLoadingText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        strLoadingText = @"Loading...";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:0.5f];
    
    //Create the first status image and the indicator view
    UIImage *statusImage = [UIImage imageNamed:@"load1.png"];
    activityImageView = [[UIImageView alloc]
                         initWithImage:statusImage];
    
    //Add more images which will be used for the animation
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"load1.png"],
                                         [UIImage imageNamed:@"load2.png"],
                                         [UIImage imageNamed:@"load3.png"],
                                         [UIImage imageNamed:@"load4.png"],
                                         [UIImage imageNamed:@"load5.png"],
                                         [UIImage imageNamed:@"load6.png"],
                                         [UIImage imageNamed:@"load7.png"],
                                         [UIImage imageNamed:@"load8.png"],
                                         [UIImage imageNamed:@"load9.png"],
                                         [UIImage imageNamed:@"load10.png"],
                                         [UIImage imageNamed:@"load11.png"],
                                         [UIImage imageNamed:@"load12.png"],
                                         [UIImage imageNamed:@"load13.png"],
                                         [UIImage imageNamed:@"load14.png"],
                                         [UIImage imageNamed:@"load15.png"],
                                         [UIImage imageNamed:@"load16.png"],
                                         nil];
    
    
    //Set the duration of the animation (play with it
    //until it looks nice for you)
    activityImageView.animationDuration = 1.5;
    
    
    //Position the activity image view somewhere in
    //the middle of your current view
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2-40.0f,
                                         statusImage.size.width,
                                         statusImage.size.height);
    
    //Start the animation
    [activityImageView startAnimating];
    
    UIImageView *loadingTextBkd;
    
    lblLoadingText = [[UILabel alloc] init];
/*
    lblLoadingText.frame = CGRectMake(0.0f,
                                      self.view.frame.size.height/2
                                      -statusImage.size.height/2 + 30.0f, 320.0f, 40.0f);
 */
    lblLoadingText.text = strLoadingText;
    lblLoadingText.textAlignment = UITextAlignmentCenter;
    lblLoadingText.font = [UIFont fontWithName: @"Verdana" size:12];
    lblLoadingText.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"%@, %d", lblLoadingText.text, [lblLoadingText.text length]);
    
    if ([lblLoadingText.text length] < 15) {
        
        loadingTextBkd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkd_Loading_sm.png"]];
        loadingTextBkd.frame = CGRectMake(self.view.frame.size.width/2-54.5f, self.view.frame.size.height/2-statusImage.size.height/2 + 40.0f, 109.0f, 18.0f);
        lblLoadingText.frame = CGRectMake(0.0f, 0.0f, 109.0f, 16.0f);
    }
    else {
        loadingTextBkd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkd_Loading.png"]];
        loadingTextBkd.frame = CGRectMake(self.view.frame.size.width/2-85.0f, self.view.frame.size.height/2-statusImage.size.height/2 + 40.0f, 170.0f, 18.0f);
        lblLoadingText.frame = CGRectMake(0.0f, 0.0f, 170.0f, 16.0f);
    }
    
    //Add your custom activity indicator to your current view
    [loadingTextBkd addSubview:lblLoadingText];
    [self.view addSubview:activityImageView];
    [self.view addSubview:loadingTextBkd];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [activityImageView stopAnimating];
    [activityImageView removeFromSuperview];
    activityImageView = nil;
    
    [lblLoadingText removeFromSuperview];
    lblLoadingText = nil;
}

@end
