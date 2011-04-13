//  Copyright 2009-2010 Aurora Feint, Inc.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  	http://www.apache.org/licenses/LICENSE-2.0
//  	
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "OFSendSocialNotificationController.h"
#import "OFSendSocialNotificationCell.h"
#import "OFControllerLoader.h"
#import "OFImageLoader.h"
#import "OFTableSectionDescription.h"
#import "OFUsersCredentialService.h"
#import "OFUsersCredential.h"
#import "OFDelegateChained.h"
#import "OFFacebookAccountLoginController.h"
#import "OFTwitterAccountLoginController.h"
#import "OFSendSocialNotificationSubmitTextCell.h"
#import "OFSocialNotification.h"
#import "OFSocialNotificationService+Private.h"
#import "OpenFeint+Private.h"
#import "OFTableCellBackgroundView.h"
#import "OFTableControllerHelper+Overridables.h"
#import "OFViewHelper.h"

static BOOL dismissDashboardWhenSent;

@implementation OFSendSocialNotificationController

@synthesize submitTextCell, notification;

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if(self.isViewLoaded)
	{
		//Save whether or not they cell is checked since we are going to reload the cells
		OFTableSectionDescription* tableDesc = [mSections objectAtIndex:0];
		NSMutableArray* cells = tableDesc.staticCells;
		
		for(uint i = 0; i < [cells count]; i++)
		{
			OFTableCellHelper* cellHelper = [cells objectAtIndex:i];
			if([cellHelper isKindOfClass:[OFSendSocialNotificationCell class]])
			{
				OFSendSocialNotificationCell* cell = (OFSendSocialNotificationCell*)cellHelper;
				initChecked[cell.networkType] = cell.checked;
			}
		}
		
		//We can't be sure if the user connected to facebook or twitter while we were away from this screen.  Lets just refresh the whole thing, its fast.
		[self _refreshData];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//Default should be "send to all", so all checked.
	dismissDashboardWhenSent = NO;
	for(uint i = 0; i < ESocialNetworkCellType_COUNT; i++)
	{
		initChecked[i] = YES;
	}
	
	UIBarButtonItem* right = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send)] autorelease];
	self.navigationItem.rightBarButtonItem = right;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	self.submitTextCell = (OFSendSocialNotificationSubmitTextCell*)OFControllerLoader::loadCell(@"SendSocialNotificationSubmitText");

	UIImage* bgImage = [OFImageLoader loadImage:@"OFLeadingCellBackground.png"];
	
	OFTableCellBackgroundView* backgroundView = nil;
	OFTableCellBackgroundView* selectedBackgroundView = nil;
	self.submitTextCell.backgroundView = backgroundView = [OFTableCellBackgroundView defaultBackgroundView];
	self.submitTextCell.selectedBackgroundView = selectedBackgroundView = [OFTableCellBackgroundView defaultBackgroundView];
	backgroundView.image = bgImage;
	selectedBackgroundView.image = bgImage;
}

- (void)send
{
	//Disable send button so we can't send twice.
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	//the notification has hopefully been created by this time, but incase it has not.
	NSString* sendMessage = [NSString stringWithFormat:@"%@  %@", self.submitTextCell.prePopulatedText.text, self.submitTextCell.message.text];
	if(!self.notification)
	{
		self.notification = [[[OFSocialNotification alloc] initWithText:sendMessage] autorelease];
	}
	else
	{
		//We're about to fill this out, so clear it.
		[self.notification clearSendToNetworks];
		
		self.notification.text = sendMessage;
	}
	
	//Add appropirate networks to send to.
	OFTableSectionDescription* tableDesc = [mSections objectAtIndex:0];
	NSMutableArray* cells = tableDesc.staticCells;
	for(uint i = 0; i < [cells count]; i++)
	{
		OFTableCellHelper* cellHelper = [cells objectAtIndex:i];
		if([cellHelper isKindOfClass:[OFSendSocialNotificationCell class]])
		{
			OFSendSocialNotificationCell* cell = (OFSendSocialNotificationCell*)cellHelper;
			if(cell.checked && cell.connectedToNetwork)
			{
				[self.notification addSendToNetwork:cell.networkType];
			}
		}
	}
	
	//Trigger the send to the server. 
	[OFSocialNotificationService sendSocialNotification:self.notification];
}

- (void)doIndexActionOnSuccess:(const OFDelegate&)success onFailure:(const OFDelegate&)failure;
{
	OFSafeRelease(mSections);
	
	//Reload table after this is done.
	[OFUsersCredentialService getIndexOnSuccess:success
									  onFailure:failure
				   onlyIncludeLinkedCredentials:YES];
}

