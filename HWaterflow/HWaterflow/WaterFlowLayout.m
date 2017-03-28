//
//  WaterFlowLayout.m
//  HWWaterFlowDemo
//
//  Created by yellowei on 16/1/18.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "WaterFlowLayout.h"

#define COLLECTION_VIEW_WIDTH self.collectionView.frame.size.width
#define COLLECTION_VIEW_HEIGHT self.collectionView.frame.size.height// - 64 - 49
#define SECTION_MARGIN_HEIGHT 10

@interface WaterFlowLayout ()
@property(nonatomic,strong)NSMutableDictionary *ColumnMaxY;
@property (nonatomic, strong) NSMutableDictionary *rowMaxX;
@property(nonatomic,strong)NSMutableArray *attributes;
@property (nonatomic, assign) CGFloat lastMaxY;
@property (nonatomic, assign) CGFloat lastMaxX;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) BOOL isLastItem;

@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;

@end

/**
 说明:方法的调用顺序
 1.init
 2.prepareLayout
 3.layoutAttributesForItemAtIndexPath
 4.layoutAttrituesForElementsInRect
 5.shouldInvalidtaLayoutForBoundsChange
 6.发生滚动的事后返回到第2步
 */


@implementation WaterFlowLayout

/**
 存放所有的布局属性
 */
-(NSMutableArray *)attributes
{
    if(_attributes==nil)
    {
        _attributes=[[NSMutableArray alloc] init];
    }
    return _attributes;
}
/**
 key:   对应列号
 value: 最大y值
 */
-(NSMutableDictionary *)ColumnMaxY
{
    if(_ColumnMaxY==nil)
    {
        _ColumnMaxY=[[NSMutableDictionary alloc]init];
    }
    return _ColumnMaxY;
}

- (NSMutableDictionary *)rowMaxX
{
    if(_rowMaxX == nil)
    {
        _rowMaxX = [[NSMutableDictionary alloc]init];
    }
    return _rowMaxX;
}


#pragma mark-
#pragma mark 1.init
//  1.init
-(instancetype)init{
    if(self=[super init])
    {
        self.lastMaxX = 0;
        self.lastMaxY = 0;
        self.currentSection = -1;
        self.sectionInsets = UIEdgeInsetsMake(0, 0, 40, 0);
        self.rowMargin = 0;
        self.colMargin = 0;
        self.columnCount = 2;
        self.rowCount = 2;
 
    }
    return self;
}


- (void)setUseFooter:(BOOL)useFooter
{
    _useFooter = useFooter;
    
    self.footerReferenceSize = CGSizeMake(kECScreenWidth, 30);
}

- (void)setUseHeader:(BOOL)useHeader
{
    _useHeader = useHeader;
    self.headerReferenceSize = CGSizeMake(kECScreenWidth, 30);
}
/**
 发生滚动的时候,重新计算一遍frame
 显示的边界发生改变就会重新布局
 会重新调用layoutAttributesForElementsInRect
 */

#pragma mark-
#pragma mark 5.shouldInvalidtaLayoutForBoundsChange
/**
 *  该方法有毒,不要配合随机数生成函数乱用YES
 *
 *  @param BOOL <#BOOL description#>
 *
 *  @return <#return value description#>
 */
//  5.shouldInvalidtaLayoutForBoundsChange

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}


/**
 测试每个方法调用次数
 */
//  static int m=1;

#pragma mark-
#pragma mark 2.prepareLayout
//  2.prepareLayout
/**
 每次布局之前的准备这个方法只会调用一次
 */
