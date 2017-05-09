//
//  ViewController.m
//  FirebaseTodoList
//
//  Created by Sergelenbaatar Tsogtbaatar on 5/8/17.
//  Copyright © 2017 Serg Tsogtbaatar. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "NewTodoViewController.h"

@import FirebaseAuth;
@import Firebase;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentuser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property(strong, nonatomic) NSMutableArray *allTodos;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    NSLog(@"%@", segue.destinationViewController);
}

-(void)checkUserStatus {
    
    if (![[FIRAuth auth] currentUser]) {
        
        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:loginController animated:YES completion:nil];
        
    } else {
        [self setupFirebase];
        [self startMonitoringTodoUpdates];
    }
    
}

-(void)setupFirebase {
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    self.currentuser = [[FIRAuth auth] currentUser];
    
    self.userReference = [[databaseReference child:@"users"] child:self.currentuser.uid];
    
    NSLog(@"The user reference yo: %@", self.userReference);
}

-(void)startMonitoringTodoUpdates {
    
    self.allTodosHandler = [[self.userReference child:@"todos"] observeEventType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableArray *allTodos = [[NSMutableArray alloc] init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *todoData = child.value;
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            
            //for lab append new Todo to allTodos array
            [self.allTodos addObject: todoData];
            [self.tableView reloadData];
            
            NSLog(@" TodoTtitle: %@ - Content: %@", todoTitle, todoContent);
        }
        
    }];
    
}

- (IBAction)logoutPressed:(id)sender {
    NSError *signoutError;
    [[FIRAuth auth] signOut: &signoutError];
    
    [self checkUserStatus];
}

- (IBAction)animateContainer:(id)sender {
//    [self.containerView layoutIfNeeded];
//    
//    if (_containerView.isHidden == YES) {
//        self.heightConstraint.constant = 160;
//        
//        [UIView animateWithDuration:1.0 animations:^{
//            self.heightConstraint.constant = 160;
//            [self.containerView layoutIfNeeded];
//        }];
//        
//    } else {
////        _containerView.isHidden == YES;
//        self.heightConstraint.constant = 0;
//        
//        [UIView animateWithDuration:1.0 animations:^{
//            [self.containerView layoutIfNeeded];
//        }];
//    }
  
    [self.childViewControllers[0] view].hidden = ![self.childViewControllers[0] view].hidden;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allTodos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *currentToDo = self.allTodos[indexPath.row];
    NSString *todoTitle = currentToDo[@"title"];
    NSString *todoContent = currentToDo[@"content"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"to do: %@, this: %@", todoTitle, todoContent];
    
    return cell;
    
}



@end
