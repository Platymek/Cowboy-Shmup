prototypes are ordered where higher headings are newer
# 07-26 first level draft
started first level draft
# 07-06 Spawn Manager First Plan
a list which spawns characters, where a condition must be met for the wave to be spawned and the spawner to move on
- enemies have values which are taken when defeated. The condition is a certain value. The score resets to zero on surpass
- conditions where, if not met, go to another specified wave
- time condition
- simple all enemies defeated condition or specific enemy defeated condition
- spawn the next wave only if a specific enemy has been defeated
- a condition which skips ahead to another condition

this means that conditions:
- may sometimes need to know about each other
	- stored condition: if going back to a previous condition, store this one. Perhaps a range is specified which it sticks to. Too restrictive, complicated and prone to problems?
	- conditions can call other conditions. Perhaps the manager has a call condition function which it uses by default on the current condition but can be called and used when passed through the condition functions to call a later one
	- perhaps they don't. Could conditions contain spawn managers?
	- or maybe their state is always present. Therefore they can just store and skip to a different conditions if not fulfilled. But, then how would the value spawner work?
	- not much state is needed. Perhaps a simpler way would be to just give the manager a value variable with conditions that just return true and save. The enemy component can just be given a value property
	- a separate scorer can be created which attaches value with a custom component on spawn

each condition should be:
- a class which inherits from a base class
- have a constructer which makes generation easy

the base class constructer should have params:
- each delegate takes in the spawn manager class
- condition delegate: runs a function and returns true or false if successful
- success delegate: if condition delegate is true
	- default: spawn whole wave and increase counter
- fail delegate: if condition delegate is false
	- default: nothing

therefore, there should be functions for:
- spawn enemy(index, x):
	- each enemy is given an index
	- creates the enemy and returns it
- spawn map line (x, y): 
	- spawns a wave of enemies based on the specified line placing the tiles into the spawn enemy function
	- y is the y value of the specified line
	- x is multiplied by 16 for ease of use
	- returns a list of the spawned enemies
- spawn player():
	- creates the player
## spawn manager
class which takes in a list of spawn conditions and gets to freaking work on them. Params:
- spawn conditions list

properties:
- spawn list
- start(): starts/ un pauses the spawning. NOT started automatically
- pause(): pauses the spawning
- clear(): removes all current conditions from the spawn list and reset the current condition index to 0
- run condition(index): calls this condition. Does this by default every frame on the current condition index. This can therefore be called by conditions to check other conditions
- current condition: the index of the current condition being checked every frame
## so a level would go like...
1. first spawn condition is a timer which spawns the first wave after a set amount of time
2. then...
	- spawn the next wave on a timer
	- introduce an enemy by spawning it and only moving on once it has been defeated
	- keep spawning a set of waves on loop until a condition is defeated like defeating a specific character
	- spawn a wave. Then, after some of the wave is defeated, spawn the next sub wave
3. finally, tell the game that it has finished on the last condition after a short time has passed
## finalisation of spawn conditions to try out
### utility
timer
- prevents moving onto the next object until a time is met

moves onto the specified condition when
- time
- x, y: row position to spawn

value condition:
- contains an internal value variable
- if the value has met a threshold, allow skipping to the next condition. Otherwise, go back to a specified condition

clear:
- clears the spawn queue
- on clear function does something
- can be used for memory management or ending the game
### spawners
spawn
- x, y: row position to spawn

death condition:
- spawns an enemy
- if the enemy has been defeated yet, go to a specific condition
- otherwise, go to another

value spawner:
- spawns enemies and gives them on death components which add score to the specified value condition on death
# 27-05 initial character prototype
player character controller and a concept of an enemy
## evaluation
the health system feels pointless when the game is designed around not letting enemies reach the bottom of the screen. The following changes will be made:
- when the player is hurt, they are just stunned and knocked back, wasting time and allowing the enemies to get back. This is really frustrating but in a good way I think?
- health will deplete on enemies reaching the bottom. Should they stay there and still shoot the player, though?

I might also try the following:
- make characters bigger. This includes trying to make art for the player and the test enemy
## plan
player character controller and extremely simple test enemy

reqs:
- shoot button in 3 directions
- reload button, which reloads one bullet
- a simple enemy which fires bullets in multiple directions
- simple hud

`Circle` class:
- overrides `Position` from `pico-badger`
- global
- `:new(r, [x, y])`
	- `r`: radius
	- `x, y`: default to 0
- `:isIntersecting(circle)`: checks if two circles are intersecting
- `:getOffset(x, y)`: gets offset circle object

`conf` class:
- stores game properties
- `.p`: player properties
	- `.speed`: speed
	- `.stunRel`: reload stun duration
	- `.stunSho`: shoot stun duration
	- `.maxAmmo`: max ammo

`hud` object:
- shows relevant info, changed using functions:
	- health: `setHealth`
	- ammo: `setAmmo`
- `draw`: draws the hud on screen
- does this using functions

`g` singleton:
- stores custom components and world
- global but not always `nil`
- `initialise()`
	- creates world
	- initialises all required components
	- returns `g` table
	- set to `nil` when finished using
- `update(dt)`
	- calls all required update functions and systems
- `draw()`
	- calls all required drawing functions

player entity:
- position, velocity, collision
- hurtbox
- health
- `Player` component
	- `.state`: the current state of the player
	- `.stun`: do not let the player leave the current state until this is 0
	- `.ammo`: current ammo count
- `new(x, y)`

player states:
1. idle:
	- player can move around
	- if `x` pressed and ammo, go to shoot, else go to reload
	- if `o` pressed, reload
2. shoot:
	- on enter: create bullet and add `cong.p.stunRel` to stun
	- player is stunned
	- create bullet entity
3. reload:
	- on enter: reload a bullet and add `cong.p.stunRel` to stun

bullet entity:
- position, velocity
- `:new(x, y, r, angle, speed, [colour])`
	- angle, speed: the angle and speed to fire the bullet
	- colour: the colour of the outer bullet

enemy entity:
- slowly walks down
- shoots towards player a line of 3 bullets
- when bottom of screen reached, stand still and keep shooting
- `:new(x)`
	- automatically spawns at top of speed
- `conf.e`:
	- `speed`: how quickly the enemy walks down
	- `bn`: number of bullets fired
	- `bs`:
- `conf`:
	- `sl`: list of small lanes. There should be abou

custom components, created using `getGameComponents(world, bc)`:
created using `getGameComponents(world, bc)`
- `world`: `pecs` world
- `bc`: `pico-badger` components
- returns an object with the following components
`Hitbox`
- hits hurtboxes
- overrides `Circle`
- automatically hurts health if present
- `.new.HitBox(team, r, x, y, [onHurt])`
	- `team`: team. Can only hurt other teams. If `nil` damages all teams
	- `onHurt`: func/s called when hurt, with params:
		- `me, you`
		- default: empty
`HurtBox`
- his hit by hitboxes
- overrides `Circle`
- `.new.HurtBox(team, r, x, y, [onHit])`
	- `team`: team. Can only be hurt by other teams. If `nil`, is damaged by all teams
`BulletSprite`
- draws a bullet sprite composed of two circles
- `newBulletSprite(colour, r)`
	- `r`: radius
`Health`
- records health of characters
- `newHealth(max, [onHurt, val])`
	- `max`: max health
	- `onHurt(newHealth)`: when hurt call func/s. Params:
		- `newHealth`: new health value
		- default: `nil`
	- `val`: current value
- `inv`: if the character is currently invincible, do not hurt