-(void)prepareLayout
{
    [super prepareLayout];
    
    //2.清空之前的属性数组
    [self.attributes removeAllObjects];
    
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section ++)
    {
        NSInteger count = [self.collectionView numberOfItemsInSection:section];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            //多组分型
            if (self.rowForSections)
            {
                if (self.rowForSections.count - 1 >= section)
                {
                    self.rowCount = [[self.rowForSections objectAtIndex:section] integerValue];
                }
                else
                {
                    self.rowCount = 2;
                }
                
            }
            //1.每次需要重新布局就清空最大Y值,否则会一直累加导致显示不正确
            for(int i=0;i<self.rowCount;++i)
            {
                NSString * rowNO = [NSString stringWithFormat:@"%d",i];
                self.rowMaxX[rowNO] = @(self.sectionInsets.left);
            }
            
            
            for(int i=0;i<count;++i)
            {
                
                if (i == count - 1)
                {
                    _isLastItem = YES;
                }
                else
                {
                    _isLastItem = NO;
                }
                
                UICollectionViewLayoutAttributes *layoutAttributes=[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                //上面一句执行完之后再刷新section, 感知section的变化
                self.currentSection = section;
                
                [self.attributes addObject:layoutAttributes];
            }
        }
        else
        {  
            //多组分型
            if (self.columnForSections)
            {
                if (self.columnForSections.count - 1 >= section)
                {
                    self.columnCount = [[self.columnForSections objectAtIndex:section] integerValue];
                }
                else
                {
                    self.columnCount = 2;
                }
            }
            
            //1.每次需要重新布局就清空最大Y值,否则会一直累加导致显示不正确
            if (self.lastMaxY == 0)
            {
                self.lastMaxY = self.sectionInsets.top;
            }
            for(int i=0;i<self.columnCount;++i)
            {
                NSString *columnNO=[NSString stringWithFormat:@"%d",i];
                self.ColumnMaxY[columnNO] = @(self.lastMaxY);
            }
            
            //header
            UICollectionViewLayoutAttributes * headerLayAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            if (headerLayAttr) {
                [self.attributes addObject:headerLayAttr];
            }
            
            
            //items
            for(int i = 0; i < count; ++i)
            {
                if (i == count - 1)
                {
                    _isLastItem = YES;
                }
                else
                {
                    _isLastItem = NO;
                }
                
                UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                //上面一句执行完之后再刷新section, 感知section的变化
                self.currentSection = section;
                
                self.headerSize = CGSizeZero;
                self.footerSize = CGSizeZero;
                
                [self.attributes addObject:layoutAttributes];
            }
            
            //footer
            UICollectionViewLayoutAttributes * footerLayAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            if (footerLayAttr) {
                [self.attributes addObject:footerLayAttr];
            }

        }
        
    }
    
    
    
    
}

//布局前的准备会调用这个方法
/*
 -(void)prepareLayout{
 [super prepareLayout];
 //演示方便 我们设置为静态的2列
 //计算每一个item的宽度
 float WIDTH = ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.minimumInteritemSpacing)/2;
 //定义数组保存每一列的高度
 //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
 CGFloat colHight[2]={self.sectionInset.top,self.sectionInset.bottom};
 //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
 for (int i=0; i<_itemCount; i++) {
 //设置每个item的位置等相关属性
 NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
 //创建一个布局属性类，通过indexPath来创建
 UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
 //随机一个高度 在40——190之间
 CGFloat hight = arc4random()%150+40;
 //哪一列高度小 则放到那一列下面
 //标记最短的列
 int width=0;
 if (colHight[0]<colHight[1]) {
 //将新的item高度加入到短的一列
 colHight[0] = colHight[0]+hight+self.minimumLineSpacing;
 width=0;
 }else{
 colHight[1] = colHight[1]+hight+self.minimumLineSpacing;
 width=1;
 }
 
 //设置item的位置
 attris.frame = CGRectMake(self.sectionInset.left+(self.minimumInteritemSpacing+WIDTH)*width, colHight[width]-hight-self.minimumLineSpacing, WIDTH, hight);
 [_attributeAttay addObject:attris];
 }
 
 //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
 if (colHight[0]>colHight[1]) {
 self.itemSize = CGSizeMake(WIDTH, (colHight[0]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
 }else{
 self.itemSize = CGSizeMake(WIDTH, (colHight[1]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
 }
 
 }
 */
