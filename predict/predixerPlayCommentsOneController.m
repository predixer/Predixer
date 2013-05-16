//
//  predixerPlayCommentsOneController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/9/12.
//
//

#import "predixerPlayCommentsOneController.h"
#import "DataComments.h"
#import "DataCommentsController.h"
#import "DataUserCommentLike.h"
#import "DataUserCommentLikeController.h"
#import "predixerAppDelegate.h"
#import "DataQuestions.h"
#import "MSLabel.h"
#import "LoadingController.h"

@interface predixerPlayCommentsOneController ()

@end

@implementation predixerPlayCommentsOneController

@synthesize dataComments;
@synthesize commentsDataController;
@synthesize questionID;
@synthesize commentsCount;
@synthesize dataQuestion;
@synthesize dataUserLikes;
@synthesize dataUserLikesController;
@synthesize loadingController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        // Custom initialization
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
        
        nc = [NSNotificationCenter defaultCenter];
        
        
        [nc addObserver:self
               selector:@selector(didFinishLoadingTopComments)
                   name:@"didFinishLoadingTopComments"
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(didFinishLikeComment)
                   name:@"didFinishLikeComment"
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(didFinishLoadingUserCommentsAllLike)
                   name:@"didFinishLoadingUserCommentsAllLike"
                 object:nil];

        
        dataComments = [[DataComments alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingTopComments" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLikeComment" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didFinishLoadingTopComments
{
    dataComments = [commentsDataController objectInListAtIndex:0];
    
    [dataUserLikesController getUserCommentsLikes:questionID];

}

- (void)didFinishLoadingUserCommentsAllLike
{
    [self.tableView reloadData];
    
    [nc postNotificationName:@"didFinishLoadingCommentsToTable" object:nil];
}

- (void)getComments{
    
    commentsDataController.questionID = questionID;
    [commentsDataController getTopComments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [commentsDataController countOfList];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    //REMOVE ALL CELL SUB-VIEWS FIRST
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    MSLabel *label = nil;
    UIView *vwCommentFooter = nil;
    UILabel *author = nil;
    UILabel *likes = nil;
    UIImageView *vwLike = nil;
    UIButton *btnLike = nil;
    
    label = [[MSLabel alloc] initWithFrame:CGRectMake(2.0f, 6.0f, 290.0f, 35.0f)];
    label.backgroundColor = [UIColor clearColor];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setMinimumFontSize:13];
    [label setNumberOfLines:2];
    label.lineHeight = 15;
    [label setFont: [UIFont fontWithName: @"Comic Sans MS" size:13]];
    [label setTag:1];
    
    vwCommentFooter = [[UIView alloc] init];
    vwCommentFooter.frame = CGRectMake(2.0f, 40.0f, 298.0f, 25.0f);
    vwCommentFooter.backgroundColor = [UIColor colorWithRed:0.223f green:0.709f blue:0.290f alpha:1.0f];
    
    author = [[UILabel alloc] init];
    author.frame = CGRectMake(6.0f, 2.0f, 185.0f, 20.0f);
    author.font = [UIFont fontWithName: @"Comic Sans MS" size:12];
    author.backgroundColor = [UIColor clearColor];
    author.textColor = [UIColor whiteColor];
    [vwCommentFooter addSubview:author];
    
    vwLike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkd_Like.png"]];
    vwLike.frame = CGRectMake(250.0f, 4.0f, 15.0f, 14.0f);
    [vwCommentFooter addSubview:vwLike];
    
    likes = [[UILabel alloc] init];
    likes.frame = CGRectMake(268.0f, 2.0f, 40.0f, 20.0f);
    likes.font = [UIFont fontWithName: @"Comic Sans MS" size:12];
    likes.backgroundColor = [UIColor clearColor];
    likes.textColor = [UIColor whiteColor];
    [vwCommentFooter addSubview:likes];
    
    btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgDwn = [UIImage imageNamed:@"btn_Like_C_Dwn.png"];
    UIImage *imgUp = [UIImage imageNamed:@"btn_Like_C_UP.png"];
    btnLike.frame = CGRectMake(185.0f, 1.0f, 58.0f, 22.0f);
    [btnLike setImage:imgDwn forState:UIControlStateNormal];
    [btnLike setImage:imgUp forState:UIControlStateHighlighted];
    [btnLike setImage:imgUp forState:UIControlStateSelected];
    [btnLike addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [vwCommentFooter addSubview:btnLike];
    
     [[cell contentView] addSubview:label];
    [[cell contentView] addSubview:vwCommentFooter];
    
    // Configure the cell...
    if ([commentsDataController countOfList] != 0)
    {
        dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
        
        NSLog(@"dataComments.comment %@", dataComments.comment);
        NSLog(@"commentID %@", dataComments.commentID);
        
        label.text = dataComments.comment;
        
        //cell.textLabel.text = dataComments.comment;
        //cell.textLabel.numberOfLines = 2;
        //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        //cell.textLabel.font = [UIFont fontWithName: @"Comic Sans MS" size:14];
        
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
        
        if (userDidLike == YES) {
            btnLike.hidden = YES;
        }
        
        for (DataUserCommentLike *userLikes in dataUserLikesController.arrComments) {
            
            //NSLog(@"userLikes %d = %d", userLikes.commentID, [dataComments.commentID intValue]);
            
            if (userLikes.commentID == [dataComments.commentID intValue]) {
                btnLike.hidden = YES;
            }
        }
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)likeComment:(id)sender
{
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Logging In...";
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
}

- (void)didFinishLikeComment
{
    
    for (DataComments *comm in commentsDataController.arrComments) {
        
        NSLog(@"likeIndex %@ = %d",comm.commentID, likeIndex);
        
        if ([comm.commentID intValue] == likeIndex) {
            
            int totalLike =  [comm.totalLikes intValue] + 1;
            comm.totalLikes = [NSString stringWithFormat:@"%d", totalLike];
        }
    }
    
    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
    [self.tableView reloadData];
    
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


@end
