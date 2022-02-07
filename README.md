*Please note that the following is all WIP and not currently up to date.*

# Introduction

## Project Goals
 - To further develop proficiency in Powershell scripting
 - To further develop proficiency in Experience Economy design and development
 - To create an on-topic, fun, and collaborative experience for IT Service men and women
  
## Game Goals
 - To maintain a healthy, cooperative Company Status level
 - To beat the pants off teammates by individually contributing to a healthy Company Status level
  
## Design Tools
 - Powershell
 - Microsoft Visual Studio Code
 - Github Desktop
 - Notepad++

## Theme and Aesthetics
 - 90s BBS door games
 - Computer kitsch
 - Modern board games

# Game Mechanics

## Company Status

### Client Health
Starts at 25
#### Increased by:
 - Completing project stages prior to their deadlines(?)
 - Specials
#### Decreased by:
 - Service Tickets that become technical questions
 - Specials
#### At the following thresholds, low Client Health detriments all players:
 - 20: Players use one fewer die per service ticket encounter
 - 15: Answering technical questions requires a sacrifice of GIFs
 - 10: Players use two fewer dice per service ticket encounter
 - 5: Answering technical questions now takes three turns instead of two
 - 0: Players use three fewer dice per service ticket encounter

### Team Health
#### Collective health of all players
Starts at 25
#### Increased by:
 - Specials
#### Decreased by:
 - Addressing service tickets; additional decrease if fail to close
 - Addressing project stages
 - Specials
#### At the following thresholds, low Team Health detriments all players:
 - 20: Daily dice now randomly assigned
 - 15: Training requires a sacrifice of GIFs
 - 10: Increased risk of Project counterattacks (set default amount in config)
 - 5: Reduction in chance of finding specials in service tickets
 - 0: Permanent dice now randomly assigned in training

### Kudos (a players "Victory Points")
#### An individual’s contributions to the overall Company Status.
#### Attained by:
 - Closing Service Tickets
 - Closing Projects Stages
 - Completing Project Stages prior to their deadlines
 - Closing Technical Questions

### Project Deadline/Seasons
The project's final stage's deadline marks the end of the game's season. At the end of each season, Company Status and Individual Kudos will be locked and closed for the current season, and a new season will begin. Currently new seasons start stats over, but I plan to have the game save past season data for posterity.

### Conditions of Victory
Victory is dynamic and measured both as a team and as individual players. At the end of each project deadline, current stats will lock and close, and players can see the final state of the collective Company Status. 

That said, individual players gain Kudos based on what contributions he has made to the Company Status. Highest Kudos count wins.

### Player Resources
#### Days
Players are allowed to sign on once per 24 hours. Signing on assigns the player all of his or her daily alottments and also converts any Service Tickets that are past their threshold into Technical Questions.
#### Turns
Each player is given a configurable number of turns per day. Most actions requrie turns.
#### Dice
A player’s toolkit consists of solution dice. When the player signs on, he or she is offered a configurable number of solution dice. He or she chooses a confugyrable number of dice for use during that day. Daily dice reset each day. But Training can be used to increase the player's permanent store of dice.

Each die has a particular type relating to AdventureNet’s toolstack, which in turn relate to the more generic categories of IT work types. See the Encounters section for more information. 

Dice each have six sides, each of which will have one work type. The type of a die determines the proportion and kind of work types it can roll.

Dice types include:
 - Microsoft 365
 - Datto
 - Mimecast/Umbrella
 - Windows
 - Huntress/Defender/Webroot
 - Core Values
 - ITGlue

 Work Types include:
 - Workstation
 - Cloud
 - On-prem server
 - Networking
 - Security
 - Customer service

#### Specials
Players will be able to spend turns(?) on specials. Think of them as a hand of cards that you can find when going through service tickets. Finding the specials doesn’t use a turn, but most (?) specials require a turn to use.
#### Training
Players can use a certain number of turns per day to train. Training allows players to keep a die from his or her daily allotment for use every day thereafter.
#### Opportunities
Once per day, players will be able to send off appropriate service tickets to the procurement department. 
#### GIFs
The currency of the IT professional, GIFs allow players to purchase powerful specials.

