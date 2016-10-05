//
//  HomeGoodsFrame.m
//  XianYu
//
//  Created by ZpyZp on 15/10/26.
//  Copyright © 2015年 berchina. All rights reserved.
//

#import "XYHomeGoodsFrame.h"
#import "XYHomeGoodsModel.h"
#import "NSString+Extension.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

#define CellPadding 10
#define PicturePadding 5
#define PictureHeight (SCREEN_WIDTH - CellPadding * 2 - 2 * PicturePadding) / 3

@implementation XYHomeGoodsFrame

-(void)setGoodsModel:(XYHomeGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    CGFloat backgroundX = 0;
    CGFloat backgroundY = 0;
    CGFloat backgroundWidth = SCREEN_WIDTH;
    
    CGFloat iconX = CellPadding;
    CGFloat iconY = CellPadding;
    CGFloat iconWidthAndHeight = 40;
    self.iconView = CGRectMake(iconX, iconY, iconWidthAndHeight, iconWidthAndHeight);
    
    CGFloat nicknameX = CGRectGetMaxX(self.iconView) + CellPadding;
    CGFloat nicknameY = iconY;
    CGSize  nicknameSize = [goodsModel.nickname sizeWithTextfont:[UIFont systemFontOfSize:14] maxW:100];
    self.nicknameLabel = (CGRect){{nicknameX,nicknameY},nicknameSize};
    
    CGFloat dateX = nicknameX;
    CGFloat dateY = CGRectGetMaxY(self.nicknameLabel) + CellPadding;
    CGSize  dateSize = [[NSString addtime:goodsModel.date] sizeWithTextfont:[UIFont systemFontOfSize:12] maxW:200];
    self.dateLabel = (CGRect){{dateX,dateY},dateSize};
    
    
    NSString *price = [NSString stringWithFormat:@"¥%@",goodsModel.price];
    goodsModel.price = price;
    CGSize priceSizeTemp = [price sizeWithTextfont:[UIFont systemFontOfSize:16] maxW:200];
    CGSize priceSize = {priceSizeTemp.width+10, priceSizeTemp.height};
    CGFloat priceX = SCREEN_WIDTH-2*CellPadding+5-priceSize.width;
    CGFloat priceY = nicknameY;
    self.priceLabel = (CGRect){{priceX,priceY},priceSize};
    
    CGFloat originalHeight = 0;
    
    if (goodsModel.pictures.count>0) {
        
        CGFloat photoX = iconX;
        CGFloat photoY = CGRectGetMaxY(self.iconView) + CellPadding;
        
        CGSize photoSize;
        
        switch (goodsModel.pictures.count) {
            case 1:
                photoSize = CGSizeMake(PictureHeight*2+PicturePadding, PictureHeight);
                break;
            case 2:
                photoSize = CGSizeMake(PictureHeight*2+PicturePadding, PictureHeight);
            case 3:
                photoSize = CGSizeMake(SCREEN_WIDTH - CellPadding * 2, PictureHeight);
            default:
                break;
        }
        
        self.picturesView = (CGRect){{photoX,photoY},photoSize};
        originalHeight = CGRectGetMaxY(self.picturesView) + CellPadding;
    }else{
        originalHeight = CGRectGetMaxY(self.iconView) + CellPadding;
    }
    
    CGFloat contentX = CellPadding;
    CGFloat contentY = originalHeight;
    CGSize  contentSize = [goodsModel.content sizeWithTextfont:[UIFont systemFontOfSize:14] maxW:backgroundWidth - 2*CellPadding];
    self.contentLabel = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    CGFloat locateX = CellPadding;
    CGFloat locateY = CGRectGetMaxY(self.contentLabel)+CellPadding;
    CGFloat locateWidth = 200;
    CGFloat locateHeight = 20;
    self.locationButton = CGRectMake(locateX, locateY, locateWidth, locateHeight);
    
    CGFloat accessWidth = 19;
    CGFloat accessHeight = 14;
    CGFloat accessX = backgroundWidth - CellPadding- accessWidth;
    CGFloat accessY = locateY;
    self.accessButton = CGRectMake(accessX, accessY, accessWidth, accessHeight);
    

    CGFloat backgroundHeight = CGRectGetMaxY(self.locationButton)+CellPadding;
    self.backgroundView = CGRectMake(backgroundX, backgroundY, backgroundWidth, backgroundHeight);
    
    self.cellHeight = CGRectGetMaxY(self.backgroundView)+CellPadding;
}
@end
