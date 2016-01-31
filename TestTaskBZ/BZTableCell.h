//
//  BZTableCell.h
//  TestTaskBZ
//
//  Created by Boris Zinkovich on 28.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
* класс ячейки таблицы
*/
@interface BZTableCell : UICollectionViewCell
@property(strong,nonatomic) UIImageView* backgroundImage;
@property(strong,nonatomic) UILabel* questionLabel;
@property(strong,nonatomic) UIButton* closeButton;
@end
