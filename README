# there is something inside me that has no name

this is a high-level explanation of story, setting and gameplay. for info about
the code, see [how it works](docs/how-it-works)

## overview

there is something inside me that has no name is a text adventure. there is
something inside me that has no name is a 2d platformer. there is something
inside me that has no name is a slice-of-life rpg. there is something inside me
that has no name is an abstract mystery.

the player must manage life on a collective land project at the outskirts of a
north american city after the collapse of u.s. empire. the core gameplay loop
involves interacting with a text-based command prompt to manage fraught queer
relationships, repair broken infrastructure on the commune, and react to
intrusions from reactionary threats that roam the country.

all the while, the player's internal emotional state and biological needs are
hidden from them -- outside of the main interaction area a 2d-platformer plays
itself, procedurally-generating different obstacles and behaviors according to
ill-defined player attributes: *red*, *orange*, *yellow*, *green*, *blue*,
*purple*.

if the player wishes to consciously influence their character's actions, they
must watch this platformer. they must learn to interpret the effects of their
choices on their internal state through the changing landscape of this endless
runner. the platformer character, *little jumper* may develop new combat verbs,
indicating an escalating *red* value. if left unchecked, this high *red* coul
force the player into dialogue trees guaranteed to hurt their friends and create
conflict on the commune. the player could risk expulsion from the project.

only at night is the player allowed the opportunity to play through the day's
platformer section in reverse. this has no effect on player or world state, but
can be helpful for integrating the day's experiences.

this is a game about healing, alone and in community and with imperfect
knowledge. this is a game about surviving and of living with the consequences of
survival.

## story

### setting

play occurs within an ambiguous future present, a post-collapse polytopia.

the land project was acquired before you got there, before the state fled to
reinforce the coapital, before the surrounding suburbs were half-burned and
abandoned, before the militias started patroling the city's hinterlands.

the land itself was never meant to sustain all nine of you. the big house and
its garden shed and d.i.y. out-structures was never meant to house the nine of
you. the city was never meant to feel so far, by unmaintained roads, by back-
country bike trails, by improvised railcars.

the city where people still trade and share knowledge and find joy in human
company, intimate or anonymous. even as the various factions of post-american
life callous into nations, the city offers the variety and polysemy and 
contradiction that cities always have.

### player character

but you never go to the city. you learned over time that the noise and the fear
made you a liability on those trips.

you have other ways of contributing: tending the land and the buildings

you will be given the opportunity to define aspects of the player character. an
early game command prompt asks "who are you?" and you can choose to continue
being "alex" or go by a different name.

you will not be given the opportunity to define the meaning of the attributes
*red*, *orange*, *yellow*, *green*, *blue*, *purple* or their relationship to
your underlying state primitives (things like *fear*, *hunger*, *arousal*.)

### *little jumper*

*little jumper* is your internal state. *little jumper* offers you advice. if
you don't know what to do, you can ask *little jumper*.

### characters

an assortment of 8 (mostly) queer n.d. ragamuffins. 

the pace of life is measured in two very important standing rituals
- project meeting
  - where the planning happens
- family dinner
  - recovering from project meeting, family dinner occurs twice throughout the
  week

<!-- TODO: put the characters here  -->

### story events

<!-- TODO: put story event ideas here -->

## gameplay

### core gameplay loop

the core gameplay loop consists of:
- changes in world state (inclusive of non-player characters state) are
communicated through text and (optionally) update to the *map display*, a
pictographic component of the ui
- the interaction prompt can now enter one of three modes:
  - **CHOICE** : the player is presented with a finite set of actions
  - **PROMPT** : the player is prompted for short text action
  - **DESCRIBE** : the player is prompted for a freeform text description of
  something in the world
- the player can alternately at this point use one of the always available
command options:
  - **HELP** \[*help*\] : ask for hints from *little jumper* 
  - **NOTE** \[*note* | *notebook* | *book*\] : access the notebook to read a prior note
  or make new notes
  - **USE** \[*use* | *item*\] : attempt to use an item in inventory
  - **META** \[*menu* | *meta* | *save* | *quit*\] : interact with the game menu
- the player's command is parsed for validity. if the game is unable to
determine player intent, they will be prompted again
- a successfully validated command alters the state of the game world (inclusive
of player character and non-player characters)
- any updates to *little jumper* game world are made
- return to top of loop
- world state includes in-world time, which passes at each player action
- some events are triggered by the passage of world time

*little jumper* minigame:
- initiated whenever player character makes a \[rest | sleep | nap \] command
- a wall is erected in front of *little jumper*
- control of *little jumper* is given to the player to traverse the platformer
world in reverse
- collectibles are given to the player for dispatching enemies and bypassing
platforming challenges
- the minigame ends when *little jumper* falls out of the environment, makes
contact with an enemy or hazard, or traverses the entirety of the world
constructed during the day
- collectibles may or may not persist between *little jumper* minigame sessions

### attributes
*player statistics*

in a standard game the underlying state primitives are seeded randomly and each
attributes value is computed from those primitives. each primitive can affect
more than one attribute. *sleep*, for example, has a strong positive effect on
*red* and *yellow*, but has a strong negative effect on *blue* and only a mild
negative effect on *purple*.

- *red* are the needs
  - for food
  - for rest
  - for purpose
  - for hydration
  - for warmth
  - for sex
  - for safety
- *orange* is the sensory world
  - of ambient noise
  - of touch
  - of ambient light
  - of bodily awareness
  - of bodily control
  - of cuteness
  - of temperature
- *yellow* is alertness
  - toward danger
  - toward sleep deprivation
  - toward the body
  - toward a calming presence
  - toward the body in space
  - toward the cold
  - toward touch
  - toward hunger
- *green* is the home
  - in purpose
  - in connection to humans
  - in intimacy
  - in cleanliness
  - in connection to the world
  - in safety
  - in certainty
- *blue* is the focus
  - on novelty
  - on challenge
  - on risk
  - on rest
  - on embodiment
  - on satiation
  - on purpose
- *purple* is desire
  - to have sex
  - to be sated
  - to connect
  - to be embodied
  - to be thrilled
  - to be integrated
  - to feel intimacy
  - to experience
  - to stay up all night

