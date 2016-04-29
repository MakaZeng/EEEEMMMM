//
//  CrawlersViewController.h
//  Qing
//
//  Created by Maka on 15/11/18.
//  Copyright © 2015年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrawlersViewController : UIViewController

-(instancetype)initWithUrlStartString:(NSString*)startString endString:(NSString*)endString XPathString:(NSString*)XPathString startPage:(NSInteger)page subIncreasingPage:(NSInteger)subIncreasingPage;

@end