### Basic Actions
#### Sign on
Upon signing on for the day, 
 - Daily Dice alottment.
 - Service Ticket alottment. Service Tickets older than a configurable threshold will convert to Technical Questions.
 - Turns alottment. Unused turns from the previous day will be lost.
 - Opportunities alottment.
 - Reset Project Stage attempts.
#### Close Service Ticket
To keep Service Tickets from becoming Technical Quesstions, players need to close them. Closing the lowers Team Health (because it requires exertion from the player, who is a part of the team).

Some encounters qualify to be sent off as Opportunities, decreasing the Service Ticket count and Turns but not decreasing Team Health. 

Players might also find certain Specials instead of Service Tickets. Some specials go into the player’s hand, so to speak, for use later, and some are applied immediately. Finding a special does not use a turn, unless stated otherwise.

Each encounter, the ticket you’re addressing will have 1 to 3 waves of defense. Each defense, you’ll choose which of your total dice to use. Used dice cannot be used for subsequent waves of any single encounter but will reset for subsequent encounters. If a Service Ticket successfully defends against you, it automatically becomes a technical question. If you succeed against all defenses, the encounter is cleared from your service tickets.

You'll also gain GIFs as a resut of closing Service Tickets.
#### Close Project Stage
Projects are shared, so that there are only three stages of the project for all players to share. Closing Project Stages is much the same as closing Service Tickets, but projects are much harder.

Closing all Project Stages ends the season. Players will be able to finish any remaining turns and gain as many Kudos as they can, but they will not be allowed to sign on again until the season is reset.

There are separate deadlines per stage, with the final stage being the end of the season.

Each stage has multiple waves. Each player can only attack one wave per stage. Once all waves have been dealt with, the stage ends, and all players are able to again participate in the next stage.

There’s a random number of waves that’s <= the total number of players, so that some players might miss out. For that kudo bonus, they’ll just have to get one the next round or make it up other ways.

Concerning the danger of players doing duplicate waves—the # of waves < # of players, and the game will accept additional ones, the exception that causes it being that players can run them at the same time—kind of just a way that a player can sneak a wave in if there’s not enough to go around. 
Gameplay
#### Training
A configurable number of times per day, Training allows a player to a die of his or her choice to his permanent collection.
#### Close Technical Questions
Failed and outdated Service Tickets become Technical Questions, which other players can answer for kudos and for gaining some Client Health back (which was lost when the Service Ticket became a technical question). 

To note, though answering another player's technical question would normally benefit team health, the exertion on the answering player balances that gain, so that there's a net 0 health gain for the team.

Answering Technical Questions requires two turns instead of one.
#### Special
Specials of a particular type are only able to be used when at rest, so to speak. Other specials can only be used during a Service Ticket or Project Stage, and others go into effect when you attain them.
#### Teams
In Teams, you'll be able to use your GIFs to purchase powerful specials.

# Appendix: Data

## Organization and Distribution
### SharePoint/OneDrive app
This game was designed with cloud storage in mind as the centralized repository. Theoretically, it should work from a network location as well. But a player's identity in the functions comes from his or her Windows username, so it would be difficult for multiple players to use the same machine to play on a non-network storage location.

All player-changed data is stored in data files specific to each player. This helps to avoid problems with locking files and overwriting data accidentally without requiring some kind of database software. Functions gather these data files and calculate common data from them on the fly.

A centralized config file creates some of the main variables and determines several shared values.

Though there will be a small lag as players complete functions and sync their changes to and from cloud storage, it shouldn't affect gameplay on the scale that the game is intended to be played. Remember, this is supposed to be like a board game.

## Obfuscation and Data Integrity
It will be possible to obfuscate player data and other important data, in order to discourage cheating. But note that even then, this game is intended to be played between friends or co-workers, and the honor system is assumed.