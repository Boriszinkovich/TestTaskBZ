//
//  ViewController.m
//  TestTaskBZ
//
//  Created by Boris Zinkovich on 27.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZMainViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "BZMenuCellCollectionViewCell.h"
#import "BZCategory.h"
#import "BZQuestion.h"
#import "BZTableCell.h"
#import "BZTableHeader.h"
#import "BZUtils.h"
#import "Masonry.h"
@interface BZMainViewController ()
@property (strong, atomic) NSMutableDictionary* dictionaryWithCategoriesTitlesAndQuestions; // словарь с названиями категорий и массивом вопросов этой категории
@property (strong, nonatomic) NSArray* allCategories; // массив с названиями всех категория
@property (strong, nonatomic) NSString* currentChosedCategory; // текущая выбранная категория
@property (weak, nonatomic) UIButton* currentChosedButton; // текушая выбраная кнопка
@property (weak, nonatomic) UICollectionView* menuCollectionView; // ссылка на колекцию с меню
@property (weak, nonatomic) UICollectionView* tableCollectionView; // ссылка на коллекцию с таблицей вопросов
 // проперти предназначены исключительно для тестов и проверки на правильность верстки
@property (weak, nonatomic) BZMenuCellCollectionViewCell* cell;
@property (weak, nonatomic) BZTableCell* tableCell;
@property (weak, nonatomic) BZTableHeader* header;
@end


static NSString* menuCollectionViewCellIdentifier= @"MenuCollectionViewCellIdentifier";
static NSString* tableCollectionViewCellIdentifier= @"TableCollectionViewCellIdentifier";
static NSString* headerIdentifier = @"HEADER_IDENTIFIER";


@implementation BZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES; // убираем навигейшн бар
    self.currentChosedCategory = @"View All";
    self.dictionaryWithCategoriesTitlesAndQuestions = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [self colorWithHexString:viewBackgroundColor];
    [self generateRandomCategoriesAndQuestions]; // инициализация рандомных категорий и вопросов
    
    //  инициализация таблицы
    CHTCollectionViewWaterfallLayout *tableLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    CGFloat rightPadding = self.view.bounds.size.width - 3*tableCellWidth - leftPadding - 2* tableInterItemSpacing;

    tableLayout.sectionInset = UIEdgeInsetsMake(0, leftPadding, 0, rightPadding);
    tableLayout.minimumInteritemSpacing = tableInterItemSpacing;
    tableLayout.columnCount = 3;
    tableLayout.headerHeight = topTablePadding;
    tableLayout.footerHeight = 0;
    tableLayout.itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight;
    tableLayout.minimumColumnSpacing = tableInterItemSpacing;
    
    UICollectionView* tableCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 500, 500) collectionViewLayout:tableLayout];
    [self.view addSubview:tableCollectionView];
    self.tableCollectionView = tableCollectionView;
    self.tableCollectionView.dataSource = self;
    self.tableCollectionView.delegate = self;
    self.tableCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableCollectionView registerClass:[BZTableHeader class]
                 forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                        withReuseIdentifier:headerIdentifier];
  
    [self createTableCollectionViewConstraints];
    [self.tableCollectionView registerClass:[BZTableCell class] forCellWithReuseIdentifier:tableCollectionViewCellIdentifier];
    self.tableCollectionView.showsVerticalScrollIndicator = NO;
    self.tableCollectionView.backgroundColor = [self colorWithHexString:viewBackgroundColor];
    
    [self.tableCollectionView registerClass:[BZTableHeader class]
                 forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                        withReuseIdentifier:headerIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) createTableCollectionViewConstraints{
    __weak BZMainViewController* weakSelf = self;
    [self.tableCollectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0);
    }];
 }

