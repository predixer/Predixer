//
//  predixerPlayCommentsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/5/12.
//
//

#import "predixerPlayCommentsViewController.h"
#import "DataComments.h"
#import "DataCommentsController.h"
#import "DataQuestions.h"
#import "DataUserCommentLike.h"
#import "DataUserCommentLikeController.h"
#import "predixerSettingsViewControllerViewController.h"
#import "MSLabel.h"
#import "LoadingController.h"

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 298.0f
#define CELL_CONTENT_MARGIN 6.0f

@interface predixerPlayCommentsViewController ()

@end

@implementation predixerPlayCommentsViewController

@synthesize dataComments;
@synthesize commentsDataController;
@synthesize dataQuestion;
@synthesize dataUserLikes;
@synthesize dataUserLikesController;
@synthesize loadingController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (dataComments == nil) {
            dataComments = [[DataComments alloc]init];
        }
        
        if (commentsDataController == nil) {
            commentsDataController = [[DataCommentsController alloc] init];
            
            NSLog(@"Count commentsDataController: %d", [commentsDataController countOfList]);
        }
        
        if (dataQuestion == nil) {
            dataQuestion = [[DataQuestions alloc] init];
        }
        
        if (dataUserLikes ==nil) {
            dataUserLikes = [[DataUserCommentLike alloc] init];
        }
        
        if (dataUserLikesController == nil) {
            dataUserLikesController = [[DataUserCommentLikeController alloc] init];
        }
        
        arrLikes = [[NSMutableArray alloc] init];
        arrLineHeight = [[NSMutableArray alloc] init];
        pageNumber = 0;
        
        nc = [NSNotificationCenter defaultCenter];
		

        isLoadMore = NO;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    //observer
    [nc addObserver:self
           selector:@selector(didFinishLoadingComments)
               name:@"didFinishLoadingComments"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(didFinishLikeComment)
               name:@"didFinishLikeComment"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(didFinishLoadingUserCommentsAllLike)
               name:@"didFinishLoadingUserCommentsAllLike"
             object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingComments" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLikeComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingUserCommentsAllLike" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    tblComments.backgroundColor = [UIColor clearColor];
    tblComments.dataSource = self;
    tblComments.delegate = self;
    
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
    
    //RIGHT NAV BUTTON
    // Set the custom back button
	UIImage *settingsButtonNormalImage = [UIImage imageNamed:@"btn_Settings.png"];
	UIImage *settingsButtonHighlightImage = [UIImage imageNamed:@"btn_Settings_up.png"];
    
	//create the button and assign the image
	UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[settingsButton setImage:settingsButtonNormalImage forState:UIControlStateNormal];
	[settingsButton setImage:settingsButtonHighlightImage forState:UIControlStateHighlighted];
    
    
	//set the frame of the button to the size of the image (see note below)
	settingsButton.frame = CGRectMake(0, 0, settingsButtonNormalImage.size.width, settingsButtonNormalImage.size.height);
    
	[settingsButton addTarget:self action:@selector(pressSettings:) forControlEvents:UIControlEventTouchUpInside];
    
	//create a UIBarButtonItem with the button as a custom view
	UIBarButtonItem *customSettingsBarItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
	self.navigationItem.rightBarButtonItem = customSettingsBarItem;
    
    MSLabel *titleLabel = [[MSLabel alloc] initWithFrame:CGRectMake(7.0f, 2.0f, 307.0f, 80.0f)];
    titleLabel.text = dataQuestion.questionText;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.lineHeight = 18;
    titleLabel.numberOfLines = 4;
    titleLabel.font = [UIFont fontWithName: @"Comic Sans MS" size:15];
    [self.view addSubview:titleLabel];
    
    questionPoints.text = [NSString stringWithFormat:@"Points: %d", dataQuestion.questionPoints];
    questionPoints.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
    
    NSArray *arrayDate = [[NSString stringWithFormat:@"%@", dataQuestion.questionDate] componentsSeparatedByString:@" "];
    NSString *strDate = @"";
    strDate = [arrayDate objectAtIndex:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateStr = [formatter dateFromString:strDate];;
    
    NSDateFormatter *aformatter = [[NSDateFormatter alloc] init];
    [aformatter setDateFormat:@"MM/dd/yyyy"];
    NSString *newdate = [aformatter stringFromDate:dateStr];;
    
    NSLog(@"strDate %@ dateStr %@ newdate %@", strDate, dateStr, newdate);
    
    questionDate.text = newdate;
    
    questionDate.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
    
    [self getComments];
}

- (void)getComments{
    
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Loading...";
    [self.view addSubview:loadingController.view];
    
    /*
    baseAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                           message:@""
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    [baseAlert show];
    
    
    //Activity indicator
    aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center = CGPointMake(baseAlert.bounds.size.width / 2.0f, baseAlert.bounds.size.height / 1.5f);
    [aiv startAnimating];
    [baseAlert addSubview:aiv];
    */
    
    commentsDataController.questionID = dataQuestion.questionID;
    commentsDataController.pageNumber = [NSString stringWithFormat:@"%d", pageNumber];
    
    [commentsDataController getComments];
    
}


- (void)didFinishLoadingComments
{
    [dataUserLikesController getUserCommentsLikes:dataQuestion.questionID];
}

- (void)didFinishLoadingUserCommentsAllLike
{
    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
    
    dataComments = [commentsDataController objectInListAtIndex:0];
    NSLog(@"dataComments.totalComments %d", [dataComments.totalComments intValue]);
    
    if ([dataComments.totalComments intValue] <= 10)
    {
        btnMore.hidden = YES;
    }
    else
    {
        
        NSLog(@"%d = %d", [dataComments.totalComments intValue], [commentsDataController countOfList]);
        
        if ([dataComments.totalComments intValue] > [commentsDataController countOfList]) {
            btnMore.hidden = NO;
        }
        else
        {
            btnMore.hidden = YES;
        }
        
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalLikes"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [commentsDataController.arrComments sortedArrayUsingDescriptors:sortDescriptors];
    
    
    commentsDataController.arrComments = [NSMutableArray arrayWithArray:sortedArray];
    
    [tblComments reloadData];
    [tblComments setNeedsDisplay];
    
    lblCommentNumber.text = [NSString stringWithFormat:@"%@", dataComments.totalComments];
    
    /*
     if (isLoadMore == YES) {
     if (tblComments.contentSize.height > tblComments.frame.size.height)
     {
     CGPoint offset = CGPointMake(0, tblComments.contentSize.height -  tblComments.frame.size.height);
     [tblComments setContentOffset:offset animated:YES];
     }
     }
     */
    
    pageNumber++;
}

- (void)performDismiss
{
    [loadingController.view removeFromSuperview];
    
    if (baseAlert != nil)
    {
        [aiv stopAnimating];
        [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
        baseAlert = nil;
    }
}

- (void)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressSettings:(id)sender
{
    predixerSettingsViewControllerViewController *settings = [[predixerSettingsViewControllerViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    if ([commentsDataController countOfList] != 0)
    {
        rows = [commentsDataController countOfList];
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
    
    NSString *text = dataComments.comment;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode: NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    
    NSLog(@"height %f", height + (CELL_CONTENT_MARGIN * 2));
    
    [arrLineHeight addObject:[NSString stringWithFormat:@"%f", height + (CELL_CONTENT_MARGIN * 2)]];
    
    return height + (CELL_CONTENT_MARGIN * 2) + 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
    }
    
    // Configure the cell...
    //REMOVE ALL CELL SUB-VIEWS FIRST
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    MSLabel *label = nil;
    UIView *vwCommentFooter = nil;
    NSString *strLineHeight = nil;
    UILabel *author = nil;
    UILabel *likes = nil;
    UIImageView *vwLike = nil;
    UIButton *btnLike = nil;
    
    strLineHeight = [arrLineHeight objectAtIndex:indexPath.row];
    
    label = [[MSLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setMinimumFontSize:FONT_SIZE];
    [label setNumberOfLines:0];
    label.lineHeight = 16.5;
    [label setFont: [UIFont fontWithName: @"Comic Sans MS" size:FONT_SIZE]];
    [label setTag:1];
    
    
    vwCommentFooter = [[UIView alloc] init];
    vwCommentFooter.frame = CGRectMake(0.0f, [strLineHeight floatValue], 299.0f, 25.0f);
    vwCommentFooter.backgroundColor = [UIColor colorWithRed:0.223f green:0.709f blue:0.290f alpha:1.0f];

    
    author = [[UILabel alloc] init];
    author.frame = CGRectMake(4.0f, 2.0f, 185.0f, 20.0f);
    author.font = [UIFont fontWithName: @"Comic Sans MS" size:12];
    author.backgroundColor = [UIColor clearColor];
    author.textColor = [UIColor whiteColor];
    [vwCommentFooter addSubview:author];
    
    vwLike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkd_Like.png"]];
    vwLike.frame = CGRectMake(250.0f, 4.0f, 15.0f, 14.0f);
    [vwCommentFooter addSubview:vwLike];
    
    
    btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgDwn = [UIImage imageNamed:@"btn_Like_C_Dwn.png"];
    UIImage *imgUp = [UIImage imageNamed:@"btn_Like_C_UP.png"];
    btnLike.frame = CGRectMake(185.0f, 1.0f, 58.0f, 22.0f);
    [btnLike setImage:imgDwn forState:UIControlStateNormal];
    [btnLike setImage:imgUp forState:UIControlStateHighlighted];
    [btnLike setImage:imgUp forState:UIControlStateSelected];
    [btnLike addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [vwCommentFooter addSubview:btnLike];
    
    
    likes = [[UILabel alloc] init];
    likes.frame = CGRectMake(268.0f, 2.0f, 40.0f, 20.0f);
    likes.font = [UIFont fontWithName: @"Comic Sans MS" size:12];
    likes.backgroundColor = [UIColor clearColor];
    likes.textColor = [UIColor whiteColor];
    [vwCommentFooter addSubview:likes];
    
    [[cell contentView] addSubview:label];
    [[cell contentView] addSubview:vwCommentFooter];
    
    // Configure the cell...
    if ([commentsDataController countOfList] != 0)
    {
        dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
        
        NSLog(@"dataComments.comment %@", dataComments.comment);
        NSLog(@"commentID %@", dataComments.commentID);
        
        NSString *text = dataComments.comment;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
  
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        if (!label)
            label = (MSLabel*)[cell viewWithTag:1];
        
        [label setText:text];
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
        
        
        if ([dataComments.totalLikes length] > 0) {
            likes.text = dataComments.totalLikes;
            //likes.text = @"1000";
        }
        else{
            likes.text = @"0";
        }
        
        NSLog(@"date %@", dataComments.commentDate);
        
        NSArray *arrayDate = [dataComments.commentDate componentsSeparatedByString:@" "];
        
        NSString *strHour = @"";
        NSString *strMin = @"";
        NSString *strDay = @"";
        NSString *strDate = @"";
        
        strDate = [arrayDate objectAtIndex:0];
        
        for (int i=0; i < [arrayDate count]; i++) {
            
            NSLog(@" arrayDate %@",[arrayDate objectAtIndex:i]);
            
            if (i == 1) {
                NSLog(@" time %@",[arrayDate objectAtIndex:i]);
                
                NSArray *arrayTime = [[arrayDate objectAtIndex:i] componentsSeparatedByString:@":"];
                
                for (int j=0; j < [arrayTime count]; j++) {
                    
                    if (j==0) {
                        strHour = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                    }
                    else if (j==1) {
                        strMin = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                    }
                }
            }
            else if (i == 2) {
                strDay = [NSString stringWithFormat:@"%@", [arrayDate objectAtIndex:i]];
            }
        }
        
        NSLog(@" answerTime %@:%@ %@ %@", strHour, strMin, strDay, strDate);
        
        author.text = [NSString stringWithFormat:@"%@ at %@:%@ %@", dataComments.fbName, strHour, strMin, strDay] ;
        
        btnLike.tag = [dataComments.commentID intValue];
        
        /*
        if (userDidLike == YES && btnLike.tag == likeIndex) {
            btnLike.hidden = YES;
        }*/
        
        for (NSString *strLikeID in arrLikes) {
            
            if ([strLikeID intValue] == btnLike.tag) {
                btnLike.hidden = YES;
            }
        }
        
        for (DataUserCommentLike *userLikes in dataUserLikesController.arrComments) {
            
            // NSLog(@"userLikes %d = %d", userLikes.commentID, [dataComments.commentID intValue]);
            
            if (userLikes.commentID == [dataComments.commentID intValue]) {
                btnLike.hidden = YES;
            }
        }
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadMore:(id)sender
{   
    isLoadMore = YES;
    
    [arrLineHeight removeAllObjects];
    
    [self getComments];
}

- (void)likeComment:(id)sender
{
 
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Liking...";
    [self.view addSubview:loadingController.view];
    
    /*
    baseAlert = [[UIAlertView alloc] initWithTitle:@"Liking..."
                                           message:@""
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    [baseAlert show];
    
    
    //Activity indicator
    aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center = CGPointMake(baseAlert.bounds.size.width / 2.0f, baseAlert.bounds.size.height / 1.5f);
    [aiv startAnimating];
    [baseAlert addSubview:aiv];
    */
    
    UIButton *btn = (UIButton*)sender;
    
    likeIndex = btn.tag;
    commentsDataController.commentID =  [NSString stringWithFormat:@"%d", btn.tag];
    [commentsDataController likeComment];
    
    userDidLike = YES;
    
    if (likeIndex != 0) {
        [arrLikes addObject:[NSString stringWithFormat:@"%d", likeIndex]];
    }
}


- (void)didFinishLikeComment
{
    [arrLineHeight removeAllObjects];
    
    for (DataComments *comm in commentsDataController.arrComments) {
        
        NSLog(@"likeIndex %@ = %d",comm.commentID, likeIndex);
        
        if ([comm.commentID intValue] == likeIndex) {
            
            int totalLike =  [comm.totalLikes intValue] + 1;
            comm.totalLikes = [NSString stringWithFormat:@"%d", totalLike];
        }
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalLikes"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [commentsDataController.arrComments sortedArrayUsingDescriptors:sortDescriptors];
    
    
    commentsDataController.arrComments = [NSMutableArray arrayWithArray:sortedArray];
    
    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
    
    [tblComments reloadData];
    //[commentsDataController getComments];
}

@end