#pragma mark-
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = nil;
    if (_useHeader && [elementKind isEqualToString:UICollectionElementKindSectionHeader])
    {
        attrs  = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
    
    if (_useFooter && [elementKind isEqualToString:UICollectionElementKindSectionFooter])
    {
        attrs  = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }

    
    
    CGFloat width = 0.f;
    CGFloat height = 0.f;
    CGFloat y = 0.f;
    CGFloat x = 0.f;
    
    __block NSString *minRow = @"0";
    __block NSString *maxRow = @"0";
    
    __block NSString * minColumn = @"0";
    __block NSString * maxColumn = @"0";
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        if (self.currentSection < indexPath.section)
        {
            
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
            {
                
                for (int i = 0; i < self.ColumnMaxY.allKeys.count; i ++)
                {
                    NSString * rowNum = [NSString stringWithFormat:@"%d",i];
                    NSNumber * maxX = self.rowMaxX[rowNum];
                    
                    if( [maxX floatValue] < [self.rowMaxX[minRow] floatValue])
                    {
                        minRow = rowNum;
                    }
                    
                    if( [maxX floatValue] >= [self.rowMaxX[maxRow] floatValue])
                    {
                        maxRow = rowNum;
                    }
                }
                
//                [self.rowMaxX enumerateKeysAndObjectsUsingBlock:^(NSString *rowNum, NSNumber *maxX, BOOL * _Nonnull stop) {
//                    if( [maxX floatValue] < [self.rowMaxX[minRow] floatValue])
//                    {
//                        minRow = rowNum;
//                    }
//                    
//                    if( [maxX floatValue] >= [self.rowMaxX[maxRow] floatValue])
//                    {
//                        maxRow = rowNum;
//                    }
//                }];
                
                width = self.headerSize.width;
                height = COLLECTION_VIEW_WIDTH - self.sectionInsets.top - self.sectionInsets.bottom;
                x = [self.rowMaxX[maxRow] floatValue] + self.colMargin;
                y = self.sectionInsets.top;
                
                //判断是否换行换列, 是,才改变y或x
                if (self.currentSection < indexPath.section)
                {
                    NSArray * allkeys = [self.rowMaxX allKeys];
                    
                    for (int i = 0; i < allkeys.count; i++)
                    {
                        //处理每一行列header和footer的size
                        if ([self.delegate respondsToSelector:@selector(waterFlowLayout:referenceSizeForHeaderInSection:)])
                        {
                            CGSize headerSize = [self.delegate waterFlowLayout:self referenceSizeForHeaderInSection:self.currentSection + 1];
                            
                            self.headerSize = headerSize;
                            
                            [self.rowMaxX setObject:@(self.lastMaxX + headerSize.width) forKey:[allkeys objectAtIndex:i]];
                        }
                        else
                        {
                            [self.rowMaxX setObject:@(self.lastMaxX) forKey:[allkeys objectAtIndex:i]];
                        }
                        
                    }
                }
                
                
            }
            else
            {
                for (int i = 0; i < self.ColumnMaxY.allKeys.count; i ++)
                {
                    NSString * columnNum = [NSString stringWithFormat:@"%d",i];
                    NSNumber * maxY = self.ColumnMaxY[columnNum];
                    
                    if( [maxY floatValue] < [self.ColumnMaxY[minColumn] floatValue])
                    {
                        minColumn = columnNum;
                    }
                    
                    if( [maxY floatValue] >= [self.ColumnMaxY[maxColumn] floatValue])
                    {
                        maxColumn = columnNum;
                    }
                }
                
//                [self.ColumnMaxY enumerateKeysAndObjectsUsingBlock:^(NSString *columnNum, NSNumber *maxY, BOOL * _Nonnull stop) {
//                    if( [maxY floatValue] < [self.ColumnMaxY[minColumn] floatValue])
//                    {
//                        minColumn = columnNum;
//                    }
//                    
//                    if( [maxY floatValue] >= [self.ColumnMaxY[maxColumn] floatValue])
//                    {
//                        maxColumn = columnNum;
//                    }
//                }];
                
                width = COLLECTION_VIEW_WIDTH - self.sectionInsets.left - self.sectionInsets.right;
                height = self.headerSize.height;
                x = self.sectionInsets.left;
                y = [self.ColumnMaxY[maxColumn] floatValue] + self.rowMargin;
                
                //判断是否换行换列, 是,才改变y或x
                if (self.currentSection < indexPath.section)
                {
                    NSArray * allkeys = [self.ColumnMaxY allKeys];
                    
                    for (int i = 0; i < allkeys.count; i++)
                    {
                        //处理每一行列header和footer的size
                        if ([self.delegate respondsToSelector:@selector(waterFlowLayout:referenceSizeForHeaderInSection:)])
                        {
                            CGSize headerSize = [self.delegate waterFlowLayout:self referenceSizeForHeaderInSection:self.currentSection + 1];
                            
                            self.headerSize = headerSize;
                            
                            [self.ColumnMaxY setObject:@(self.lastMaxY + headerSize.height) forKey:[allkeys objectAtIndex:i]];
                        }
                        else
                        {
                            [self.ColumnMaxY setObject:@(self.lastMaxY) forKey:[allkeys objectAtIndex:i]];
                        }
                        
                    }
                }
                
                
            }
        }
    }
    else// if ([elementKind isEqualToString:UICollectionElementKindSectionFooter])
    {
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            if ([self.delegate respondsToSelector:@selector(waterFlowLayout:referenceSizeForFooterInSection:)])
            {
                CGSize footerSize = [self.delegate waterFlowLayout:self referenceSizeForFooterInSection:indexPath.section];
                
                self.footerSize = footerSize;
                
                self.rowMaxX[maxRow] = @(footerSize.width + [self.rowMaxX[maxRow] floatValue]);
                self.lastMaxX += footerSize.width;
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(waterFlowLayout:referenceSizeForFooterInSection:)])
            {
                CGSize footerSize = [self.delegate waterFlowLayout:self referenceSizeForFooterInSection:indexPath.section];
                
                self.footerSize = footerSize;
                
                width = COLLECTION_VIEW_WIDTH - self.sectionInsets.left - self.sectionInsets.right;
                height = self.footerSize.height;
                x = self.sectionInsets.left;
                y = [self.ColumnMaxY[maxColumn] floatValue] + self.rowMargin;
                
                self.ColumnMaxY[maxColumn] = @(footerSize.height + [self.ColumnMaxY[maxColumn] floatValue]);
                self.lastMaxY += footerSize.height;
                
            }
            else
            {
                self.ColumnMaxY[maxColumn] = @([self.ColumnMaxY[maxColumn] floatValue]);
                
                width = COLLECTION_VIEW_WIDTH - self.sectionInsets.left - self.sectionInsets.right;
                height = self.footerSize.height;
                x = self.sectionInsets.left;
                y = [self.ColumnMaxY[maxColumn] floatValue] + self.rowMargin;
            }
        }
    }
    
    
    
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

