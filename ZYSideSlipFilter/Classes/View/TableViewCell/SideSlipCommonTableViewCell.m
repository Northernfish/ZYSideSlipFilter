//
//  SideSlipCommonTableViewCell.m
//  ZYSideSlipFilter
//
//  Created by zhiyi on 16/10/14.
//  Copyright © 2016年 zhiyi. All rights reserved.
//

#import "SideSlipCommonTableViewCell.h"
#import "FilterCommonCollectionViewCell.h"
#import "UIView+Utils.h"
#import "CommonItemModel.h"

#define LINE_SPACE_COLLECTION_ITEM 8
#define GAP_COLLECTION_ITEM 8
#define NUM_OF_ITEM_ONCE_ROW 3
#define ITEM_WIDTH ((self.frame.size.width - (NUM_OF_ITEM_ONCE_ROW+1)*GAP_COLLECTION_ITEM)/NUM_OF_ITEM_ONCE_ROW)
#define ITEM_HEIGHT 25

const int BRIEF_ROW = 2;

@interface SideSlipCommonTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *controlIcon;
@property (weak, nonatomic) IBOutlet UILabel *controlLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (strong, nonatomic) ZYSideSlipFilterItemModel *itemModel;
@end

@implementation SideSlipCommonTableViewCell
+ (NSString *)cellReuseIdentifier {
    return @"SideSlipCommonTableViewCell";
}

+ (instancetype)createCell {
    SideSlipCommonTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SideSlipCommonTableViewCell" owner:nil options:nil][0];
    cell.mainCollectionView.delegate = cell;
    cell.mainCollectionView.dataSource = cell;
    cell.mainCollectionView.contentInset = UIEdgeInsetsMake(0, GAP_COLLECTION_ITEM, 0, GAP_COLLECTION_ITEM);
    [cell.mainCollectionView registerClass:[FilterCommonCollectionViewCell class] forCellWithReuseIdentifier:[FilterCommonCollectionViewCell cellReuseIdentifier]];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateCellWithModel:(ZYSideSlipFilterItemModel **)model {
    self.itemModel = *model;
    //title
    [self.titleLabel setText:_itemModel.dataDict[@"title"]];
    //content
    NSArray *itemsArray = _itemModel.dataDict[@"content"];
    self.dataList = itemsArray;
    [_mainCollectionView reloadData];
    [self fitCollectonViewHeight];
}

//根据数据源个数决定collectionView高度
- (void)fitCollectonViewHeight {
    CGFloat displayNumOfRow;
    if (_itemModel.isShowAll) {
        displayNumOfRow = ceil(_dataList.count/NUM_OF_ITEM_ONCE_ROW);
    } else {
        displayNumOfRow = BRIEF_ROW;
    }
    CGFloat collectionViewHeight = displayNumOfRow*ITEM_HEIGHT + (displayNumOfRow - 1)*LINE_SPACE_COLLECTION_ITEM;
    _collectionViewHeightConstraint.constant = collectionViewHeight;
    [_mainCollectionView updateHeight:collectionViewHeight];
}

- (BOOL)tap2SelectItem:(NSIndexPath *)indexPath {
    NSArray *itemArray = [_itemModel.dataDict objectForKey:@"content"];
    CommonItemModel *model = [itemArray objectAtIndex:indexPath.row];
    model.selected = !model.selected;
    return model.selected;
}

#pragma mark - DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FilterCommonCollectionViewCell cellReuseIdentifier] forIndexPath:indexPath];
    CommonItemModel *model = [_dataList objectAtIndex:indexPath.row];
    [cell updateCellWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LINE_SPACE_COLLECTION_ITEM;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return GAP_COLLECTION_ITEM;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    FilterCommonCollectionViewCell *cell = (FilterCommonCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell tap2SelectItem:[self tap2SelectItem:indexPath]];
}

- (IBAction)clickShowMoreButton:(id)sender {
    _itemModel.isShowAll = !_itemModel.isShowAll;
    [self fitCollectonViewHeight];
    [self.delegate sideSlipTableViewCellNeedsReload:self];
    if (_itemModel.isShowAll) {
//        [UIView animateWithDuration:0.2 animations:^{
//            [_controlIcon setTransform:CGAffineTransformMakeRotation(M_PI)];
//        }];
        NSLog(@"show");
    } else {
//        [UIView animateWithDuration:0.2 animations:^{
//            [_controlIcon setTransform:CGAffineTransformMakeRotation(0)];
//        }];
        NSLog(@"close");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
