//
//  predixerViewControllerImageViewer.m
//  predict
//
//  Created by Joel R Ballesteros on 1/16/13.
//
//

#import "predixerViewControllerImageViewer.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
#import "UIScrollViewEvent.h"
#import "DataAddImageView.h"

@interface predixerViewControllerImageViewer ()

@end

@implementation predixerViewControllerImageViewer

@synthesize imgURL;
@synthesize strDesc;
@synthesize strLink;
@synthesize strURL;
@synthesize dataImageView;
@synthesize imgID;
@synthesize vwTextData;
@synthesize vwText;

- (id)init:(NSString *)url description:(NSString *)desc link:(NSString *)aLink imgID:(NSString *)aImgID
{
    self = [super init];
    if (self) {
        // Custom initialization
        strURL = url;
        strDesc = desc;
        strLink = aLink;
        imgID = aImgID;
        
    }
    return self;
}

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
    
    
    //CHECK FOR IPHONE 5
    if (IS_IPHONE5 == YES) {
        
        vwTextView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 568.0f);
        svwImage.frame = CGRectMake(0.0f, 0.0f, 320.0f, 568.0f);
        
        vwTextData.hidden = YES;
        btnGoToWeb.hidden = YES;
        vwImage.hidden = YES;
        svwImage.hidden = YES;
        
        vwText = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 306.0f, 500.0f)];
        vwText.text = [NSString stringWithFormat:@"\n\n %@", strDesc];
        vwText.font = [UIFont systemFontOfSize:15.0f];
        vwText.backgroundColor = [UIColor whiteColor];
        [vwTextView addSubview:vwText];
        
        btnGoTo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnGoTo addTarget:self
                   action:@selector(gotoWeb:)
         forControlEvents:UIControlEventTouchDown];
        [btnGoTo setTitle:@"See More at Website" forState:UIControlStateNormal];
        btnGoTo.frame = CGRectMake(35.0f, 510.0f, 212.0f, 36.0f);
        [vwTextView addSubview:btnGoTo];
        
        
    }
    
    
    vwText.editable = NO;
    vwTextData.editable = NO;
    
    [self setImage:strURL description:strDesc link:strLink];
}


- (IBAction)closeView:(id)sender
{
    dataImageView = nil;
    
    nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"didCloseImageView" object:nil];
    
}

- (void)setImage:(NSString *)url description:(NSString *)desc link:(NSString *)aLink
{
    //NSLog(@"url %@", url);
    //NSLog(@"desc %@", desc);
    //NSLog(@"aLink %@", aLink);
    
    
    
    //CHECK FOR IPHONE 5
    if (IS_IPHONE5 == YES) {
        
        
        vwText.text = [desc copy];
        vwText.editable = NO;
        
        scrollImageView = [[UIScrollViewEvent alloc] initWithFrame:CGRectMake(7.0f, 8.0f, 306.0f, 444.0f)];
        scrollImageView.backgroundColor = [UIColor whiteColor];
        scrollImageView.showsVerticalScrollIndicator = YES;
        scrollImageView.showsHorizontalScrollIndicator = NO;
        scrollImageView.maximumZoomScale = 5.;
        scrollImageView.minimumZoomScale = 1;
        scrollImageView.delegate = self;
        scrollImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [scrollImageView setUserInteractionEnabled:YES];
        [scrollImageView setMultipleTouchEnabled:YES];
        
        vwTextImage = [[UIImageView alloc] init];
        [vwTextImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
        
        vwTextImage.frame = CGRectMake(0, 0, vwTextImage.frame.size.width, vwTextImage.frame.size.height);
        
        // @Fix: Allows scrolling for different sized images
        scrollImageView.zoomScale = 1.1;
        scrollImageView.zoomScale = 1.0;
        
        
        scrollImageView.contentSize = vwTextImage.frame.size;
        
        ((UIScrollViewEvent*)scrollImageView).imgView = vwTextImage;
        [scrollImageView addSubview:vwTextImage];
        [self.view addSubview:scrollImageView];
        
        [scrollImageView setNeedsDisplay];
        
        [self.view bringSubviewToFront:btnFlipMe];
        [self.view bringSubviewToFront:btnClose];
        
    }
    else {
        
        vwTextData.text = [NSString stringWithFormat:@"\n %@", desc];
    
        [vwImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
        vwImage.frame = CGRectMake(0.0f, 0.0f, vwImage.image.size.width, vwImage.image.size.height);
        svwImage.contentSize = vwImage.image.size;
        
        vwTextData.editable = NO;
    }
    
    imgURL = [aLink copy];    
}

#pragma mark - UIScrollViewDelegate

//////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    //CHECK FOR IPHONE 5
    if (IS_IPHONE5 == YES) {
        return vwTextImage;
    }
    else {
        return vwImage;
    }
}

- (CGSize)contentSizeForscrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = scrollImageView.bounds;
    return CGSizeMake(bounds.size.width + 10, bounds.size.height + 10);
}

- (IBAction)flipMe:(id)sender;
{
    if (IS_IPHONE5 == YES) {
        if (vwTextView.hidden == YES) {
            [UIView transitionWithView:self.view duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                                   vwTextView.hidden = NO;
                                    vwTextImage.hidden = YES;
                                   scrollImageView.hidden = YES;
                               } completion:nil];
        }
        else {
            [UIView transitionWithView:self.view duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                                   vwTextImage.hidden = NO;
                                   vwTextView.hidden = YES;
                                   scrollImageView.hidden = NO;
                               } completion:nil];
            
        }
    }
    else {
        if (vwTextView.hidden == YES) {
            [UIView transitionWithView:self.view duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                                   vwTextView.hidden = NO;
                                   vwImage.hidden = YES;
                               } completion:nil];
        }
        else {
            [UIView transitionWithView:self.view duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                                   vwTextView.hidden = YES;
                                   vwImage.hidden = NO;
                               } completion:nil];
        }
    }
    

    
}

- (IBAction)gotoWeb:(id)sender
{
    //NSLog(@"imgURL %@", imgURL);
    if (dataImageView == nil) {
        dataImageView = [[DataAddImageView alloc] init];
        
        //NSLog(@"imgID %@", imgID);
        
        [dataImageView addImageView:imgID isImageView:false];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:imgURL]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

@end
