//
//  predixerViewControllerImageViewer.h
//  predict
//
//  Created by Joel R Ballesteros on 1/16/13.
//
//

#import <UIKit/UIKit.h>

@class DataAddImageView;

@interface predixerViewControllerImageViewer : UIViewController <UIScrollViewDelegate, UITextViewDelegate> {
    
    IBOutlet UIButton *btnClose;
    IBOutlet UIImageView *vwImage;
    IBOutlet UIView *vwTextView;
    IBOutlet UITextView *vwTextData;
    IBOutlet UIButton *btnGoToWeb;
    IBOutlet UIButton *btnFlipMe;
    IBOutlet UIScrollView  *svwImage;
    
    DataAddImageView *dataImageView;
    
    UITextView *vwText;
    UIButton *btnGoTo;
    UIImageView *vwTextImage;
    UIScrollView *scrollImageView;
    
    NSString *strURL;
    NSString *strDesc;
    NSString *strLink;
    NSString *imgURL;
    NSString *imgID;
    
    NSNotificationCenter *nc;
    
}

@property(nonatomic, strong)NSString *imgURL;
@property(nonatomic, strong)NSString *strDesc;
@property(nonatomic, strong)NSString *strLink;
@property(nonatomic, strong)NSString *strURL;
@property(nonatomic, strong)NSString *imgID;
@property(nonatomic, strong)IBOutlet UITextView *vwTextData;
@property (strong, nonatomic)DataAddImageView *dataImageView;
@property(nonatomic, strong)UITextView *vwText;

- (id)init:(NSString *)url description:(NSString *)desc link:(NSString *)aLink imgID:(NSString *)aImgID;
- (IBAction)closeView:(id)sender;
- (void)setImage:(NSString *)url description:(NSString *)desc link:(NSString *)aLink;
- (IBAction)gotoWeb:(id)sender;
- (IBAction)flipMe:(id)sender;

@end
