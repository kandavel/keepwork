//
//  ViewController.m
//  keepworks
//
//  Created by Kandavel on 18/10/16.
//  Copyright © 2016 com.base2. All rights reserved.
//

#import "ViewController.h"
#import "ListCell.h"
#import "TestViewController.h"
#import "GridCell.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 1.0
#define kAnimationTranslateX 2.0
#define kAnimationTranslateY 2.0

@interface ViewController ()<UITextFieldDelegate,UITableViewDataSource,UITextFieldDelegate,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton *btn1;
    UIMenuItem *menuitem;
    UIBarButtonItem *Edit;
    NSFileManager *fileManager;
    NSMutableArray *arrayData;
}


@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UISegmentedControl *option;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)optionAction:(id)sender;
-(void)customaction:(id)sender;
@property(strong,nonatomic )NSMutableArray *populateEvent;
@property(strong,nonatomic )NSMutableArray *populateVenue;
@property(strong,nonatomic )NSMutableArray *populateEntryType;
@property(strong,nonatomic)NSMutableArray *populateImage;
@property(strong,nonatomic)NSMutableArray *populatetrack;
@property(strong,nonatomic)NSMutableArray *populateGridTrack;
@property(strong,nonatomic)NSMutableArray *populateIndex;

@end

@implementation ViewController

- (void)viewDidLoad
{
   
      [super viewDidLoad];
    //-----------------------------------------------------------------arrayintialization
    _populateEvent =[[NSMutableArray alloc]initWithObjects:@"Metallica Concert",@"Saree Exhibition",@"Wine tasting",@"Startups Meet",@"Summer Noon",@"Rock and Roll", @"Barbecue Fridays",@"Summer workshop",@"Impressions & Expressions",@"Italian carnival",nil];
    _populateVenue=[[NSMutableArray alloc]initWithObjects:@"Palace Grounds",@"Malleswaram Grounds",@"Links Brewery",@"Kanteerava Indoor Stadium", @" Kumara Park",@"Sarjapur Road",@"Whitefield",@"Indiranagar",@"MG Road",@"Electronic City",nil];
    _populateEntryType=[[NSMutableArray alloc]initWithObjects:@"paid entry",@"free entry",@"paid entry",@"free entry",@"paid entry",@"free entry",@"free entry",@"free entry",@"paid entry",@"paid entry",nil];
    _populateImage=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"eve2.jpeg"],[UIImage imageNamed:@"eve1.jpeg"],[UIImage imageNamed:@"eve3.jpeg"],[UIImage imageNamed:@"eve4.jpeg" ],[UIImage imageNamed:@"eve5.jpeg"],[UIImage imageNamed:@"eve6.jpeg"], [UIImage imageNamed:@"eve7.jpeg"],[UIImage imageNamed:@"eve8.jpeg"], [UIImage imageNamed:@"eve1.jpeg"],[UIImage imageNamed:@"eve3.jpeg"],nil];
    _populatetrack=[[NSMutableArray alloc]init];
    _populateIndex=[[NSMutableArray alloc]init];
    _populateIndex=[[NSMutableArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    _populateGridTrack=[[NSMutableArray alloc]init];
  //----------------------------------------------------------------------persitent
    fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self filePathFromDocumentDirectory] ])
    {
        BOOL b=   [fileManager copyItemAtPath:[self filePathFromBundle] toPath:[self filePathFromDocumentDirectory] error:nil];
        if (b) {
            arrayData=[[NSMutableArray alloc]init];
            NSLog(@"%@",fileManager.currentDirectoryPath);
            NSLog(@"file Copied");
        }
        else
            NSLog(@"Not Copied");
    }
    else
    {
     BOOL a =  [_populateVenue writeToFile:[self filePathFromDocumentDirectory] atomically:YES];
        [_populateEvent writeToFile:[self filePathFromDocumentDirectory] atomically:YES];
        
        
        if (a) {
            
            NSLog(@"%@",_populateVenue);
            NSLog(@"%@",_populateEvent);
        }
        
    }

    
    
    
    
    
   //-------------------------------------------------------------------------alert
    UIAlertController  *nameAlert = [UIAlertController alertControllerWithTitle:@"Keepworks" message:@"Please enter your name" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        
        _name.text =nameAlert.textFields.firstObject.text;
    }];
    
    _name.delegate= self;
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self dismissViewControllerAnimated:1 completion:nil];
    }];
    [nameAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];

    [nameAlert addAction:okAction];
    [nameAlert addAction:cancelAction];
    [self presentViewController:nameAlert animated:1 completion:^{
        nil;
    }];
    
    //-----------------------------------------------------------------tableview
    self.tableView.editing= 0;
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(15.0f, 0.0f, 70.0f, 40.0f)];
    [btn1 addTarget:self action:@selector(changelang) forControlEvents:UIControlEventTouchUpInside];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [btn1 setTitle:@"Edit" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    Edit = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = Edit;
    
        
    //-----------------------------------------------------------------collection view
   
       //-----------------------------------------------------------------segment control
    [_option setTitle:@"List" forSegmentAtIndex:0];
    [_option setTitle:@"Grid" forSegmentAtIndex:1];
    
    _option.selectedSegmentIndex=0;
    if (_option.selectedSegmentIndex== 0)
    {
        
        _tableView.hidden= NO;
        _collectionView.hidden= YES;
        
    _tableView.dataSource= self;
       _tableView.delegate=self;
             self.tableView.alwaysBounceVertical= YES;
       

    }
    else
    {
        _collectionView.hidden= NO;
        _tableView.hidden= YES;
      //  _collectionView.backgroundView.backgroundColor =[UIColor whiteColor];
       
    
    }
    
    
    
    
}
#pragma mark - DATA SOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([fileManager fileExistsAtPath:[self filePathFromBundle]]) {
        _populateEvent=[[NSMutableArray alloc]init ];
        _populateEvent=[_populateEvent initWithContentsOfFile:[self filePathFromDocumentDirectory]];
        return _populateEvent.count;
    }
    else
    {
    NSLog(@"%lu",(unsigned long)[_populateEvent count]);
    return _populateEvent.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}
