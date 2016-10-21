//
//  AppDelegate.h
//  keepworks
//
//  Created by Kandavel on 18/10/16.
//  Copyright © 2016 com.base2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

