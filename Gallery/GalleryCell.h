//
//  GalleryCell.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (assign) int imageId;
@property (nonatomic, retain) NSString *photographerName;
@property (assign) int positionInImageIds;

@end
