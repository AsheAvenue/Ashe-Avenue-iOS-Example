//
//  Gallery.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface Gallery : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSString *curatorId;
@property (nonatomic, retain) IBOutlet UILabel *curatorNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *curatorButton;
@property (nonatomic, retain) IBOutlet UILabel *secondaryTextLabel;
@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

-(IBAction)handleCuratorButton:(id)sender;
-(IBAction)swipeRight:(UISwipeGestureRecognizer *)UISwipeGestureRecognizer;
-(IBAction)swipeLeft:(UISwipeGestureRecognizer *)UISwipeGestureRecognizer;

@end