-(void)viewWillAppear:(BOOL)animated
{

    [self.tableView reloadData];
    [self.collectionView reloadData];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"tableViewDataImage"];
  NSMutableArray *array= [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy]; ;
    NSLog(@"%@",array);
     ListCell *cell= (ListCell*) [_tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (array.count>0)
    {
        
        
       
            NSLog(@"%@",indexPath);
        for (int i=0; i<array.count; i++)
        {
          NSIndexPath *path=[array objectAtIndex:i];
            if ([path isEqual:indexPath])
            {
                cell.listTitle.backgroundColor=[UIColor lightGrayColor];
                cell.listVenue.backgroundColor=[UIColor lightGrayColor];
                cell.listFees.backgroundColor=[UIColor lightGrayColor];
            }
            else
            {
                nil;
            }
        }
        
        
        
    }

    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.listImage.image=[_populateImage objectAtIndex:indexPath.row];
    [cell.listImage sizeToFit];
    cell.listTitle.text=[_populateEvent objectAtIndex:indexPath.row];
    cell.listVenue.text=[_populateVenue objectAtIndex:indexPath.row];
    cell.listFees.text=[_populateEntryType objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - DELEGATE METHODS
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [_populatetrack addObject:indexPath];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_populatetrack] forKey:@"tableViewDataImage"];
    [userDefaults synchronize];
  ListCell *cell =(ListCell*) [_tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell.listTitle );
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    ;
    TestViewController *detailview=[storyBoard instantiateViewControllerWithIdentifier:@"detailView"];
    if (detailview.view)
    {
        
        detailview.detailImage.image=cell.listImage.image;
        detailview.detailVenue.text=[[NSString alloc]initWithString:cell.listVenue.text];
        detailview.detailFees.text=[[NSString alloc]initWithString:cell.listFees.text];
    }
   
    [self.navigationController pushViewController:detailview animated:YES];

}
#pragma mark - reorderRow

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  NSString *strTitle =[_populateEvent objectAtIndex:sourceIndexPath.row];
    [_populateEvent removeObjectAtIndex:sourceIndexPath.row];
    [_populateEvent insertObject:strTitle atIndex:destinationIndexPath.row];
    [_populateEvent writeToFile:[self filePathFromDocumentDirectory] atomically:YES];
    
    NSString *strVenue =[_populateVenue objectAtIndex:sourceIndexPath.row];
    [_populateVenue removeObjectAtIndex:sourceIndexPath.row];
    [_populateVenue insertObject:strVenue atIndex:destinationIndexPath.row];
    
    NSString *strFees =[_populateEntryType objectAtIndex:sourceIndexPath.row];
    [_populateEntryType removeObjectAtIndex:sourceIndexPath.row];
    [_populateEntryType insertObject:strFees atIndex:destinationIndexPath.row];
    
  /*UIImage *reoderImage  =[UIImage imageNamed:[_populateImage objectAtIndex:sourceIndexPath.row]];
    [_populateImage removeObjectAtIndex:sourceIndexPath.row];
    [_populateImage insertObject:reoderImage atIndex:destinationIndexPath.row];*/
    
    [_tableView setEditing:0 animated:YES];


}
#pragma mark - deleteParticularRow

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        
        [_populateEvent removeObjectAtIndex:indexPath.row];
          [_populateEvent writeToFile:[self filePathFromDocumentDirectory] atomically:YES];
        [_populateVenue removeObjectAtIndex:indexPath.row];
        [_populateEntryType removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [_tableView setEditing:NO animated:YES];
        [_tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning
   {
    [super didReceiveMemoryWarning];
  
   }

#pragma mark - switchingTabs
- (IBAction)optionAction:(UISegmentedControl *)sender
       {
    
    
           if (sender.selectedSegmentIndex == 0)
               
           {
               self.tableView.hidden = NO;
               btn1.hidden=NO;
               self.collectionView.hidden = YES;
           }
           
           if (sender.selectedSegmentIndex == 1)
               
           {
               self.collectionView.backgroundColor=[UIColor whiteColor];
            self.collectionView.hidden = NO;
            self.tableView.hidden = YES;
               btn1.hidden=YES;
               UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(customaction1:)];
               longpress.minimumPressDuration = 0.7;
               [_collectionView addGestureRecognizer:longpress];
               UISwipeGestureRecognizer *tap=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(customaction:)];
               //tap.numberOfTapsRequired =3;
               tap.direction=UISwipeGestureRecognizerDirectionRight;
               [_collectionView addGestureRecognizer:tap];
               [_collectionView setUserInteractionEnabled:YES];
               _collectionView.dataSource= self;
              _collectionView.delegate=self;

               
           }
           
      
    
    }
