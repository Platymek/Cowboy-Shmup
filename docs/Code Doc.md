details functions used to create the game.
# guides
## teams
where functions ask for team values, this is what each one corresponds to so far:

| team  | desc                                              |
| ----- | ------------------------------------------------- |
| `nil` | no team. Hurts and is hurt by others with no team |
| 0     | player                                            |
| 1     | enemy                                             |

## creating a new enemy type
create the enemy script:
```lua
--[[ in new script for enemy ]]

function g.initExample()

	-- create a component
	g.c.Example = g.w.component()

	-- enemy constructer. X is default but make it whatever you want
	function g.new.Example(x)

		local e = g.w.entity()
		-- creating all the components as locals beforehand means they can be called in functions
		local exa = g.c.Example({--[[whatever]]})
		local pos = g.bc.new.Position(x, -8) -- minus height
		local vel = g.bc.new.Velocity(0, 0)
		local ene = g.bc.new.Enemy()
		
		local hea = g.c.new.Health(c.h,
		-- auto kills on death. To be replaced. Replace with whatever u want
        function (val) if val == 0 then e += g.bc.new.Delete() end end)
		
		ene:update = function(dt)
			
			-- update function
		end
		
		-- add other functions to the ene component if needed
		
		-- adding components at the end means comps can be used in functions
		e += ene
		e += exa
		e += pos
		e += vel
		e += hea
		return e
	end
	
	g.c.ExampleSystem = g.w.system({g.c.Example},
	-- function which runs update loop
	function(e, dt) e[g.c.Example]:update(dt) end)
	
	-- sometimes the system isn't needed depending on how simple the entity is
end
```
this is then added to `game.lua`:
```lua

function g:init()

	--...
	g.c.initEne()
	--...
end

function g:update(dt)

	--...
	g.c.EneSystem()
	--...
end
```
# components
found in `src/components.lua`
## `Health`
easy health component which automatically drains when a character is hit

`new.Health(max, onHurt, val)`
## `Tick`
contains a timer which ticks down if above zero. Time must be set manually on every tick

`new.Tick(t, onTick)`
- `t`: current time. If above 0, always ticks down
- `onTick`: calls function/s on time reaching 0. You'd probably want to reset this in this function
## `Hitbox` and `Hurtbox`
inherits `Circle` class from `pico-badger` for collisions

`new.Hitbox(team, r, [x, y, dam, onHurt])`
`new.Hurtbox(team, r, [x, y, onHurt])`
- `x, y`: offset of box. Default: 0, 0
- `dam`: damage of hitbox. Default: 1
- `team`: cannot damage same team unless `nil`
- `onHurt`: called when hit or hurt. Default: `nil`
## `Enemy`
enemy functionality. Currently:
- deletes an enemy once it has left the screen and hurts the game's health value
### System: `EnemySystem()`
uses `Enemy` and `Position`
### System: `HitSystem()`
uses `Hitbox` and `Position`
queries `Hurtbox` and `Position`
## `Parryable` and `ParryDetector`
inherits `Rectangle` from `pico-badger` for collisions. Can be hit with the player's gun during reload for a full ammo refill

`new.Parryable(team, [x, y, w, h, onParry])`
`new.ParryDetector(team, [x, y, w, h, onParry])`
- `x, y, w, h`: `Rectangle` dimensions. Default to 8x8 centred rectangle
- `onParry`: called when parried
### System: `ParrySystem()`
uses `Parryable` and `Position`
queries `Parrydetector` and `Position`
# singleton: `g`
g, standing for game, contains:

| property | desc                                                             |
| -------- | ---------------------------------------------------------------- |
| `w`      | game `pecs` world                                                |
| `bc`     | `pico-badger` components. When using one, use e.g. `bc.Position` |
| `c`      | components from this game                                        |
| `new`    | factory functions                                                |
| `hud`    | hud class                                                        |

and has the following functions:

