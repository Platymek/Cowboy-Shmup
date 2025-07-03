details functions used to create the game.
# guides
## teams
where functions ask for team values, this is what each one corresponds to so far:

| team  | desc                                              |
| ----- | ------------------------------------------------- |
| `nil` | no team. Hurts and is hurt by others with no team |
| 0     | player                                            |
| 1     | enemy                                             |

## adding an enemy
create the enemy script:
```lua
--[[ in new script for enemy ]]

function g.initPlayer()

	-- create a component
	g.c.EnemyName = g.w.component()

	-- enemy constructer. X is default but make it whatever you want
	function g.new.EnemyName(x)

		local e = g.w.entity()
		local ene = g.c.EnemyName({--[[whatever]]})
		local pos = g.bc.new.Position(x, -8) -- minus height
		local vel = g.bc.new.Velocity(0, 0)
		
		local hea = g.c.new.Health(c.h,
		-- auto kills on death. To be replaced. Replace with whatever u want
        function (val) if val == 0 then e += g.bc.new.Delete() end end)
		
		ene:update = function(dt)
			
			-- update function
		end
		
		-- add other functions to the ene component if needed
		
		-- adding components at the end means comps can be used in functions
		e += ene
		e += pos
		return e
	end
	
	g.c.SumoSystem = g.w.system({g.c.Sumo},
	-- function which runs update loop
	function(e, dt) e[g.c.Sumo]:update(dt) end)
	
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
## `Hitbox` and `Hurtbox`
inherits `Circle` class from `pico-badger` for collisions

`new.Hitbox(team, r, [x, y, dam, onHurt])`
`new.Hurtbox(team, r, [x, y, onHurt])`
- `x, y`: offset of box. Default: 0, 0
- `dam`: damage of hitbox. Default: 1
- `team`: cannot damage same team unless `nil`
- `onHurt`: called when hit or hurt. Default: `nil`
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
## Player
player character

`g.new.Player(x, y, onHealthChange, onAmmoChange)`
- `onHealthChange`: calls when health value changes
- `onAmmoChange`: calls when ammo value changes
- these two functions are primarily used to update the hud info
### System: `g.c.PlayerSystem(dt)`
player system. Expects the player to have all the components added in the `new` function
## Enemy
basic enemy character

`g.new.enemy(x)`
- `x`: spawns enemy at x
- no `y` because enemy always spawns at top of screen
### System: `g.c.EnemySystem(dt)`
enemy system. Expects enemy to have all components added in `new` function