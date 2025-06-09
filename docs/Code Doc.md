details functions used to create the game.
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