| function        | desc                                  |
| --------------- | ------------------------------------- |
| `:init()`       | initialise                            |
| `:deinit()`     | deinitialise                          |
| `:update(dt)`   | update game world. `dt` is delta time |
| `:draw()`       | draw game world                       |
| `.initPlayer()` | initialises player                    |
| `.initBullet()` | initialises bullet                    |
| `.initEnemy()`  | initialises enemy                     |
## Hud
`initHud([ammo, health])`
- starting values which default to max

`:draw()`
- draws the hud

properties:
- `ammo`
- `health`
# entities
## Bullet
standard bullet entity

`g.new.Bullet(x, y, r, angle, speed, [c, ic, team, parry])`
- `c, ic`: colour and inner colour when drawn
- `team`: team of bullet
- `parry`: boolean. Whether to be parry able or not
### System: `g.c.BulletDeleteSystem()`
deletes bullets when they go offscreen
### System: `g.c.BulletGraphicsSystem()`
draws bullets
### helper functions
there are several functions to help easily spawn in bullets. They all have parameters:
`(x, y, r, angle, speed)`

| function (`g:`) | desc                                                    |
| --------------- | ------------------------------------------------------- |
| `shoot`         | shoots a bullet with a random chance of being parryable |
| `shootNormal`   | shoots a non-parryable bullet                           |
| `shootParry`    | shoots a parryable bullet                               |
### `g.c.blockBullets()`
blocks all bullets for a period of time
## Player
player character

`g.new.Player(x, y, onHealthChange, onAmmoChange)`
- `onHealthChange`: calls when health value changes
- `onAmmoChange`: calls when ammo value changes
- these two functions are primarily used to update the hud info
### System: `g.c.PlayerSystem(dt)`
player system. Expects the player to have all the components added in the `new` function
## Option
In place of menus, the game uses pieces of text which can be shot. when shot, the specified function is run

`g.new.Opt(x, y, text, onHit)`
- `x, y`: the x and y position of the option
- `text`: the text to display
- `onHit`: the function to run when hit
### System: `g.c.OptGraphicSys()`
draws the options to the screen
# spawn management
## create a spawn manager
1. initialise the spawn system: `g.initSpawnSystem`, which returns a table
2. use this table to initialise the different types of spawners: `g.initSpawner(table)`
3. then use the table from step 1 to create a new spawn manager: `table.ss.new.SpawnManager()`
4. add spawn conditions using: `spawn manager:add(condition/s)`

currently, the spawn system table is stored in `g.ss` and the spawn manager in `g.sm`
## spawn conditions
various types of spawn conditions can be added to the manager for different effects. These spawn conditions are currently found in `g.ss.new`
### timer
goes to next condition when the timer runs out

`g.ss.new.Timer(time)`
- `time`: time till timeout
### Spawn
spawns the specified character at the specified x and goes to next condition

`g.ss.new.Spawn(i, x)`
- `i`: the index of the enemy to spawn. Use the `ene` enum for readability
- `x`: the x tile to spawn them on
### Skip
increments the current condition

`g.ss.new.Skip(i)`
- `i`: how much to increment by
### Death Condition
spawns a character and skips backwards until it is defeated

`g.ss.new.DeaCon(i, x, r)`
- `i`: the index of the enemy to spawn. Use the `ene` enum for readability
- `x`: the x tile to spawn them on
- `r`: how much to increment back if the character has not spawned yet 
### creating a custom spawn condition
custom spawn conditions can be created for custom properties. All currently existing spawn conditions use this same method:

`g.ss.new.SpawnCond([cond, success, fail])`
- `cond`: the condition function. Should return `true` if the condition succeeds
	- `nil`: the condition is assumed true
- `success`: a function to be performed on success
	- `nil`: increments the current spawn condition by 1
- `fail`: a function to be performed on success
	- `nil`: is ignored on false
- **parameters**: `self`, `sm`