#pragma mark 3.layoutAttributesForItemAtIndexPath
//  3.layoutAttributesForItemAtIndexPath
/**
 每一个item的属性
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attrs = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    CGFloat width = 0.f;
    CGFloat height = 0.f;
    CGFloat y = 0.f;
    CGFloat x = 0.f;
    
    
   

    __block NSString *minRow = @"0";
    __block NSString *maxRow = @"0";
    
    __block NSString * minColumn = @"0";
    __block NSString * maxColumn = @"0";
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {

        /**
         *  找出最短的那一列,因为下一个collectionViewCell要放在那一列
         *  @param columnNum 列号
         *  @param height    对应列号的高度
         */
        for (int i = 0; i < self.rowMaxX.allKeys.count; i ++)
        {
            NSString * rowNum = [NSString stringWithFormat:@"%d",i];
            NSNumber * maxX = self.rowMaxX[rowNum];
            
            if( [maxX floatValue] < [self.rowMaxX[minRow] floatValue])
            {
                minRow = rowNum;
            }
            
            if( [maxX floatValue] >= [self.rowMaxX[maxRow] floatValue])
            {
                maxRow = rowNum;
            }
        }

//        [self.rowMaxX enumerateKeysAndObjectsUsingBlock:^(NSString *rowNum, NSNumber *maxX, BOOL * _Nonnull stop)
//         {
//             if( [maxX floatValue] < [self.rowMaxX[minRow] floatValue])
//             {
//                 minRow = rowNum;
//             }
//             
//             if( [maxX floatValue] >= [self.rowMaxX[maxRow] floatValue])
//             {
//                 maxRow = rowNum;
//             }
//         }];
        
        /**
         *  计算尺寸
         *  param  width
         *  param  height
         */
        height = ((COLLECTION_VIEW_HEIGHT - self.sectionInsets.top - self.sectionInsets.bottom -(self.rowCount -1)* self.rowMargin)) / self.rowCount ;
        /**
         要知道对应的indexPath的高度
         为了降低耦合性,采取代理的方式
         */
        width = [self.delegate waterFlowLayout:self widthForHeight:height atIndexPath:indexPath];
        /**
         *  计算位置
         *   x
         *   y
         */
        y = self.sectionInsets.top + (height + self.rowMargin) * [minRow intValue];
        x = [self.rowMaxX[minRow] floatValue] + self.colMargin;
        if (self.rowCount == 1)
        {
            y = self.sectionInsets.top;
            x = [self.rowMaxX[maxRow] floatValue] + self.rowMargin;
        }
        
        /**
         *  更新这一行的宽度
         */
        self.rowMaxX[minRow] = @(x+width);
        if (self.rowCount == 1)
        {
            self.rowMaxX[maxRow] = @(x+width);
        }
 
        //获取新section开始的x或y的坐标
        if (x + width > self.lastMaxX) {
            self.lastMaxX = x + width;
        }
    }
    //垂直滚动
    else
    {
        /**
         *  找出最短的那一列,因为下一个collectionViewCell要放在那一列
         *  @param columnNum 列号
         *  @param height    对应列号的高度
         */
        
        for (int i = 0; i < self.ColumnMaxY.allKeys.count; i ++)
        {
            NSString * columnNum = [NSString stringWithFormat:@"%d",i];
            NSNumber * maxY = self.ColumnMaxY[columnNum];
            
            if( [maxY floatValue] < [self.ColumnMaxY[minColumn] floatValue])
            {
                minColumn = columnNum;
            }
            
            if( [maxY floatValue] >= [self.ColumnMaxY[maxColumn] floatValue])
            {
                maxColumn = columnNum;
            }
        }
//        [self.ColumnMaxY enumerateKeysAndObjectsUsingBlock:^(NSString *columnNum, NSNumber *maxY, BOOL * _Nonnull stop) {
//            if( [maxY floatValue] < [self.ColumnMaxY[minColumn] floatValue])
//            {
//                minColumn = columnNum;
//            }
//            
//            if( [maxY floatValue] >= [self.ColumnMaxY[maxColumn] floatValue])
//            {
//                maxColumn = columnNum;
//            }
//        }];
        
        /**
         *  计算尺寸
         *  param  width
         *  param  height
         */
        width = ((COLLECTION_VIEW_WIDTH - self.sectionInsets.left - self.sectionInsets.right -
                  (self.columnCount -1)* self.rowMargin)) / self.columnCount ;
        /**
         要知道对应的indexPath的高度
         为了降低耦合性,采取代理的方式
         */
        height=[self.delegate waterFlowLayout:self heightForWidth:width atIndexPath:indexPath];
        /**
         *  计算位置
         *   x
         *   y
         */
        x = self.sectionInsets.left + (width + self.colMargin)* [minColumn intValue];
        y = [self.ColumnMaxY[minColumn] floatValue] + self.rowMargin;
        //一列的情况
        if (self.columnCount == 1)
        {
            x = self.sectionInsets.left;
            y = [self.ColumnMaxY[maxColumn] floatValue] + self.rowMargin;
        }
        
        /**
         *  更新这一列的高度
         */
        self.ColumnMaxY[minColumn] = @(y+height);
        if (self.columnCount == 1)
        {
            self.ColumnMaxY[maxColumn] = @(y+height);
        }
       
        //获取新section开始的x或y的坐标
        if ( y + height > self.lastMaxY) {
            self.lastMaxY = y + height;
        }
    }
    
 
    //最后一个判断是否需要添加footer的高度
    if (_isLastItem)
    {
       
        
    }

    