- (void) createCell:(NSMutableArray*)cellArray withType:(ESocialNetworkCellType)eSocialNetworkType andConnectToNetworkText:(NSString*)connectToNeworkText andPostToNetworkText:(NSString*)postToNetworkText andConnectToNetworkImageName:(NSString*)connetToNetworkImageName andConnectedToNeworkIconName:(NSString*)connectedToNetworkIconName andConnectedToNetwork:(BOOL)connectedToNetwork
{
	OFSendSocialNotificationCell* curCell = (OFSendSocialNotificationCell*)OFControllerLoader::loadCell(@"SendSocialNotification");
	curCell.connectToNeworkLabel.text = connectToNeworkText;
	curCell.postToNetworkLabel.text = postToNetworkText;
	
	curCell.connectToNetworkImage.image = connetToNetworkImageName ? [OFImageLoader loadImage:connetToNetworkImageName] : nil;
	curCell.connectedNetworkIcon.image = connectedToNetworkIconName ? [OFImageLoader loadImage:connectedToNetworkIconName] : nil;
	curCell.checked = initChecked[eSocialNetworkType];

    curCell.networkType = eSocialNetworkType;

	curCell.connectedToNetwork = connectedToNetwork;
	
	[cellArray addObject:curCell];
}

- (void)_onDataLoaded:(OFPaginatedSeries*)resources isIncremental:(BOOL)isIncremental
{
	//Figure out what networks we are connected too.
	NSMutableArray* credentials = [[(OFTableSectionDescription*)[[resources objects] objectAtIndex:0] page] objects];
	BOOL connectedToNetwork[ESocialNetworkCellType_COUNT];
	BOOL connectedToAny = NO;
	for(uint i = 0; i < ESocialNetworkCellType_COUNT; i++)
	{
		connectedToNetwork[i] = NO;
	}
	
	for (OFUsersCredential* credential in credentials)
	{
		if ([credential isTwitter])
		{
			connectedToNetwork[ESocialNetworkCellType_TWITTER] = YES;
			connectedToAny = YES;
		}
		else if([credential isFacebook])
		{
			connectedToNetwork[ESocialNetworkCellType_FACEBOOK] = YES;
			connectedToAny = YES;
		}
	}
	
	NSMutableArray* staticCells = [NSMutableArray arrayWithCapacity:3];
	
	//Fill out the first cell appropriately.
	if(connectedToAny)
	{
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[staticCells addObject:self.submitTextCell];
	}
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
		[staticCells addObject:OFControllerLoader::loadCell(@"NotConnectedToSocialNetwork")];
	}
	
	//Create the next (n) cells for social networks.
	[self createCell:staticCells withType:ESocialNetworkCellType_TWITTER andConnectToNetworkText:@"Connect to Twitter" andPostToNetworkText:@"Post to Twitter" andConnectToNetworkImageName:@"OFConnectToTwitter.png" andConnectedToNeworkIconName:@"OFConnectedToTwitter.png" andConnectedToNetwork:connectedToNetwork[ESocialNetworkCellType_TWITTER]];
	[self createCell:staticCells withType:ESocialNetworkCellType_FACEBOOK andConnectToNetworkText:@"Connect to Facebook" andPostToNetworkText:@"Post to Facebook" andConnectToNetworkImageName:@"OFConnectToFacebook.png" andConnectedToNeworkIconName:@"OFConnectedToFacebook.png" andConnectedToNetwork:connectedToNetwork[ESocialNetworkCellType_FACEBOOK]];
	
	mSections = [[NSMutableArray arrayWithObject:[OFTableSectionDescription sectionWithTitle:@"" andStaticCells:staticCells]] retain];
	
	[self _reloadTableData];
}

- (void)configureCell:(OFTableCellHelper*)_cell asLeading:(BOOL)_isLeading asTrailing:(BOOL)_isTrailing asOdd:(BOOL)_isOdd
{
	//The submitTextCell has already been configured (background/backgroundSelected) in viewDidLoad.
	if(_cell != self.submitTextCell)
	{
		[super configureCell:_cell asLeading:_isLeading asTrailing:_isTrailing asOdd:_isOdd];
	}
}

- (void)onCellWasClicked:(OFResource*)cellResource indexPathInTable:(NSIndexPath*)indexPath
{
	if([mSections count] <= 0)
	{
		return;
	
	}
	NSMutableArray* staticCells = [[mSections objectAtIndex:0] staticCells];
	if(indexPath.row >= [staticCells count])
	{
		return;
	}

	OFTableCellHelper* cellHelper = [staticCells objectAtIndex:indexPath.row];
	if([cellHelper isKindOfClass:[OFSendSocialNotificationCell class]])
	{
		OFSendSocialNotificationCell* cell = (OFSendSocialNotificationCell*)cellHelper;
		if(cell.connectedToNetwork) //Cell is connected
		{
			//Logged in, check or uncheck the network.
			cell.checked = !cell.checked;
			[cell setSelected:NO animated:YES];
			
			//If no cell is checked and connected, disable the send button
			OFTableSectionDescription* tableDesc = [mSections objectAtIndex:0];
			NSMutableArray* cells = tableDesc.staticCells;
			BOOL ableToSend = NO;
			for(uint i = 0; i < [cells count]; i++)
			{
				OFTableCellHelper* cellHelper = [cells objectAtIndex:i];
				if([cellHelper isKindOfClass:[OFSendSocialNotificationCell class]])
				{
					OFSendSocialNotificationCell* cell = (OFSendSocialNotificationCell*)cellHelper;
					if(cell.checked && cell.connectedToNetwork)
					{
						ableToSend = YES;
					}
				}
			}
			
			//update the send button
			self.navigationItem.rightBarButtonItem.enabled = ableToSend;
		}
		else //cell's network is not connected.
		{
			//Not logged in, try to login to network.
			if(cell.networkType == ESocialNetworkCellType_FACEBOOK)
			{
				OFFacebookAccountLoginController* controllerToPush =
				(OFFacebookAccountLoginController*)OFControllerLoader::load(@"FacebookAccountLogin");
				
				[controllerToPush setAddingAdditionalCredential:YES];
				controllerToPush.controllerToPopTo = self;
				controllerToPush.getPostingPermission = YES;
				[self.navigationController pushViewController:controllerToPush animated:YES];
			}
			else if(cell.networkType == ESocialNetworkCellType_TWITTER)
			{
				OFTwitterAccountLoginController* controllerToPush =
				(OFTwitterAccountLoginController*)OFControllerLoader::load(@"TwitterAccountLogin");
				
				[controllerToPush setAddingAdditionalCredential:YES];
				controllerToPush.controllerToPopTo = self;
				[self.navigationController pushViewController:controllerToPush animated:YES];
			}
		}
	}
}

