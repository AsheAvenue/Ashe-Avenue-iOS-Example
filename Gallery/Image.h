//
//  Image.h
//  Gallery
//
//  Created by Tim Boisvert on 2/21/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Image : UIViewController <UIScrollViewDelegate>

@property (assign) int imageId;
@property (nonatomic, retain) NSString *curatorId;
@property (nonatomic, retain) NSString *curatorName;
@property (assign) int curatorImageCount;
@property (nonatomic, retain) NSMutableArray *photographerNames;
@property (nonatomic, retain) IBOutlet UILabel *secondaryTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *photographerNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *curatorButton;
@property (nonatomic, retain) IBOutlet UIButton *displayButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *tapCover;

-(IBAction)handleBackButton:(id)sender;
-(IBAction)handleProjectButton:(id)sender;
-(IBAction)handleCuratorButton:(id)sender;

@end
