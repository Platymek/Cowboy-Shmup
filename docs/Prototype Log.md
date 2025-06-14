prototypes are ordered where higher headings are newer
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