#pragma mark - collectionDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [_populateEvent count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"collectionViewDataImage"];
    NSMutableArray *array= [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy]; ;
    NSLog(@"%@",array);
    GridCell *gridcell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    if (array.count>0)
    {
        
        
        
        NSLog(@"%@",indexPath);
        for (int i=0; i<array.count; i++)
        {
            NSIndexPath *path=[array objectAtIndex:i];
            if ([path isEqual:indexPath])
            {
                gridcell.backgroundColor=[UIColor lightGrayColor];
                
            }
            else
            {
                nil;
            }
        }
        
        
        
    }

   
    
    gridcell.gridImage.image=[_populateImage objectAtIndex:indexPath.row];
    gridcell.gridTitle.text=[_populateEvent objectAtIndex:indexPath.row];
    [gridcell.gridTitle sizeToFit];
    gridcell.gridTitle.adjustsFontSizeToFitWidth =YES;
    return gridcell;


}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_populateGridTrack addObject:indexPath];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_populateGridTrack] forKey:@"collectionViewDataImage"];
    [userDefaults synchronize];
    
    NSLog(@"%@",indexPath);
    GridCell *gridView=(GridCell*)[_collectionView cellForItemAtIndexPath:indexPath];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    ;
    TestViewController *detailview=[storyBoard instantiateViewControllerWithIdentifier:@"detailView"];
    if (detailview.view)
    {
        
        detailview.detailImage.image=gridView.gridImage.image;
        detailview.detailVenue.text=[[NSString alloc]initWithString:gridView.gridTitle.text];
        detailview.detailFees.text=[[NSString alloc]initWithString:[_populateEntryType objectAtIndex:indexPath.row]];
    }