//    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    
    
    
    return attrs;
}

#pragma mark-
#pragma mark 4.layoutAttributesForElementsInRect
//  4.layoutAttributesForElementsInRect
/**
 返回每一个cell的属性
 改变cell的属性就改变cell的展示
 每一个cell对应一个indexPath
 对应一个layoutAttributes
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    [super layoutAttributesForElementsInRect:rect];
    return self.attributes;
}


#pragma mark-
#pragma mark 5.collectionViewContentSize
//  5.collectionViewContentSize
-(CGSize)collectionViewContentSize
{
    [super collectionViewContentSize];
    
    __block NSString *maxColumn = @"0";
    __block NSString *maxRow = @"0";
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        [self.rowMaxX enumerateKeysAndObjectsUsingBlock:^(NSString *rowNum, NSNumber *maxX, BOOL * _Nonnull stop) {
            if( [maxX floatValue] > [self.ColumnMaxY[maxRow] floatValue]){
                maxColumn = rowNum;
            }
        }];
        return CGSizeMake([self.rowMaxX[maxRow] floatValue]+ self.sectionInsets.left, 0);
    }
    else
    {
        
        /** 找出最大的Y值 */
        [self.ColumnMaxY enumerateKeysAndObjectsUsingBlock:^(NSString *columnNum, NSNumber *maxY, BOOL * _Nonnull stop) {
            if( [maxY floatValue] > [self.ColumnMaxY[maxColumn] floatValue]){
                maxColumn = columnNum;
            }
        }];
