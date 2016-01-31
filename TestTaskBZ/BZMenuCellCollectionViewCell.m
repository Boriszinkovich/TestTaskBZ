//
//  MyMenuCellCollectionViewCell.m
//  TestTaskBZ
//
//  Created by Boris Zinkovich on 28.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZMenuCellCollectionViewCell.h"
@implementation BZMenuCellCollectionViewCell
-(UIButton*)button{
    if (!_button){
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:_button];
    }
    
        return _button;

}
@end
