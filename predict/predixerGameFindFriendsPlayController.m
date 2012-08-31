//
//  predixerGameFindFriendsPlayController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerGameFindFriendsPlayController.h"
#import "predixerAppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "facebookAPIViewController.h"

@interface predixerGameFindFriendsPlayController ()
- (void)hideMessage;
- (void)showMessage:(NSString *)message;
- (UIImage *)imageForObject:(NSString *)objectID;
@end

@implementation predixerGameFindFriendsPlayController

@synthesize myData;
@synthesize messageLabel;
@synthesize messageView;
@synthesize sections;

- (id)initWithStyle:(UITableViewStyle)style data:(NSArray *)data
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        // Custom initialization
        self.title = @"Play";
        
        if (nil != data) {
            myData = [[NSMutableArray alloc] initWithArray:data copyItems:YES];
        }
        
        self.navigationItem.title = @"Facebook Friends";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Message Label for showing confirmation and status messages
    CGFloat yLabelViewOffset = self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-30;
    messageView = [[UIView alloc]
                   initWithFrame:CGRectMake(0, yLabelViewOffset, self.view.bounds.size.width, 30)];
    messageView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *messageInsetView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.view.bounds.size.width-1, 28)];
    messageInsetView.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                       green:248.0/255.0
                                                        blue:228.0/255.0
                                                       alpha:1];
    messageLabel = [[UILabel alloc]
                    initWithFrame:CGRectMake(4, 1, self.view.bounds.size.width-10, 26)];
    messageLabel.text = @"";
    messageLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    messageLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                   green:248.0/255.0
                                                    blue:228.0/255.0
                                                   alpha:0.6];
    [messageInsetView addSubview:messageLabel];
    [messageView addSubview:messageInsetView];
    
    messageView.hidden = YES;
    [self.view addSubview:messageView];

    self.sections = [[NSMutableDictionary alloc] init];
    
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"A"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"B"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"C"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"D"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"E"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"F"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"G"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"H"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"I"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"J"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"K"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"L"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"M"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"N"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"O"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"P"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"Q"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"R"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"S"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"T"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"U"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"V"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"W"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"X"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"Y"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"Z"];
    
    // Loop again and sort the books into their respective keys
    for (NSDictionary *dict in self.myData)
    {
        [[self.sections objectForKey:[[dict objectForKey:@"name"] substringToIndex:1]] addObject:dict];
    }    
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }    

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

#pragma mark - Private Methods
/*
 * Helper method to return the picture endpoint for a given Facebook
 * object. Useful for displaying user, friend, or location pictures.
 */
- (UIImage *)imageForObject:(NSString *)objectID {
    // Get the object image
    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];

    return image;
}

/*
 * This method is used to display API confirmation and
 * error messages to the user.
 */
- (void)showMessage:(NSString *)message {
    CGRect labelFrame = messageView.frame;
    labelFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    messageView.frame = labelFrame;
    messageLabel.text = message;
    messageView.hidden = NO;
    
    // Use animation to show the message from the bottom then
    // hide it.
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect labelFrame = messageView.frame;
                         labelFrame.origin.y -= labelFrame.size.height;
                         messageView.frame = labelFrame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:3.0
                                                 options: UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  CGRect labelFrame = messageView.frame;
                                                  labelFrame.origin.y += messageView.frame.size.height;
                                                  messageView.frame = labelFrame;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      messageView.hidden = YES;
                                                      messageLabel.text = @"";
                                                  }
                                              }];
                         }
                     }];
}

/*
 * This method hides the message, only needed if view closed
 * and animation still going on.
 */
- (void)hideMessage {
    messageView.hidden = YES;
    messageLabel.text = @"";
}

/*
 * This method handles any clean up needed if the view
 * is about to disappear.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideMessage];
}

#pragma mark - UITableView Datasource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.sections allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; 
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 60.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor clearColor];
    cell.backgroundColor = color;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24.0f)];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkd_section.png"]];    
    headerImage.frame = CGRectMake(0, 0, tableView.bounds.size.width, 24.0f);
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, headerImage.bounds.size.width, 18)];
    lblHeader.text = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];    
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.backgroundColor = [UIColor clearColor];
    lblHeader.font = [UIFont boldSystemFontOfSize:16];
    
    [headerImage addSubview:lblHeader];
    [headerView addSubview:headerImage];
    
    return headerView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if (indexPath.row >= 0)
    {

        NSDictionary *dict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [dict objectForKey:@"name"];    
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.text = @"Play Now!";
        
        NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
        
        
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    NSDictionary *dict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    facebookAPIViewController *fbApi = [[facebookAPIViewController alloc] init];
    [fbApi apiDialogRequestsSendTarget:[dict objectForKey:@"id"]];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    [self showMessage:@"Checked in successfully"];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}


@end