//        return CGSizeMake(0, [self.ColumnMaxY[maxColumn] floatValue]+ self.sectionInsets.bottom);
                return CGSizeMake(0, [self.ColumnMaxY[maxColumn] floatValue]);
    }
    
}


@end



/**
 *  ///////////////////////////LineLayout///////////////////////
 *  //////////////////////////横向直线型布局///////////////////////
 */
@interface LineLayout ()

@property (nonatomic, assign) CGFloat maxWidthScale;
@property (nonatomic, assign) CGFloat maxHeightScale;

@end

@implementation LineLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.maxWidthScale = 0.0f;
        self.maxHeightScale = 0.0f;
    }
    return self;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置内边距
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect] ;
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        
        // 根据间距值 计算 cell的缩放比例
        
        // 设置缩放比例
        if ([self.delegate respondsToSelector:@selector(lineLayout:referenceMaxWidthScaleForElementAttributes:)])
        {
            self.maxWidthScale = [self.delegate lineLayout:self referenceMaxWidthScaleForElementAttributes:attrs];
        }
        
        if ([self.delegate respondsToSelector:@selector(lineLayout:referenceMaxHeightScaleForElementAttributes:)])
        {
            self.maxHeightScale = [self.delegate lineLayout:self referenceMaxHeightScaleForElementAttributes:attrs];
        }
        CGFloat widthScale = 1 - delta / self.collectionView.frame.size.width * (1 - self.maxWidthScale);
        CGFloat heightScale = 1 - delta / self.collectionView.frame.size.width * (1 - self.maxHeightScale);
        
        //计算透明度
        CGFloat alpha = 1 - delta / (self.itemSize.width * 2) > 0 ? 1 - delta / (self.itemSize.width * 2) : 0;//ABS(1 - delta / (self.itemSize.width * 2));
        
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        
        //设置透明度
        attrs.alpha = alpha;
        
    }
    return array;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

@end


