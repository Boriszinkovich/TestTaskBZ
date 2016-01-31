//
//  BZTableCell.m
//  TestTaskBZ
//
//  Created by Boris Zinkovich on 28.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZTableCell.h"

@implementation BZTableCell
- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self){
        if (self.backgroundImage == nil){
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 4;
        imageView.image = [self randomBackgroundImage];
        [self.contentView addSubview:imageView];
        self.backgroundImage = imageView;
        UILabel* questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:questionLabel];
        self.questionLabel = questionLabel;
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:button];
        [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        self.closeButton = button;
        }
    }
    return self;
}

- (UIImage*) randomBackgroundImage{
    NSInteger randomNumber = arc4random()%3;
    UIImage* image;
    switch (randomNumber) {
        case 0:
            image = [UIImage imageNamed:@"background_black"];
            break;
        case 1:
            image = [UIImage imageNamed:@"background_gray"];
            break;
        default:
            image = [UIImage imageNamed:@"background_orange"];
            break;
    }
    return image;
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    
}

@end
