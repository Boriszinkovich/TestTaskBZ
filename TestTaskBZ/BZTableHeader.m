//
//  BZTableFooter.m
//  TestTaskBZ
//
//  Created by Boris Zinkovich on 30.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZTableHeader.h"
#import "BZUtils.h"

static NSString* menuCollectionViewCellIdentifier= @"MenuCollectionViewCellIdentifier";
static NSString* tableCollectionViewCellIdentifier= @"TableCollectionViewCellIdentifier";

@implementation BZTableHeader
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (UILabel*)faqLabel{
    if (!_faqLabel){
        UILabel* label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:faqTextSize];
        label.text = @"FAQs";
        label.textColor = [self colorWithHexString:faqHexTextColor];
        [self addSubview:label];
        _faqLabel = label;
      }
    
    return _faqLabel;

}
- (UICollectionView*) menuCollectionView{
    if (!_menuCollectionView)
    {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, leftPadding, 0, leftPadding);
        layout.minimumInteritemSpacing = leftButtonPadding;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView* collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 500, 500) collectionViewLayout:layout];
        [self addSubview:collView];
        _menuCollectionView = collView;
    }
    return _menuCollectionView;
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
