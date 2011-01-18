//
//  Julius.h
//  JuliusSample
//
//  Created by Watanabe Toshinori on 11/01/15.
//  Copyright 2011 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <julius/juliuslib.h>

@protocol JuliusDelegate;


@interface Julius : NSObject {

	Recog *recog;

	id<JuliusDelegate> delegate;

}

@property (nonatomic, assign) id<JuliusDelegate> delegate;

- (void)recognizeRawFileAtPath:(NSString *)path;

@end

@protocol JuliusDelegate

- (void)callBackResult:(NSArray *)results;

@end
