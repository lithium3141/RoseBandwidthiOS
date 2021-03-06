//
//  FirstRunSettingsViewController.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstRunSettingsViewController.h"

#import "KerberosAccountManager.h"
#import "PropertyEditorViewController.h"

#import "RoseBandwidthTabBarController.h"

@implementation FirstRunSettingsViewController

@synthesize presentingTabBarController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                              target:self 
                                                                                              action:@selector(dismiss)] animated:YES];
    self.navigationItem.title = @"Settings";
}

- (void)buildSettings {
    self.settings = [[MutableOrderedDictionary alloc] initWithCapacity:1];
    
    Setting * usernameSetting = [[Setting alloc] initWithTitle:@"Username" 
                                                         target:self 
                                                        onValue:@selector(username) 
                                                       onAction:@selector(editAction:) 
                                                       onChange:@selector(usernameChanged:)];
    Setting * passwordSetting = [[Setting alloc] initWithTitle:@"Password" 
                                                         target:self 
                                                        onValue:@selector(password) 
                                                       onAction:@selector(editAction:) 
                                                       onChange:@selector(passwordChanged:)];
    passwordSetting.secure = YES;
    NSArray * authenticationSettings = [[NSArray alloc] initWithObjects:usernameSetting, passwordSetting, nil];
    [self.settings setObject:authenticationSettings forKey:@"Authentication"];
}

- (void)dismiss {
    NSLog(@"Dismissing first run dialog; presenting tab bar controller = %@", self.presentingTabBarController);
    
    [self.presentingTabBarController dismissedFirstRunDialog];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Settings value methods

- (NSString *)username {
    return [[KerberosAccountManager defaultManager] username];
}

- (NSString *)password {
    return [[KerberosAccountManager defaultManager] password];
}

#pragma mark - Setting action methods

- (void)editAction:(Setting *)setting {
    PropertyEditorViewController * editor = [[PropertyEditorViewController alloc] initWithSetting:setting];
    [self.navigationController pushViewController:editor animated:YES];
}

#pragma mark - Setting change methods

//TODO find an easier reload solution

- (void)usernameChanged:(NSString *)username {
    [[KerberosAccountManager defaultManager] setUsername:username];
    
    NSUInteger indexes[2] = {0,0};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.presentingTabBarController kerberosAccountInfoChanged];
}

- (void)passwordChanged:(NSString *)password {
    [[KerberosAccountManager defaultManager] setPassword:password];
    
    NSUInteger indexes[2] = {0,1};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.presentingTabBarController kerberosAccountInfoChanged];
}

#pragma mark - Special case table view footer

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return NSLocalizedString(@"disclaimer", @"disclaimer");
    }
    return nil;
}

@end