-(void)setPrepopulatedText:(NSString*)prepopulatedText andOriginalMessage:(NSString*)message
{
	//Max out the prepopuated text
	NSString* prepopulatedTextToSet = @"";
	if(prepopulatedText)
	{
		prepopulatedTextToSet = [NSString stringWithString:prepopulatedText];
		if(prepopulatedText.length > SocialNotification_MAX_PREPOPULATED_CHARACTERS)
		{
			prepopulatedTextToSet = [prepopulatedText substringToIndex:SocialNotification_MAX_PREPOPULATED_CHARACTERS];
		}
		self.submitTextCell.prePopulatedText.text = prepopulatedTextToSet;
		UIFont* labelFont = OFViewHelper::getFontToFitStringInSize(prepopulatedTextToSet, 
																   self.submitTextCell.prePopulatedText.frame.size, 
																   self.submitTextCell.prePopulatedText.font, 
																   self.submitTextCell.prePopulatedText.font.pointSize, 
																   self.submitTextCell.prePopulatedText.minimumFontSize); 
		self.submitTextCell.prePopulatedText.font = labelFont;
		
	}
	self.submitTextCell.maxMessageCharacters = SocialNotification_MAX_TOTAL_CHARACTERS 
												- SocialNotification_MAX_LINK_CHARACTERS 
												- [prepopulatedTextToSet length];

	//max out the message length.
	if(message)
	{
		NSString* messageToSet = [NSString stringWithString:message];
		if(message.length > self.submitTextCell.maxMessageCharacters)
		{
			messageToSet = [message substringToIndex:self.submitTextCell.maxMessageCharacters];
		}
		self.submitTextCell.message.text = messageToSet;
	}
}

-(void)setImageUrl:(NSString*)iconUrl defaultImage:(NSString*)defaultImage;
{
	if(self.notification)
	{
		self.notification.imageUrl = iconUrl;
		if(defaultImage)
		{
			[submitTextCell setDefaultImageName:defaultImage];
		}
		
		if(iconUrl)
		{
			[submitTextCell setIconUrl:iconUrl];
		}
	}
	else
	{
		OFLog(@"Warning: call setImageUrl after setImageName:linkedUrl or setImageType:imageId:linkedUrl: on OFSendSocialNotificationController");
	}

}

-(void)setImageName:(NSString*)imageName linkedUrl:(NSString*)url
{
	self.notification = [[[OFSocialNotification alloc] initWithText:@"" imageNamed:imageName linkedUrl:url] autorelease];
	[submitTextCell setSocialNotificationImageName:imageName];
}

-(void)setImageType:(NSString*)imageType imageId:(NSString*)imageId linkedUrl:(NSString*)url
{
	self.notification = [[[OFSocialNotification alloc] initWithText:@"" imageType:imageType imageId:imageId linkedUrl:url] autorelease];
	//Don't know what to set for submit TextCell setDefaultImageName here....
}

-(void)setDismissDashboardWhenSent:(BOOL)_dismissDashboard
{
	dismissDashboardWhenSent = _dismissDashboard;
}

+(void)dismiss
{
	if(dismissDashboardWhenSent)
	{
		[OpenFeint dismissDashboard];
	}
	else
	{
		[[OpenFeint getActiveNavigationController] popViewControllerAnimated:YES];
	}
}

+(void)sendSuccess
{
	[self dismiss];
}

+(void)sendFailure
{
	//We do not dismiss on failure because its the server's way of telling us we need extended credentials from facebook (or something REALLY wonky went wrong that I haven't seen).
	//In the facebook case, we pop up a modal over this controller for facebook extended credentials and try to resend when that was successfull.  If the facebook dialog is skipped,
	//that controller calls dismiss on us manually, see OFFacebookExtendedCredentialController.mm
	//[self dismiss];
}

- (void)dealloc
{
	self.notification = nil;
	self.submitTextCell = nil;
	[super dealloc];
}

@end
