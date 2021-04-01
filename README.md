# ChalkSeven
![](http://www.jacklandrin.com/wp-content/uploads/2021/04/chalk7_180-1.png)
![](https://img.shields.io/badge/UI-SwiftUI-blue) ![](https://img.shields.io/badge/platform-iOS-lightgrey) ![](https://img.shields.io/badge/license-MIT-brightgreen)
## What is ChalkSeven?
**ChalkSeven** is a drop 7 game developed with SwiftUI. You can drop down a ball with number to a proper location into the grid. If a ball's number equals the count of continuous balls in its row or column, the ball will explode. Besides, there are two special balls, **solid ball** and **pending ball**. If a solid ball nearby a ball exploding, it'll be a pending ball; if a pending ball nearby a ball exploding, it'll be a normal ball with a number.

In every level, you have 20 opportunities to drop balls. When you finish your all balls, a row of solid balls will emerge from the bottom to thrust up the balls in the grid. If these balls could be pushed out of the grid, the game will be over.

Have fun!

![](http://www.jacklandrin.com/wp-content/uploads/2020/04/chalkball_demo-1.png)

The git address is <https://github.com/jacklandrin/ChalkSeven>
## References
Thank Anh, mixkit and freesound for effect sounds. The background music is created by Anh. The other effect sounds come from these sources:
* https://mixkit.co/free-sound-effects/game/?page=2 
* https://freesound.org/people/cameronmusic/sounds/138410/
* https://freesound.org/people/ash_rez/sounds/518887/
* https://freesound.org/people/Mr._Fritz_/sounds/544015/

## Requirement
* iOS 13
* Swift 5.2
* Xcode 11