/*
* функция генерации рандомных категорий и вопросов
*/
- (void) generateRandomCategoriesAndQuestions{
    NSArray* allCategories = [BZCategory MR_findAll];
    NSInteger categoryNumber= 8 + arc4random() % (maxNumberOfCategories - 8); // устанавливаем рандомное количество категорий
    NSInteger counter = 0;
    NSMutableSet* setWithIndexes = [NSMutableSet set];
    NSMutableArray* allQuestionsArray = [NSMutableArray array]; // массив со всема вопросами всех категорий
    while (counter < categoryNumber)
    {
        NSInteger randomEntityIndex = arc4random() % maxNumberOfCategories; // выбираем рандомную категорию
        if (![setWithIndexes containsObject:[NSNumber numberWithInteger:randomEntityIndex]])
        {
            [setWithIndexes addObject:[NSNumber numberWithInteger:randomEntityIndex]];
            NSInteger randomCategoryQuestionsNumber = 1 + arc4random() % (maxNumberOfQuestionsInCategory - 1); // выбираем рандомное количество вопросов для данной категории
            BZCategory* category = [allCategories objectAtIndex:randomEntityIndex];
            NSArray* questions = [[category.questions allObjects] subarrayWithRange:NSMakeRange(0, randomCategoryQuestionsNumber)];
            for (BZQuestion* question in questions)
            {
                question.backgroundImage = [NSNumber numberWithInteger:arc4random() % 3]; //  добавляем картинку к вопросу
            }
            [allQuestionsArray addObjectsFromArray:questions];
            [self.dictionaryWithCategoriesTitlesAndQuestions setObject:questions forKey:category.categoryName];
            counter++;
        }
    }
    self.allCategories = [self.dictionaryWithCategoriesTitlesAndQuestions allKeys];
    [self.dictionaryWithCategoriesTitlesAndQuestions setObject:allQuestionsArray forKey:@"View All"];
    
}

/*
* функция получения цвета из строки с цветом в формате hex
*/
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
/*
* функция, которая обрабатывает нажатие кнопки менюшки
*/
- (void) buttonClicked:(UIButton*) button{
    if ([button isEqual:self.currentChosedButton]) return;
    if (self.menuCollectionView.isDragging || self.menuCollectionView.isDecelerating) return;
    NSLog(@"clicked with Title: %@",button.titleLabel.text);
    [button setSelected:YES];
    [self.currentChosedButton setSelected:NO];
    self.currentChosedButton = button;
    self.currentChosedCategory = self.currentChosedButton.titleLabel.text;
    [self methodForTestingLayoutsMetrics];
    [self.tableCollectionView reloadData];
}

