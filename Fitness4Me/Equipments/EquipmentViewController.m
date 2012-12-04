//
//  EquipmentViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import "EquipmentViewController.h"

@interface EquipmentViewController ()
@property NSMutableArray *equipments;
@property(strong,nonatomic)NSIndexPath *lastIndex;
@end

@implementation EquipmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.equipmentsTableView.layer setCornerRadius:8];
    [self.equipmentsTableView.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.equipmentsTableView.layer setBorderWidth:2];
    
     self.equipments = [[NSMutableArray alloc]init];
    
    // add continue button
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
     UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;

    
    [self getEquipments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getEquipments{
    
   // [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(listEquipments) toTarget:self withObject:nil];
}


-(void)listEquipments
{
    
   
    
     self.equipmentDB =[[EquipmentDB alloc]init];
    [ self.equipmentDB setUpDatabase];
    [ self.equipmentDB createDatabase];
    [ self.equipmentDB getequipments];
    
    if ([ self.equipmentDB.equipments count]>0) {
        
         self.equipments =self.equipmentDB.equipments ;
        [self.equipmentsTableView reloadData];
               
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.equipments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
   // cell.accessoryType=UITableViewCellAccessoryNone;
    self.equipment=[self.equipments objectAtIndex:indexPath.row];
    [cell.textLabel setText:self.equipment.equipmentName];
    
    if (self.equipment.isChecked) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
         cell.accessoryType=UITableViewCellAccessoryNone;
    }
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark)
    {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
     [[self.equipments objectAtIndex:indexPath.row] setIsChecked:NO];
    }
    else
    {
        [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
        
         [[self.equipments objectAtIndex:indexPath.row] setIsChecked:YES];
        
    }
[self performSelector:@selector(deselect:) withObject:nil afterDelay:0.5f];
}

- (void) deselect: (id) sender {
    [self.equipmentsTableView deselectRowAtIndexPath:[self.equipmentsTableView indexPathForSelectedRow] animated:YES];
}


-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickNext:(id)sender{
   
}

- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [super viewDidUnload];
}
@end
