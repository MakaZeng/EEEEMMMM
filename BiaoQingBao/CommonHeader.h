//
//  CommonHeader.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import <UIImageView+WebCache.h>


#define MAKA_isType(x,y) [x isKindOfClass:[y class]]

#define MAKA_isDicionary(x) MAKA_isType(x,NSDictionary)
#define MAKA_isArray(x) MAKA_isType(x,NSArray)
#define MAKA_isString(x) MAKA_isType(x,NSString)
#define MAKA_isNumber(x) MAKA_isType(x,NSNumber)
#define MAKA_isMutableDicionary(x) MAKA_isType(x,NSMutableDictionary)
#define MAKA_isMutableArray(x) MAKA_isType(x,NSMutableArray)
#define MAKA_isObject(x) MAKA_isType(x,NSObject)

#define MAKA_EMPTY_STRING @""
#define MAKA_EMPTY_NUMBER @0
#define MAKA_EMPTY_ARRAY nil
#define MAKA_EMPTY_DICTIONARY nil

#define NSArray_ObjectAt_Index(x,y) ([x isKindOfClass:[NSArray class]]?(x.count > y && y>=0? [x objectAtIndex:y] : nil):nil)

#define NSDictionary_String_ForKey(x,y) (MAKA_isDicionary(x)?(MAKA_isString([x objectForKey:y])?[x objectForKey:y]:MAKA_EMPTY_STRING):MAKA_EMPTY_STRING)

#define NSArray_String_Object_AtIndex(x,y) (MAKA_isArray(x)?(y>=0&&y<x.count?(MAKA_isString([x objectAtIndex:y])?[x objectAtIndex:y]:MAKA_EMPTY_STRING):MAKA_EMPTY_STRING):MAKA_EMPTY_STRING)

#define NSArray_Dictionary_Object_AtIndex(x,y) (MAKA_isDicionary(NSArray_ObjectAt_Index(x,y))?NSArray_ObjectAt_Index(x,y):MAKA_EMPTY_DICTIONARY)

#define NSArray_Array_Object_AtIndex(x,y) (MAKA_isArray(NSArray_ObjectAt_Index(x,y))?NSArray_ObjectAt_Index(x,y):MAKA_EMPTY_ARRAY)


#define Dictionary_Number_Object_ForKey(x,y) (MAKA_isDicionary(x)&&MAKA_isString(y) ? (MAKA_isNumber([x objectForKey:y])?[x objectForKey:y]:MAKA_EMPTY_NUMBER):MAKA_EMPTY_NUMBER)

#define Dictionary_Array_Object_ForKey(x,y) (MAKA_isDicionary(x)&&MAKA_isString(y) ? (MAKA_isArray([x objectForKey:y])?[x objectForKey:y]:MAKA_EMPTY_ARRAY):MAKA_EMPTY_ARRAY)

#define NSMutableDictionary_setObjectForKey(x,y,z) (MAKA_isMutableDicionary(x)?(MAKA_isObject(y)&&MAKA_isString(z)?[x setObject:y forKey:z]:MAKA_EMPTY_STRING):MAKA_EMPTY_STRING)

#define NSMutableArray_replaceObjectAtIndex(x,y,z) (MAKA_isMutableArray(x)?(MAKA_isObject(z)&&(y&&y<x.count)?[x replaceObjectAtIndex:y withObject:z]:MAKA_EMPTY_STRING):MAKA_EMPTY_STRING)


#define BASE_BACK_COLOR [UIColor orangeColor]

#define BASE_Tint_COLOR [UIColor whiteColor]

#define LightDarkColor [UIColor colorWithRed:230/255. green:230/255. blue:230/255. alpha:1]

#define MODEL_VIEW_BACK_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:.5]

#define Layer_Border_View(x) {x.layer.cornerRadius = 5;x.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;x.layer.borderColor = [LightDarkColor CGColor];}

#define Layer_View(x)  ((x.layer.cornerRadius = 5),(x.layer.masksToBounds = YES));

#define Color_Layer_View(x) {x.layer.cornerRadius = 5;x.layer.masksToBounds = YES;x.layer.borderColor = LightDarkColor.CGColor;x.layer.borderWidth = 1/[UIScreen mainScreen].scale;}

#define CurrentLanguage [[NSLocale preferredLanguages] objectAtIndex:0]

#define BottomLine_View(view,color) {UIView* v = [[UIView alloc]init];v.backgroundColor=color;[view addSubview:v];[v mas_makeConstraints:^(MASConstraintMaker *make) {make.left.right.bottom.mas_equalTo(0);make.height.mas_equalTo(1/[UIScreen mainScreen].scale);}];}

//拉伸图片
#define ImageResizeImage(image) ([image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2) resizingMode:UIImageResizingModeStretch])

#define ImageNamed(name) [UIImage imageNamed:name]

//拉伸图片
#define ImageResizeImage(image) ([image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2) resizingMode:UIImageResizingModeStretch])




#endif /* CommonHeader_h */