/*
* функция получения картинки по номеру
*/
- (UIImage*) backgroundImageForNumber:(NSInteger) number{
    UIImage* image;
    switch (number) {
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

#pragma mark  - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.menuCollectionView])
    {
        return (1 + [self.allCategories count]);
    }

    NSArray* questions;
    questions =  [self.dictionaryWithCategoriesTitlesAndQuestions objectForKey:self.currentChosedCategory];
    return [questions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if ([collectionView isEqual:self.menuCollectionView]){
        //  инициализируем ячейку меню
        BZMenuCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:menuCollectionViewCellIdentifier forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[BZMenuCellCollectionViewCell alloc] init];
        }
        cell.contentView.backgroundColor = [self colorWithHexString:viewBackgroundColor];
        UIButton* button = cell.button;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        NSString* text = @"View All";
        if (indexPath.row > 0) text = [self.allCategories objectAtIndex:indexPath.row - 1];
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitle:text forState:UIControlStateSelected];
        if ([button.titleLabel.text isEqual:self.currentChosedCategory]){
            [button setSelected:YES];
            self.currentChosedButton = button;
        }
        else [button setSelected:NO];
        [button setTitleColor:[self colorWithHexString:buttonTextColorForNormalState] forState:UIControlStateNormal];
        [button setTitleColor:[self colorWithHexString:buttonTextColorForSelectedState] forState:UIControlStateSelected];
        [button  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(0);
            make.left.equalTo(cell.contentView.mas_left).with.offset(0);
        }];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        self.cell = cell;  // для тестов
        return cell;
    }
    // инициализируем ячейку таблицы
    BZTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tableCollectionViewCellIdentifier forIndexPath:indexPath];
    UIImageView* imageView = cell.backgroundImage;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* views = @{@"imageView":imageView};
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|"  options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|"  options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    UILabel* label = cell.questionLabel;
    label.numberOfLines = 0;
    label.font =  [UIFont fontWithName:contentFontName size:contentTextSize];
    label.textColor = [self colorWithHexString:contentColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton* sectionButton = cell.closeButton;
    sectionButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* text = @"View All";
    if (self.currentChosedButton != nil) text = self.currentChosedButton.titleLabel.text;
    NSArray* questions =  [self.dictionaryWithCategoriesTitlesAndQuestions objectForKey:text];
    if ([questions count] < indexPath.row + 1) return cell;
    imageView.image = [self backgroundImageForNumber:[((BZQuestion*)[questions objectAtIndex:indexPath.row]).backgroundImage integerValue]];
    label.text = ((BZQuestion*)[questions objectAtIndex:indexPath.row]).questionText;
    NSLayoutConstraint *centerXLabel = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [cell.contentView addConstraint:centerXLabel];
    NSDictionary* views2 = @{@"label":label, @"addButton": sectionButton};
    NSDictionary* metrics = @{@"cellLabelTopPadding":[NSNumber numberWithInteger:cellLabelTopPadding], @"cellLabelBottomPadding": [NSNumber numberWithInteger:cellLabelBottomPadding], @"cellButtonBottomPadding" : [NSNumber numberWithInteger:cellButtonBottomPadding]};
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-cellLabelTopPadding-[label]-cellLabelBottomPadding-[addButton]-cellButtonBottomPadding-|"  options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views2]];
     NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:0 constant:contentMaxWidth];
    [label addConstraint:widthConstraint];
    self.tableCell = cell;  // для тестов
    return cell;
}
/*
* метод в котором инициализируем вьюху для хедера таблицы с faqlabel  и менюшкой
*/
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    
    BZTableHeader*  reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                      withReuseIdentifier:headerIdentifier
                                                                             forIndexPath:indexPath];
    UILabel* label = reusableView.faqLabel;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:reusableView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:leftPadding];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:reusableView attribute:NSLayoutAttributeTop multiplier:1.0f constant:topFaqsPadding];
    self.header = reusableView;
    [reusableView addConstraint:leftConstraint];
    [reusableView addConstraint:bottomConstraint];
    
    UICollectionView* colView = reusableView.menuCollectionView;
    colView.backgroundColor = [self colorWithHexString:viewBackgroundColor];
    colView.delegate = self;
    colView.dataSource = self;
    colView.translatesAutoresizingMaskIntoConstraints = NO;
    [colView registerClass:[BZMenuCellCollectionViewCell class] forCellWithReuseIdentifier:menuCollectionViewCellIdentifier];
    colView.showsHorizontalScrollIndicator = YES;
    CGSize textSize = [@"View All" sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:contentFontName size:buttonsTextSize] }];
    [colView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reusableView.mas_top).with.offset(topMenuPadding - textSize.height - 8.5);
        make.left.equalTo(reusableView.mas_left).with.offset(0);
        make.height.mas_equalTo(topTablePadding - topMenuPadding + textSize.height + 8.5);
        make.right.equalTo(reusableView.mas_right).with.offset(0);
    }];
    self.menuCollectionView = colView;
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.menuCollectionView]){
        NSString* text = @"View All";
        if (indexPath.row > 0) text = [self.allCategories objectAtIndex:indexPath.row - 1];
        CGSize textSize = [text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:buttonFontName size:buttonsTextSize] }];
        return CGSizeMake(textSize.width, topTablePadding - topMenuPadding + textSize.height -2 );
    }
    UIImage* closeImage = [UIImage imageNamed:@"close.png"];
    NSArray* questions =  [self.dictionaryWithCategoriesTitlesAndQuestions objectForKey:self.currentChosedCategory];
    NSString* questionText = ((BZQuestion*)[questions objectAtIndex:indexPath.row]).questionText;
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:contentFontName size:contentTextSize], NSFontAttributeName,nil];
    CGRect textRect = [questionText boundingRectWithSize:CGSizeMake(contentMaxWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    CGFloat height = cellButtonBottomPadding + cellLabelBottomPadding + cellLabelTopPadding + closeImage.size.height + textRect.size.height;
    return CGSizeMake(tableCellWidth, height);
}
#pragma mark - TestMethod

- (void) methodForTestingLayoutsMetrics{
    NSLog(@"Faq Top Padding: %f", self.header.faqLabel.frame.origin.y + self.header.faqLabel.frame.size.height); //проверка на правильность верхнего отступа faq label от главной вьюхи
    NSLog(@"Menu Top Padding %f", self.menuCollectionView.frame.origin.y+self.cell.frame.origin.y + self.cell.button.frame.origin.y + self.cell.button.titleLabel.frame.origin.y + self.cell.button.titleLabel.frame.size.height);
    NSLog(@"Table Cell Width %f",self.tableCell.frame.size.width);
    NSLog(@"Table cell Top Padding %f", self.header.frame.origin.y + self.tableCell.frame.origin.y);
    NSLog(@"Question content Width %f",self.tableCell.questionLabel.frame.size.width);
    NSLog(@"Question content Top Padding %f", self.tableCell.questionLabel.frame.origin.y);
    NSLog(@"From question content to button inset %f",self.tableCell.closeButton.frame.origin.y - (self.tableCell.questionLabel.frame.origin.y + self.tableCell.questionLabel.frame.size.height));
    NSLog(@"From question content to button inset %f",self.tableCell.closeButton.frame.origin.y - (self.tableCell.questionLabel.frame.origin.y + self.tableCell.questionLabel.frame.size.height));
     NSLog(@"From button to cell bottom inset %f",self.tableCell.frame.size.height - (self.tableCell.closeButton.frame.origin.y + self.tableCell.closeButton.frame.size.height));
}
@end