[self.navigationController pushViewController:detailview animated:YES];
    
    
}
#pragma mark - reorderGrid
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{

    NSString *strTitle =[_populateEvent objectAtIndex:sourceIndexPath.row];
    [_populateEvent removeObjectAtIndex:sourceIndexPath.row];
    [_populateEvent insertObject:strTitle atIndex:destinationIndexPath.row];
    
    NSString *strVenue =[_populateVenue objectAtIndex:sourceIndexPath.row];
    [_populateVenue removeObjectAtIndex:sourceIndexPath.row];
    [_populateVenue insertObject:strVenue atIndex:destinationIndexPath.row];
    
    NSString *strFees =[_populateEntryType objectAtIndex:sourceIndexPath.row];
    [_populateEntryType removeObjectAtIndex:sourceIndexPath.row];
    [_populateEntryType insertObject:strFees atIndex:destinationIndexPath.row];
    
    
  
    [_collectionView reloadData];

}
#pragma mark - gesture reorder and delete

-(void)customaction:(UISwipeGestureRecognizer*)sender
{

    if (sender.direction== UISwipeGestureRecognizerDirectionRight )
    {
    
        NSIndexPath *index=[_collectionView indexPathForItemAtPoint:[sender locationInView:_collectionView]];
        [_populateImage removeObjectAtIndex:index.row];
        [_populateEvent removeObjectAtIndex:index.row];
        [_populateVenue removeObjectAtIndex:index.row];
        [_populateEntryType removeObjectAtIndex:index.row];
        [_collectionView deleteItemsAtIndexPaths:@[index]];
        [_collectionView reloadData];
        
    }
    
}
-(void)customaction1:(UILongPressGestureRecognizer*)sender
{
    if (sender.minimumPressDuration== 0.7)
    {
        if (sender.state==UIGestureRecognizerStateBegan)
        {
            [self startJiggling:10:sender];
            NSIndexPath *index=[_collectionView indexPathForItemAtPoint:[sender locationInView:_collectionView]];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:index];
            
        }
        if (sender.state==UIGestureRecognizerStateChanged)
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[sender locationInView:self.collectionView]];
        }
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            [self.collectionView endInteractiveMovement];
            [self stopJiggling:sender];
        }
    }
    
    
}
#pragma mark -shakeanimation
- (void)startJiggling:(NSInteger)count:(UILongPressGestureRecognizer*)sender {
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg * (count%2 ? +1 : -1 ) ));
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg * (count%2 ? -1 : +1 ) ));
    CGAffineTransform moveTransform = CGAffineTransformTranslate(rightWobble, -kAnimationTranslateX, -kAnimationTranslateY);
    CGAffineTransform conCatTransform = CGAffineTransformConcat(rightWobble, moveTransform);
    NSIndexPath *index=[_collectionView indexPathForItemAtPoint:[sender locationInView:_collectionView]];
    GridCell *cell=(GridCell*)[_collectionView cellForItemAtIndexPath:index];
    
    cell.transform = leftWobble;  // starting point
    
    [UIView animateWithDuration:0.1
                          delay:(count * 0.08)
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{ cell.transform = conCatTransform; }
                     completion:nil];
}

- (void)stopJiggling:(UILongPressGestureRecognizer*)sender {
    NSIndexPath *index=[_collectionView indexPathForItemAtPoint:[sender locationInView:_collectionView]];
    GridCell *cell=(GridCell*)[_collectionView cellForItemAtIndexPath:index];
    [cell.layer removeAllAnimations];
    cell.transform = CGAffineTransformIdentity;  // Set it straight
}

-(void)changelang
{

    NSLog(@"%d",[btn1 isSelected]);
    
    if (![btn1 isSelected])
    {
        [btn1 setSelected:YES];
        [self.tableView setEditing:YES animated:YES];
        
    }
    else
    {
        [btn1 setSelected:NO];
        [self.tableView setEditing:NO animated:YES];
        
    }

}
#pragma mark -resign responder

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    [self.tableView resignFirstResponder];
    
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
   
    return YES;
}
#pragma mark - persitent data storage
-(NSString *)filePathFromDocumentDirectory
{
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[pathArray lastObject]stringByAppendingPathComponent:@"Property List.plist"];
    return path;
}
-(NSString *)filePathFromBundle
{
    NSString *bundlePath=[[NSBundle mainBundle]bundlePath];
    bundlePath=[bundlePath stringByAppendingPathComponent:@"Property List.plist"];
    return bundlePath;
}
@end
