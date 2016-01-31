//
//  BZTableFooter.h
//  TestTaskBZ
//
//  Created by Boris Zinkovich on 30.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
* Класс хедера(верхней части) таблицы 
*/
@interface BZTableHeader : UICollectionReusableView
    @property (weak, nonatomic) UILabel* faqLabel;
    @property (weak, nonatomic) UICollectionView* menuCollectionView;
@end
