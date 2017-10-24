# Next things
send endGameImage to gameSessionDbRef.endGameImage

in GameStateModel always be listening for endGameImage value change. Send message to MainGameViewController, pass in image

---

Jump to definition of mapview.remove annotation
See if it's equatable. See how it identifies it. Also see if it duplicates the same mk annotation if it's already in the list. This is so you can know how to remove your observers of LocationModel

### later

reframe small map view whenever new annotation pin gets added

for finishing game, first code up:
	take snapshot, send snapshot to opponent, opponent gets notified, "so and so found you!" with photo displaying, then click done, then finish game locally
	then later try code up accept or reject options

do memory efficiency stuff
	pause scenes and views when they disappear
	remove FireBase observers
	set Map delegates to nil
	remove LocationModel Observers

change bottom map view "inivisible button" to a gesture recogniser for single tap, so that the user can still zoom in and out on the map view

double check what methods should be implemented for cllocationmanagerdelegate protocol
websites:
1. [Choosing the Authorization Level for Location Services](https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services)
2. [Requesting when in use authorization](https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services/requesting_when_in_use_authorization)
3. [Determining the Availability of Location Services](https://developer.apple.com/documentation/corelocation/determining_the_availability_of_location_services)

later (add to ZenHub) add badge to home tab bar view for new game requests

---

# Implementation  
## Location  

if pin is more than 100 metres away from current location, then don't scale and make it 150m altitude. Else scale and 30m altitude

--

# Other things you may want to review  
- research Xcode UICollectionView (more powerful version of tableview)  
- check out gamekit for chat function and "replay" thing  
	- https://developer.apple.com/games/  
	- https://developer.apple.com/videos/play/wwdc2015/605/  
