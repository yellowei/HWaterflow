//
//  WaterFlowLayout.h
//  HWWaterFlowDemo
//
//  Created by yellowei on 16/1/18.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;
@protocol WaterFlowLayoutDelegate <NSObject>

@required
//传自己的高或宽，是为了比例
- (CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout widthForHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGSize)waterFlowLayout:(WaterFlowLayout*)waterFlowLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (CGSize)waterFlowLayout:(WaterFlowLayout*)waterFlowLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface WaterFlowLayout : UICollectionViewFlowLayout

@property(nonatomic,assign)UIEdgeInsets sectionInsets;
//行列间距
@property(nonatomic,assign)CGFloat rowMargin;
@property(nonatomic,assign)CGFloat colMargin;
//多少行,多少列, 取决于方向, 不同时设置
@property(nonatomic,assign)NSInteger columnCount;
@property (nonatomic, assign)NSInteger rowCount;
//多组的时候用到, 不同时设置, 取决于方向
@property (nonatomic, strong) NSArray * columnForSections;
@property (nonatomic, strong) NSArray * rowForSections;
//是否使用header, footer
@property (nonatomic, assign) BOOL useHeader;
@property (nonatomic, assign) BOOL useFooter;
@property(nonatomic,weak)id<WaterFlowLayoutDelegate> delegate;

@end


/**
 *  ///////////////////////////LineLayout///////////////////////
 *  //////////////////////////横向直线型布局///////////////////////
 */
@class LineLayout;
@protocol LineLayoutDelegate <NSObject>

@optional
- (CGFloat)lineLayout:(LineLayout*)lineLayout referenceMaxWidthScaleForElementAttributes:(UICollectionViewLayoutAttributes *)attributes;

- (CGFloat)lineLayout:(LineLayout*)lineLayout referenceMaxHeightScaleForElementAttributes:(UICollectionViewLayoutAttributes *)attributes;

@end

@interface LineLayout : UICollectionViewFlowLayout

@property(nonatomic,weak)id<LineLayoutDelegate> delegate;

@end
