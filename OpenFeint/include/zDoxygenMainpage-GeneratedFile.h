/** @mainpage 
<div id="header">
	<div id="container">
		<div class="logo"><img src="http://openfeint.com/images/of_devSupport.png" style="border:none;" /></div>
    </div>
</div>
<table border="0">
<tr>
<td valign="top">
<h3>Platform: OpenFeint iOS SDK 2.8</h3>
<div id="importable">
<h4>Readme.html for OpenFeint iOS SDK 2.8<br/>Release date 12.10.2010 <br/>
Release Notes Copyright (c) 2009-2010 Aurora Feint Inc. <br/>
All Rights Reserved. </h4>
</td>
<td width="40%">
&nbsp;
</td>
<td style="border-width: 1px; border-style: solid;">
<h3>&nbsp;&nbsp;In this document&nbsp;&nbsp;</h3>
<ul>
<li><a href="#new">&nbsp;&nbsp;New in OpenFeint iOS SDK Version 2.8&nbsp;&nbsp;</a><br/>
</li><li><a href="#integration">&nbsp;&nbsp;Integration Notes&nbsp;&nbsp;</a><br/>
</li><li><a href="#qs">&nbsp;&nbsp;OpenFeint iOS Quick Start Guide&nbsp;&nbsp;</a><br/>
</li><li><a href="releasing">&nbsp;&nbsp;Releasing your title with OpenFeint&nbsp;&nbsp;</a><br/>
</li><li><a href="using">&nbsp;&nbsp;How To Use OpenFeint&nbsp;&nbsp;</a><br/>
</li><li><a href="changelog">&nbsp;&nbsp;Changelog&nbsp;&nbsp;</a><br/>
</li></ul></td>
</tr>
</table>

<h4><a name="new"></a>New in OpenFeint iOS SDK Version 2.8</h4>
New Features
<ul>
<li>Local database now is initialized with achievement definitions from the offline_config.xml (if you download a new offline config.xml)</li>
<li>You can now retrieve an Array of scores near the current player.  You specify how many "above" and "below" the current players score you want to retrieve.</li>
<li>The player now initiates sending scores and achievement brags to social network through the OpenFeint dashboard. There is no more automatic posting.</li>
<li>Created a api for getting a time stamp from the OF Server</li>
<li>Minor bug fixes</li>
</ul>
<h4><a name="integration"></a>Integration Notes</h4>
Social Notifications API has a new method in place of the old method:
<pre>
+ (void)sendWithPrepopulatedText:(NSString*)text originalMessge:(NSString*)message imageName(NSString*)imageName.
</pre>
This is now the only acceptable way to send a social notification though our application.  No developer may call other method to send a social notification through openfeint at risk of being shut off from OpenFeint.  Sending social notifications in other manners puts OpenFeint in violation of Facebook terms of service.

<h4><a name="qs"></a>OpenFeint iOS Quick Start Guide</h4>
The steps necessary to start developing your first OpenFeint-enabled game on iOS are:

<ol>
<li>Make sure that you have XCode version 3.2.2.</li>
<li>Make sure that you are building with Base SDK of 3.0 or newer.</li>
<li>Make sure you have the current version of OpenFeint. Unzip the file.</li>
<li>If you have previously used OpenFeint, delete the existing group reference from your project.</li>
<li>If you have previously used OpenFeint, delete your build directory. Otherwise xcode might get confused and the game will crash because xcode didn't realize a <b>.xib</b> file changed.</li>
<li>Drag and drop the unzipped folder titled OpenFeint onto your project in XCode. Make sure it's included as a group and not a folder reference.</li>
<li>Remove unused asset folders. This is not a necessary step but helps cut down the application size. You need to do this every time you download a new OpenFeint project.
<ul>
	<li>If your game is landscape only or iPad only delete the iPhone_Portrait folder.</li>
	<li>If your game is portrait only or iPad only delete the iPhone_Landscape folder.</li>
	<li>If your game does not support the iPad delete the iPad folder.</li>
</ul>
</li>
<li>Right click on your project icon in the Groups & Files pane. Select Get Info.
       <ul>
	   		<li>Select the Build tab. Make sure you have Configuration set to All Configurations.</li>
       		<li>Add the value <code>-ObjC</code> to <b>Other Linker Flags</b> </li>
		 <br/>** NOTE: If the current value says <Multiple values> then you may not add the -ObjC flag for "All Configurations"
		 <br/>**       but you must instead do it one configuration at a time.</li>
		 <li>Make sure that <b>Call C++ Default Ctors/Dtors in Objective-C</b> is checked under the <b>GCC 4.2 - Code Generation</b> section.
       <br/>* NOTE: If you are using an older version of Xcode, you may have to add this as a player-defined setting. 
       (Set <code>GCC_OBJC_CALL_CXX_CDTORS</code> to <code>YES</code>.)</li>
		</ul>
</li>
<li>Make sure that the following frameworks are included in your link step:<br/>
   (do this by right clicking on your project and selecting <b>Add->Existing Frameworks...</b>)
       <ul>
       <li><code>Foundation</code></li>
       <li><code>UIKit</code></li>
       <li><code>CoreGraphics</code></li>
       <li><code>QuartzCore</code></li>
       <li><code>Security</code></li>
       <li><code>SystemConfiguration</code></li>
       <li><code>libsqlite3.0.dylib</code> (located in <code><i>iPhoneSDK_Folder</i>/usr/lib/</code>)</li>
       <li><code>CFNetwork</code></li>
       <li><code>CoreLocation</code></li>
       <li><code>MapKit</code></li>
       <li><code>libz.1.2.3.dylib</code> (alternatively, you can add a <code>OF_EXCLUDE_ZLIB</code> preprocessor definition)</li>
       <li><code>AddressBook</code></li>
       <li><code>AddressBookUI</code></li>
       <li><code>GameKit</code> (only if your are using OpenFeint GameCenter integration)</li>
	   </ul>
</li>
<li>We recommend that you specify the latest available released version of the iOS SDK
   as your base SDK and specify iOS 3.0 as the deployment target so that your app will
   will also support older devices.  Specify the base SDK in the pull down menu in the
   upper left of the XCode project window.  Specify the deployment target in the project
   settings.  OpenFeint does not support versions of iOS older than iOS 3.0.
</li>
<li>If you specify a deployment target older than the base SDK, the following frameworks
   should use "weak linking":
       <ul>
       <li><code>UIKit</code></li>
       <li><code>MapKit</code></li>
       <li><code>GameKit</code></li>
	   </ul>
   To specify weak linking, right click on the build target, select the "General" tab,
   and in the "type" column change from "Required" to "Weak" for the selected framework.
</ul>
<li>You must have a prefix header. The following line must be in the prefix header: 
<pre>
#import "OpenFeintPrefix.pch"
</pre>
</li>
<li>Source files that reference OpenFeint in any way must be compiled with <b>Objective-C++</b> (Use a .mm file extension, rather than .m).
</li>
</ol>
<h4><a name="releasing"></a>Releasing your title with OpenFeint</h4>
To release your title with OpenFeint:
<ul>
<li>Register an Application on api.openfeint.com</li>
<li>Use the ProductKey and ProductSecret for your registered application.</li>
<li>When launching your app, OpenFeint will print out what servers it is using to the console/log using NSLog. 
  <br/>NOTE: Make sure your application is using https://api.openfeint.com/</li>
<li>Make sure your offline configuration XML file is up to date. This file is downloadable in the developer dashboard under the
<b>Offline</b> section. Download this file again every time you change something in the developer dashboard.
</li>
</ul>
<h4><a name="using"></a>How To Use OpenFeint</h4>
<b>Initializing OpenFeint</b></p> 
Initialize OpenFeint on the title screen after you've displayed any splash screens. When you first initialize OpenFeint, it 
presents a modal dialog box to conform with Apple regulations.
<p>To initialize OpenFeint, use this function call:<br> 
<pre>[OpenFeint initializeWithProductKey:andSecret:andDisplayName:andSettings:andDelegates:];</pre></p> 
<ul> 
<li><code>ProductKey</code> and <code>Secret</code> are strings obtained by registering your application at <a href="https://api.openfeint.com">https://api.openfeint.com</a></li> 
<li><code>DisplayName</code> is the string name we will use to refer to your application throughout OpenFeint.</li> 
<li><code>Settings</code> is dictionary of settings (detailed below) that allow you to customize OpenFeint.</li> 
<li>Delegates is a container object that allows y</li><li>ou to provide desired delegate objects pertaining to specific OpenFeint features.</li> 
</ul> 
 
<p><b>Shutting down OpenFeint</b></p> 
To  shut OpenFeint down, make the following function call:
<pre>[OpenFeint shutdown];</pre> 

<p><b>Additional required functions</b></p> 
Developers are required to notify OpenFeint of device lock / unlock events in order to reduce processing and save battery: 
<pre>[OpenFeint applicationDidBecomeActive];</pre> 
This method should be invoked from the <code>UIApplicationDelegate</code> object's <code>applicationDidBecomeActive:</code> method. 
<pre>[OpenFeint applicationWillResignActive];</pre> 
This method should be invoked from the <code>UIApplicationDelegate</code> object's <code>applicationWillResignActive:</code> method. 
 
<p><b>OpenFeint configuration settings</b></p> 
Settings are provided to OpenFeint as an <code>NSDictionary</code>. Here is an example of how to create a settings dictionary for use with the
initialize method:
<pre> 
NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft], OpenFeintSettingDashboardOrientation,
    @"ShortName", OpenFeintSettingShortDisplayName, 
    NSNumber numberWithBool:YES], OpenFeintSettingEnablePushNotifications,
    [NSNumber numberWithBool:NO], OpenFeintSettingDisableChat,
    nil
]; 
</pre> 
More information about each of these settings can be found below. These settings are also described in <b>OpenFeintSettings.h</b>.<br> 
<ul> 
<li><code>OpenFeintSettingRequireAuthorization</code> -  <em>deprecated</em>.</li> 
<li><code>OpenFeintSettingDashboardOrientation</code> -  Specifies orientation in which the OpenFeint dashboard will appear.</li> 
<li><code>OpenFeintSettingShortDisplayName</code> -  In certain areas where the application display name is too long, OpenFeint uses this more compact version of your application's display name. For example, this variable is used for the title of the current game tab in the OpenFeint dashboard.</li> 
<li><code>OpenFeintSettingEnablePushNotifications</code> -  Specifies whether or not your application will be enabling Push Notifications (for Social Challenges, currently).</li> 
<li><code>OpenFeintSettingDisableChat</code> -  Allows you to disable chat for your entire application.</li> 
</ul> 
<p><b>What is the <code>OFDelegatesContainer</code>? Where is the <code>OpenFeintDelegate</code>?</b></p> 
<code>OFDelegatesContainer</code> provides a way for you to specify all of the various delegates that OpenFeint features may require.</p> 
<p>If you are only using an <code>OpenFeintDelegate</code> you may use the simple convenience constructor:
<pre>[OFDelegatesContainer containerWithOpenFeintDelegate:];</pre> 
<p><b>What is OpenFeintDelegate for?</b></p> 
This is the bread-and-butter OpenFeint delegate: 
<pre>- (void)dashboardWillAppear;</pre>
This method is invoked whenever the dashboard is about to appear. We suggest that application developers use this opportunity to pause any logic / drawing while OpenFeint is displaying. 
<pre> - (void)dashboardDidAppear;</pre>  
This method is invoked when the dashboard has finished its animated transition and is now fully visible.
<pre> - (void)dashboardWillDisappear;</pre>  
This method is invoked when the dashboard is about to animate off the screen. We suggest that applications that do not use OpenGL
resume drawing in this method.
<pre> - (void)dashboardDidDisappear;</pre>  
This method is invoked when the dashboard is completed off the screen. We suggest that OpenGL applications resume drawing here, and all applications resume any paused logic / gameplay here.
<pre> - (void)playerLoggedIn:(NSString*)playerId;</pre>  
This method is invoked whenever an application successfully connects to OpenFeint with a logged in player. The single parameter is the OpenFeint player id of the logged in player.
<pre> - (BOOL)showCustomOpenFeintApprovalScreen;</pre>  
This method is invoked when OpenFeint is about to show the welcome / approval screen that asks a player if they would like to use OpenFeint. You can learn more about <a href="http://www.openfeint.com/ofdeveloper/index.php/kb/article/000024">customizing
the approval screen here</a>.
<p><b>OFNotificationDelegate</b></p> 
This delegate deals with the in-game notification pop-ups that OpenFeint displays in response to certain events including high score submission, achievement unlocks, and social challenges. You can find more details by referencing the <a href="http://help.openfeint.com/faqs/api-features/notification-pop-ups">API feature article on notification pop-ups</a>qqq--This is a bad link--qqq.</p> 
<p><b>OFChallengeDelegate</b></p>
This delegate deals with the Social Challenges API feature. You can find more details by referencing the qqq--Joe this article is ported to WP @ http://wordpress.of.c43893.blueboxgrid.com/wordpress/dev/ios-dev-2/introduction-to-challenges/ -- qqq <a href="http://www.openfeint.com/ofdeveloper/index.php/kb/article/000027">Social Challenges feature article</a>.
<p><b>Launching the OpenFeint dashboard</b></p> 
The most basic launch of the OpenFeint dashboard is accomplished with a single function call:<br> 
<pre>[OpenFeint launchDashboard];</pre>
You can also launch the dashboard with a specific OpenFeintDelegate for use only during this launch using:<br> 
<pre>[OpenFeint launchDashboardWithDelegate:];</pre>  
In addition, OpenFeint provides a suite of methods for launching the dashboard to a pre-defined tab or page. These are documented in the header file <b>OpenFeint+Dashboard.h</b>. 
<pre> +
(void)launchDashboardWithListLeaderboardsPage;</pre>  
Invoke this method to launch the OpenFeint dashboard to the leaderboard list page for your application. 
<pre> +
(void)launchDashboardWithHighscorePage:(NSString*)leaderboardId;</pre>
Invoke this method to launch the OpenFeint dashboard to a specific leaderboard page. You must pass in a string representing the unique ID of the leaderboard you wish to view which can be obtained from the Developer Dashboard.
<pre> + (void)launchDashboardWithAchievementsPage;</pre>  
Invoke this method to launch the OpenFeint dashboard to the achievements list page for your application.
<pre> + (void)launchDashboardWithChallengesPage;</pre>  
Invoke this method to launch the OpenFeint dashboard to the challenge list page for your application.
<pre> + (void)launchDashboardWithFindFriendsPage;</pre>
Invoke this method to launch the OpenFeint dashboard to the <b>Find friends</b> page, which prompts the player to use Twitter, Facebook, or a playername search to locate friends in OpenFeint.
<pre> + (void)launchDashboardWithWhosPlayingPage;</pre>  
Invoke this method to launch the OpenFeint dashboard to a page which lists OpenFeint friends who are also playing your application. 
<p><b>Orientation and View Controller information</b></p> 
The OpenFeint dashboard supports being displayed in <em>any</em> orientation you desire. It <em>will not</em>, however, change orientations while it is being displayed.
<p>Developers use the OpenFeintSettingDashboardOrientation to control the initial orientation. If you wish to change the orientation over the course of the application you may invoke:
<pre>[OpenFeint setDashboardOrientation:];</pre>  
Generally this is done by applications which want to support multiple orientations in the UIViewController method <code>didRotateFromInterfaceOrientation:</code>.
<br/>If your application is using a view controller with a non-portrait layout then you are required to invoke and return the following method in your <code>UIViewController</code>'s <code>shouldAutorotateToInterfaceOrientation</code> method.
<pre>[OpenFeint shouldAutorotateToInterfaceOrientation:withSupportedOrientations:andCount:];</pre>  
Here is an example implementation of <code>shouldAutorotateToInterfaceOrientation:</code> 
<pre> 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    const unsigned int numOrientations = 4;
    UIInterfaceOrientation myOrientations[numOrientations] = 
    { 
        UIInterfaceOrientationPortrait, UIInterfaceOrientationLandscapeLeft, 
        UIInterfaceOrientationLandscapeRight, UIInterfaceOrientationPortraitUpsideDown
    };
 
    return [OpenFeint 
        shouldAutorotateToInterfaceOrientation:interfaceOrientation 
        withSupportedOrientations:myOrientations 
        andCount:numOrientations];
}</pre> 

<hr />
<h4><a name="changelog"></a>Changelog</h4>
<hr/>
Version 2.7.4, 10.11.2010 
<hr/>
<ul><li>Fixed an issue where high score blobs were not being uploaded if GameCenter failed to submit, but OpenFeint successfully submitted
</li><li>Fixed issues where OpenFeint was pulling some information from the servers for the dashboard when the dashboard was not open and the information wasn't needed.
</li><li>Show correctly formatted scores in OpenFeint Leaderboards when displaying a GameCenter score in an OpenFeint Leaderboard view.
</li><li>Fixed returning of request handles on some apis that were not returning OFRequestHandles properly.
</li><li>Fixed the getFriends api in OFPlayer so that we always return you the OFPlayer's full list of friends with no duplicates.
</li><li>The sample App now includes a section in which you can launch directly to dashboard pages.
</li><li>Magnifying glass now works on IM input field.
</li><li>OFNotification's text now stretch properly in landscape.
</li><li>The player is now only prompted to login to GameCenter at initialization of an app that supports game center, not when the app is brought back to the foreground from being in the background.
</li><li>If updating from pre-2.7, achievements that are unlocked won't "unlock again".
</li><li>OpenFeint location queries are stopped if the app goes to the background, and restarted when coming to the foreground if they were stopped.
</li><li>The GameCenter intro page will no longer say "Now Playing <Application Name>", but will actually state the name of your game.
</li></ul>
<hr/>
Version 2.7.3, 9.28.2010
<hr/>
<ul><li>Fixed an issue with timescoped leaderboards in GameCenter updating properly.
</li><li>Made opening to achievements page not crash
</li></ul>
<hr/>
Version 2.7.1 9.16.2010 
<hr/>
<ul><li>Fixed an issue that was preventing GameCenter submission if the player declined OpenFeint
</li></ul>
<hr/>
Version 2.7 9.15.2010 
<hr/>
<ul><li>Achievements now accept a percent complete.  Passing 100.0 as the percent complete unlocks the achievement.
</li><li>Game Center is now integrated into OpenFeint.  You may now link OpenFeint Achievements and Leaderboards to GameCenter Achievements and Leaderboards.
  See OFGameCenter.plist to see how to defining the linking between GameCenter and OpenFeint Achievements and Leaderboards.
  Also add [NSNumber numberWithBool:YES], OpenFeintSettingGameCenterEnabled to the settings dictionary that is passed when initializing OpenFeint to enable integration.
</li><li>Notification have a new look.
</li><li>Notifications pop in from the top and bottom on iPhone and from the corners on iPad. Add something like this to your settings dictionary to specify where the notifications should appear:
  <pre>NSNumber numberWithUnsignedInt:ENotificationPosition_TOP], OpenFeintSettingNotificationPosition</pre>
  For the iPhone you should choose one of these options:<ul>
<li><code>ENotificationPosition_TOP</code></li><li><code>ENotificationPosition_BOTTOM</code></li></ul>
  For iPad you should choose one of these options:
	<ul><li><code>ENotificationPosition_TOP_LEFT</code></li>
	<li><code>ENotificationPosition_BOTTOM_LEFT</code></li>
	<li><code>ENotificationPosition_TOP_RIGHT</code></li>
	<li><code>ENotificationPosition_BOTTOM_RIGHT</code></li>
</li><li>Notifications no longer Open the dashboard if the player clicks them, they accept no more input from the player.
</li><li>Social notifications now have a delegate to see if posting a social notification was successful or not.
</li><li>Announcements now have a field for the original posting date of the announcement (the date is actually the date of the last reply to the announcement).
</li><li>Time scoped leaderboard information is now available in the dashboard.
</li><li>Fixed an issue that was preventing GameCenter submission if the player declined OpenFeint
</li></ul></ul>
<hr/>
Version 2.6.1 8.26.2010 
<hr/>
<ul><li>Bugfixes</li></ul>
<hr/>
Version 2.6. 8.18.2010 
<hr/>
<ul><li>Time-scoped Leaderboard view
	<ul><li>All Time / This week / Today replace Global / Friends / Near Me tabs
	</li><li>Each page shows the player's score, friends scores, and global scores in different sections.
	</li><li>The compass/arrow icon in the upper right launches the map view</li></ul></li>
	<li>Out of Network Invites
	<br>Players can now choose from their Contact List and send invites via SMS or E-mail
</li></ul>
<hr/>
Version 2.5.1, 7.14.2010 
<hr/>
<ul><li>Unity support updated for iOS4
</li><li>A handful of bugfixes from 2.5
</li></ul>
<hr/>
Version 2.5, 7.2.2010 
<hr/>
<ul><li>New and greatly improved (fully documented) APIs for:
<ul><li>Leaderboards</li>
<li>Scores</li>
<li>Announcements</li>
<li>Achievements</li>
<li>Challenges</li>
<li>Cloud Storage</li>
<li>Invites</li>
<li>Featured Games</li>
<li>Social Notifications</li>
<li>Current Player & other Players</li></ul>
</li><li>Exposes easy to use advanced features such as announcements and invitations.
</li><li>Old APIs remain untouched for compatibility.
</li><li>All new APIs use doxygen style comments. A doxygen docset is included in <b>documents/OpenFeint_DocSet.zip</b> for the new APIs.
</li><li>Find all new api header files and documentation in the include folder. 
</li><li>Sample application has been updated to showcase all of the new APIs.
</li><li>Added support for "distributed scores". A new feature used to pull down a wide set of highscores to show during gameplay. See <code>OFDistributedScoreEnumerator</code>.
</li></ul>
<hr/>
Version 2.4.10 (6.10.2010)
<hr/>
<ul><li>Fixes for iOS4 compatibility</li></ul>
<hr/>
Version 2.4.9 (5.28.2010)
<hr/>
<ul><li>Primarily a maintenance release in preparation for OpenFeint 2.5.
</li><li>Bug-fixes
</li></ul>
<hr/>
Version 2.4.8 (5.12.2010)
<hr/>
<ul><li>Fixed a crash when viewing pressing the near me tab on a leaderboard on the iPad after removing all of the iPhone asset folders
</li><li>Fixed some code introduced in 2.4.7 that didn't allow you to use the "Compile as ObjC++" flag anymore.
</li></ul>
<hr/>
Version 2.4.7 (5.7.2010)
<hr/>
<ul><li>Support for universal builds between iPhone and iPad
</li><li>Support for rotating the device while in the OpenFeint dashboard on iPad
</li><li>Fixed a crash bug on iPad that could occur if the game does not use a view controller
</li><li>Fix a bug that caused high scores to say "Not Ranked" if the player had a score but was ranked above 100.000
</li><li>Fixed lots of minor bugs 
</li></ul>
<hr/>
Version 2.4.6 (4.3.2010)
<hr/>
<ul><li>iPad support
</li><li>Minor bug fixes
</li></ul>
<hr/>
Version 2.4.5 (3.16.2010)
<hr/>
<ul><li>There is a new setting called OpenFeintSettingDisableCloudStorageCompression. Set it to true to disable compression. This is global for all high score blobs.
</li><li>There is a new setting called OpenFeintSettingOutputCloudStorageCompressionRatio. When set to true it will print the compression ratio to the console whenever compressing a blob.
</li><li>High Score blobs
    <br/>Attach a blob when uploading high scores. When a player views a high score with a blob the cell has a film strip button on it. 
      <br/>Pressing the film strip button downloads the blob and passes it off to the game through the OpenFeint delegate.<br/>
</li><li>Social Invites
    <br/>Player may from the Fan Club invite his friends to download the game. The functionality can also be use directly through the OFInviteService API.
</li><li>Added post count to forum thread cells
</li><li>Drastically improved load times on a majority of the screens with tables in them
</li><li>Some minor bug fixes
</li></ul>
<hr/>
Version 2.4.4 (2.18.2010)
<hr/>
<ul><li>Fixed the (null) : (null) errors when submitting incorrect data in various forms
</li><li>Feint Five screen supports shaking the device to shuffle 
</li><li>Sample application improvements and bugfixes
</li><li>Updated Unity support
</li></ul>
<hr/>
Version 2.4.3 (2.3.2010)
<hr/>
<ul><li>Replaced our use of NSXMLParser with the significantly faster Parsifal
  <br/>Specific information about Parsifal can be found here: <b>http://www.saunalahti.fi/~samiuus/toni/xmlproc/</b>
</li><li>The SDK will now compile even if you are forcing everything to be compiled as Objective-C++ (<code>GCC_INPUT_FILETYPE</code>)
</li><li>Various bugfixes:<ul><li>Crash on 2.x devices when tapping the banner before it was populated
  </li><li>Failure to show a notification when posting the first high score to an ascending leaderboard
  </li><li>Deprecation warning in OFSelectProfilePictureController when iPhoneOS Deployment Target is set to 3.1 or higher
</li></ul>
</li></ul>
<hr/>
Version 2.4.2 (1.18.2010)
<hr/>
<ul><li>High Score notifications will only be shown when the new score is better than the old score.
  </li><li>This only applies to leaderboards where 'Allow Worse Scores' is not checked
  </li><li>This also means that high scores that are not better will not generate a server request
</li><li>'Play Challenge' button is click-able again
</li><li>Updated Unity support
</li><li>Other bug fixes
</li></ul>
<hr/>
Version 2.4.1 (1.7.2010)
<hr/>
<ul><li>Portrait support is back
</li><li>Bug fixes!
</li><li>Improved player experience in Forums
</li></ul>
<hr/>
Version 2.4 (12.17.2009)
<hr/>
<ul><li>New UI:<br/>New clean and player-friendly look.
    </li><li>New simplified organization with only three tabs. One for the game, one for the player and one for game discovery.
</li><li>Cloud Storage
    </li><li>Upload data and store it on the OpenFeint servers.
    </li><li>Share save data between multiple devices so the player never has to lose his progress.
</li><li>Geolocation
    <ul><li>Allow players to compete with players nearby.
    </li><li>Distance based leaderboards.
    </li><li>Map view with player scores near you.
    </li><li>All location-based functionality is opt-in.
</li></ul></li><li>Presence
    <ul><li>The player can immediately see when his or her friends come online through in-game notification.
    </li><li>Friends page has a section for all friends who are currently online.
    </li><li>All presence functionality is opt-in.</li></ul>
</li><li>IM
    <ul><li>The player can send private messages to his or her friends.
    </li><li>Real-time notifications of new messages are sent through presence.
    </li><li>IM page is updated in real-time allowing synchronous chat.
    </li><li>Messages can be received when offline and new messages are indicated with a badge within the OpenFeint dashboard.
    </li><li>Conversation history with each player is preserved the same as in the SMS app.
</li></ul></li><li>Forums
    <ul><li>Players can now form a community within the game itself.
    </li><li>Global, developer and game specific forums.
    </li><li>Forums can be moderated through the developer dashboard.
    </li><li>Players can report other players, a certain number of reports will remove a post/thread and ban the player for a time period.
    </li><li>Add a thread to My Conversations to get notified of new posts in it.
</li></ul></li><li>My Conversations
    <br/>A single go-to place where the player can see all of his or her IM conversations and favorite forum threads.
</li><li>Custom Profile Picture
    <br/>Players can now upload a profile picture from their album or take one using the device’s camera.
</li><li>Ticker
    <ul><li>The OpenFeint dashboard now has a persistent marquee at the top of the screen.
    </li><li>Ticker streams interesting information and advice to the player.
</li></ul></li><li>Cross Promotion
    <ul><li>Cross promote between your own games or team up with other developers to cross promote their games.
    </li><li>New banner on the dashboard landing page where you can cross promote other games.
    </li><li>Add games to promote from the developer dashboard.
    </li><li>OpenFeint reserves the right to promote gold games through the banner.
    </li><li>Games you select to cross promote will also be available through the Fan Club and through the Discovery tab.
</li></ul></li><li>Developer Announcements
    <ul><li>Send out announcements about updates, new releases and more to your players directly though your game.
    </li><li>New announcements will be marked with a badge in the OpenFeint dashboard.
    </li><li>Announcements may be linked to a game id and will generate a buy button that linked to the game’s iPurchase page.
    </li><li>Announcements are added through the developer dashboard.
</li></ul></li><li>Developer Newsletter
    <ul><li>Send out email newsletters to your players from the OpenFeint developer dashboard.
    </li><li>Players may opt-in to developer newsletters from the Fan Club.
</li></ul></li><li>Suggest a feature
    <ul><li>Get feedback from your players straight from the game.
    </li><li>Players may give feedback and comment on feedback from the Fan Club.
    </li><li>Player suggestions can be viewed in the developer dashboard where you can also respond directly to the player.
</li></ul></li><li>Add Game as Favorite
    <ul><li>Players now have a way of showing their friends which OpenFeint enabled games are their favorites.
    </li><li>Players can mark a game as a favorite from the Fan Club.
    </li><li>The My Games tab has a new section for favorite games.
    </li><li>When looking at a list of friend’s games, favorites are starred.
    </li><li>When marking a game as favorite, players are asked to comment on why it's a favorite.
    </li><li>When looking at an iPurchase page for a favorite game owned by a friend, comments on why the game is a favorite are displayed.
</li></ul></li><li>Discovery Tab
    <ul><li>The third tab is now the game discovery tab. This is a place where players can come to find new games.
    </li><li>Friends Games section lists games owned by the player’s friends.
    </li><li>The Feint Five section lists five random games. Press shuffle to list five new games.
    </li><li>OpenFeint News provides news about the network.
    </li><li>Featured games lists games featured by OpenFeint.
    </li><li>More Games lists a larger group of games in the OpenFeint network.
    </li><li>Developer Picks section lists games featured by the developer of the game being played.
</li></ul></li><li>Option to display OpenFeint notifications at the top of the screen instead of the bottom.
    <br/>Set <code>OpenFeintSettingInvertNotifications</code> to true when initializing OpenFeint to show notifications from top.
</li><li>Automatically posting to Facebook and Twitter when unlocking an achievement is turned off by default.
    </li><li>Set <code>OpenFeintSettingPromptToPostAchievementUnlock</code> to true to enable automatic posting of social notifications.
</li></ul>
<hr/>
Version 2.3 (10.05.2009)
<hr/>
<ul><li>Multiple Accounts Per Device
    <ul><li>Multiple OpenFeint accounts may be attached to a single device.
    </li><li>When starting a new game, player may choose which player to log in as if there are multiple players attached to his device
    </li><li>When player switches account from the settings tab, he will be presented with a list of accounts tied to the device if there is more than one
    </li><li>Facebook/Twitter may be tied to more than one account
    </li><li>Player will no longer get an error message when trying to attach Facebook/Twitter to an account if that Facebook/Twitter account has already been used by OpenFeint.
	</li></ul></li><li>Select Profile Picture Functionality
    <br/>From the settings tab, player can choose between profile picture from Facebook, Twitter and the standard OpenFeint profile picture.
</li><li>Remove Account From Device
    <br/>Player can completely remove an account from the current device if he wants to sell his device etc.
</li><li>Create New Player
    <br/>From the OpenFeint intro flow or the Switch Player screen, the player may choose to create a new OpenFeint account.
</li><li>Log Out
    </li><li>Player may from the settings tab log out of OpenFeint for the current game. When logged out OpenFeint will act as if you said no to OpenFeint in the first place and not make any server calls.
</li><li>Remove Facebook/Twitter
    <br/>Option on the settings tab to disconnect Facebook or Twitter from the current account
</li></ul>
<hr/>
Version 2.2 (9.29.2009)
<hr/>
<ul><li>Game Profile Pages accessible for any game from any game. Game Profile Page allows you to:
    <ul><li>View Leaderboards
    </li><li>View Achievements
    </li><li>View Challenges
    </li><li>Find out which of your friends are playing
	</li><li>Player Comparison. Tap 'Compare with a Friend' to see how you stack up against your OpenFeint friends!
    </li><li>Browsing into a game profile page through another player's profile will default to comparing against that player.
    </li><li>Game Profile page comparison shows a breakdown of the results for achievements, leaderboards and challenges
    </li><li>Achievements page shows unlocked achievements for each player
    </li><li>Challenges page shows pending challenges between the two players, number of won challenges/ties for each player and challenge history between the two players.
    </li><li>Leaderboards page shows the result for each player for each leaderboard.
</li></ul></li><li>Unregistered player support. Now you can let OpenFeint manage all of your high score data!
    </li><li>Players who opt-out of OpenFeint can still open the dashboard and view their local high scores.
    </li><li>When the player signs up for OpenFeint, any previous scores are attributed to the new player.
    <br/><b>NOTE: </b>To implement this functionality, you <b>must</b> download an offline configuration XML file and add it to your project. You can download this file from the developer dashboard under the <b>Offline</b> section.
      See http://help.openfeint.com/faqs/guides-2/offline qqq--Joe this link is bad.  -- qqq for more information. 
</li><li>Improved offline support:
    <ul><li>More obvious when a player is using OpenFeint in offline mode.
    </li><li>Player no longer need has to be online once for offline leaderboards to work.
</li></ul></li><li>Improved friends list. 
     <br/>Friends list now shows all friends in a alphabetical list.
</li></ul>
<hr/>
Version 2.1.2 (9.09.2009)
<hr/>
<ul><li>Fixed an issue with OpenFeint not initializing properly when player says no to push notifications
</li></ul><hr/>
Version 2.1.1 (8.28.2009)
<hr/>
<ul><li>Fixed compiling issues with Snow Leopard XCode 3.2
</li></ul><hr/>
Version 2.0.2 (7.22.2009)
<hr/>
<ul><li>Added displayText option to highscores. If set this is displayed instead of the score (score is still used for sorting).
</li><li>Removed status bar from the dashboard.
</li><li>Fixed bug that showed a few black frames when opening the OpenFeint dashboard form an OpenGL game.
</li></ul>
<hr/>
Version 2.0.1 (7.13.2009)
<hr/>
<ul><li>Improved OpenFeint "Introduction flow".
</li><li>Player may set their name when first getting an account.
</li><li>Player may import friends from Twitter or Facebook at any time.
</li><li>Nicer landing page in the dashboard encourages player to import friends until he has some.
</li><li>Fixed compatibility issues with using the 3.0 base sdk and 2.x deployment targets.
</li></ul>

<hr/>
Version 2.0 (6.29.2009)
<hr/>
<ul><li>Friends:
<ul><li>A player can import friends from Twitter and Facebook:
</li><li>A player can see all of his or her friends in one place:
</li></ul></li><li>Feint Library: A player can see all the games they've played in once place
</li><li>Social Player Profiles:
</li><li>A player can see the name and avatar of the profile owner:
<ul><li>A player can see all the games the profile owner has played:
</li><li>A player can see all the friends the profile owner has:
</li></ul></li><li>Achievements:
<ul><li>A developer can add up to 100 achievements to a game:
</li><li>Each player has a gamerscore and earns points when unlocking achievements:
</li><li>Achievements can be compared between friends for a particular game:
</li><li>If you do not have any achievements to be compared, there is an iPromote Page link with a call to action prominantly visible
</li><li>Achievements can be unlocked by the game client when on or offline.
<br/>	Achievements unlocked offline are syncronized when next online.
</li></ul><li>Friend Leaderboards:
<ul><li>	A leaderboard can be sorted by friends.
</li><li>	Player avatars are visible on the leaderboard.
</li></ul></li><li>Chat Room:
<ul><li>Each chat message has a player's profile avatar next to it.
</li><li>	Each chat message has some kind of visual representation of the game they are using.
</li><li>	Clicking on a person's chat message takes you to their profile.
</li><li>Chat Room Moderation:
	<ul>
		<li>A player report can optionally include a reason
		</li><li>A player can click <b>Report this player</b> on a player's profile.
		</li><li>A developer can give Moderator privileges to up to 5 players from the dashboard.
		</li><li>When a player has been flagged more than a certain number of times, they are not allowed to chat for a relative amount of time.
		</li><li>If a moderator reports a player, the player is immediately flagged.
</ul></li></li></ul></li><li>Fixed iPhone SDK 3.0 compatibility issues.
</li><li>Many bugfixes.
</li><li>Lots of player interface changes.
</li><li>Lots of Perforamnce improvements.
</li><li>Fixed compatibility with iPod Music Picker.
</li><li>Fixed glitch visual glitch in landscape when running on a 2.0 device and building with the 3.0 SDK
</li></ul>
<hr/>
Version 1.7 (5.29.2009)
<hr/>
<ul><li>Simplified account setup
</li><li>Players can access OpenFeint without setting up an account
</li><li>Login is only required once per device instead of per app
</li><li>3.0 compatibility fixes
</li><li>Various bug fixes
</li></ul>
<hr/>
Version 1.7 (5.22.2009)
<hr/>
<ul><li>Simplified account setup
</li><li>Players can access OpenFeint without setting up an account
</li><li>Login is only required once per device instead of per app
</li><li>3.0 compatibility fixes
</li><li>Various bug fixes
</li></ul>
<hr/>
Version 1.6.1 (5.13.2009)
<hr/>
<ul><li>OpenFeint works properly on 3.0 devices.</li></ul>
<hr/>
Version 1.6 (4.29.2009)
<hr/>
<ul><li>Dashboard now supports landscape (interface orientation is a setting when initializing OF).
</li><li>OpenFeint can now be compiled against any iPhone SDK version
</li><li>Various minor bug-fixes
</li></ul>
<hr/>
Version 1.5 (4.21.2009) 
<hr/>
<ul><li>One Touch iPromote
</li><li>Keyboard can now be toggled in the chat rooms
</li><li>Greatly improved performance and memory usage of chat rooms
</li><li>Profanity Filter is now even more clean.
</li><li>Massive scale improvements
</li><li>Improved internal analytics for tracking OF usage
</li><li>Player conversion rate tracking (view, buy, return)
</li><li>Various minor bug-fixes
</li></ul>
<hr/>
Version 1.0 (3.26.2009)
<hr/>
<ul><li>Players can login with their Facebook accounts (using FBConnect)
</li><li>Every player now has proper account "settings"
</li><li>Global "publishing" permissions are now present on account creation screens
</li><li>Chat scrolling now works properly in 2.0, 2.1, 2.2, and 2.2.1.
</li><li>DashboardDidAppear delegate implemented by request
</li></ul>

<hr/>
Version 3.20.2009
<hr/>
<ul><li>Players can login with other account containers (Twitter)
</li><li>Added global, developer, and game lobbies
</li><li>Developer and game rooms can be configured from developer website
</li><li>Account error handling improved
</li><li>Polling system improvements: remote throttling, disabled when device locks
</li><li>Improved versioning support
</li><li>Leaderboard values can be 64 bit integers (requested feature!)
</li><li>Removed profile screens
</li><li>Added Settings tab with Logout button
</li><li>Final tab organization and art integration
</li><li>Lots of minor bug fixes and tweaks
</li></ul>
<hr/>
Version 3.15.2009
<hr/>
<ul><li>Out of dashboard background notifications
</li><li>Multiple leaderboards for each title (configurable via web site)
</li><li>Landscape keyboard issue addressed
</li><li>Startup time significantly reduced
</li><li>Multi-threaded API calls now work properly
</li><li>Added profanity filter to server
</li><li>Basic request based version tracking
</li><li>Now using HTTPS for all data communication
</li></ul>
<hr/>
Version 3.10.2009
<hr/>
<ul><li>Robust connectivity and server error handling
</li><li>Integration protocol no longer requires all callbacks
</li><li>Various Bugfixes
</li></ul>
<hr/>
Version 3.6.2009
<hr/>
<ul><li>Each game has a dedicated chat room
</li><li>First implementation of background alerts
</li><li>Framework preparation for future features
</li><li>Framework enhancements for table views
</li></ul>
<hr/>
Version 3.3.2009
<hr/>
<ul><li>First pass at Leaderboards ("Global" and "Near You")
</li><li>Tabbed Dashboard with temporary icons
</li><li>OFHighScore API for setting high score
</li><li>OpenFeintDelegate now works
</li><li>OpenFeint api changed to allow a per-dashboard delegate
</li><li>Automatically prompt to setup account before submitting requests
</li><li>Placeholder in-game alerts
</li><li>Better offline and error support
</li><li>Smaller library size (AuroraLib has been mostly removed)
</li></ul>
<hr/>
Version 2.25.2009
<hr/>
<ul><li>First draft public API
</li><li>Placeholder profile
</li><li>Placeholder Dashboard
</li><li>Account create, login, and logout 
</li></ul>
</div>
*/