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
 - ASCII art
 - Computer kitsch
 - Monster hunters

# Game Mechanics

## Company Status

### Client Health
Starts at 25
#### Increased by:
 - Completing project stages; bonuses for early completion and completing all stages?
 - Completing service tickets; bonus for having no Technical Questions (per day?)?
 - Specials
#### Decreased by:
 - Service Tickets
 - Every service ticket that becomes a technical question
 - Missed project deadlines?
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
 - ? 
 - Technical questions being answered? Seems like this would be a net 0, since answering the question reduces the answerer's health.
#### Decreased by:
 - Addressing service tickets
 - Failing service tickets (additional to the above)
 - Addressing project stages
 - Internal conflict special
#### At the following thresholds, low Team Health detriments all players:
 - 20: Daily dice now randomly assigned -done X
 - 15: Training requires a sacrifice of GIFs done
 - 10: Increased risk of Project counterattacks (set default amount in config)-done X
 - 5: Reduction in chance of finding specials in service tickets done
 - 0: Permanent dice now randomly assigned in training done

### Kudos (a players "Victory Points")
#### An individual’s contributions to the overall Company Status.
#### Attained by:
 - Completing service tickets
 - Completing projects stages
 - Completing project stages early (Bonus)
 - Completing all project stages (Bonus)
 - Answering technical questions
 - Attaining/giving certain specials 

### Project Deadline/Seasons
#### Project deadlines mark the end of each game season. At the end of each season, Company Status and Individual Kudos will be locked and closed for the current season, and a new season will begin. 
#### Reset stats? Increase difficulty of encounters and projects?

### Conditions of Victory
#### Victory is dynamic and measured both as a team and as individual players. At the end of each project deadline, current stats will lock and close, and players can see the final state of the collective Company Status. 
#### That said, individual players gain Victory Points: Individual Kudos based on what contributions he has made to the Company Status. Highest VP count wins.

### Player Resources
#### Days
Players are allowed to sign on once per day. Signing on assigns the user an allotment of service tickets and of dice. Signing off converts any remaining service tickets into technical questions. Players cannot sign off without first signing on. Players are given ___# days prior to the project deadline. 
#### Turns
Each player is given ___# turns per day. Addressing service tickets and technical questions reduce the number of available turns, and turns reset the next day/time the player signs on. 
#### Dice
A player’s toolkit consists of solution dice. When the player signs on, he or she is offered ____# solution dice. He or she chooses ____# dice for use during that day. In addition, if a player has previously made use of the training function, any die that has been added previously will be added to the player’s daily allotment. 

Each die will have a particular type relating to AdventureNet’s toolstack, which in turn relate to the more generic categories of IT work types. See the Encounters section for more information. Dice each have six sides, each of which will have one work type, in proportion according to the dice type.

Dice types include:
 - Microsoft 365
 - Datto
 - Mimecast/Umbrella
 - Windows
 - Huntress/Defender/Webroot
 - Core Values
 - ITGlue

#### Specials
Players will be able to spend turns(?) on specials. Think of them as a hand of cards that you can find when going through service tickets. Finding the specials doesn’t use a turn, but most (?) specials require a turn to use.
#### Training
Players can use a certain number of turns per day to train. Training allows players to keep a die from his or her daily allotment for use every day thereafter.
#### Opportunities
Once per day, players will be able to send off appropriate service tickets to the procurement department. 

### Basic Actions
#### Sign-On Specific Actions:
Upon signing on for the day, 
 - The system will offer ____# dice. The player may choose ___# of those dice for use during that day. Any die previously attained by training will be added to the players alottment automatically.
 - Players will also be assigned between ___# and ___# service tickets.
 - Players will also be given 20 turns. Unused turns from previous days will not be added to this allotment.
#### Encounter: Service Ticket
Completing tickets benefits the overall health of the company, but it also lowers the health of each player. 

Some encounters will provide alternate actions, such as Opportunities. Players must be on the lookout. 

Players might also find certain specials. Some specials go into the player’s hand, so to speak, for use later. Finding a special does not use a turn, unless stated otherwise.

Each encounter, the ticket you’re addressing will have 1 to 5(?) defenses. Each defense, you’ll be given the option for which of your dice to use. Used dice cannot be used for subsequent defenses of any single encounter but will reset for subsequent encounters. If any defense succeeds, the encounter gets away and automatically becomes a technical question. If you succeed against all defenses, the encounter is cleared from your service tickets for the day.
#### Encounter: Project
Each player must complete his or her project by the deadline. Completed projects will provide that client health boost that you will need to finish up the season well.

Each season, a large project is assigned to all players. Each player is assigned his or her stages. 

Projects are made up of several stages—each of different work types. Dice that are used on previous stages may not be used again on subsequent stages. 
#### Train
Once per day, players may use ___# turns to train. Training allows the player to choose one of the die from his or her daily allotment to add to his or her permanent collection, which he or she can then use every day thereafter.
#### Answer Technical Questions
Service tickets over two days old will be interpreted as Technical Questions.
Service tickets that have been assigned but not completed are simultaneously interpreted as Technical Questions by other players, given the elasticity of resource management on the service board. But to account for players’ ticket counts and available capacity to complete them, other players will also be able to see how many turns players still have for the day. This will help to identify persistent issues, rather than those which come from daily workloads.
#### Answering Technical Questions requires turns in the same way that service tickets do, and the encounter process is the same between the two. 
Answering another player’s Tech Questions yields a net 0 change to Team Health, since while it alleviates the player that had the issue as a service ticket—both removing the service ticket that would lower his health and providing some feeling of teamwork, it becomes a strain on the player that addresses it as a Technical Question.
Answering Tech Questions increases Team Health. However, it takes a player two turns instead of 1. 
However, if left unaddressed, Technical Questions count against Client Health:
#### Use Special

### Encounters
#### Work Types/Problem Categories
 - Workstation
 - Cloud
 - On-prem server
 - Networking
 - Security
 - Customer service
#### Service Tickets
#### Technical Questions
#### Projects
3 stages per project deadline.
Separate deadlines per stage, with the final stage being the end of the season. Beating the deadline benefits company health, so there needs to be opportunity.
Each stage has multiple waves. Each player can only attack one wave per stage. Once all waves have been dealt with, the stage ends, and all players are able to again participate in the next stage.
There’s a random number of waves that’s =< the total number of players, so that some players might miss out. For that kudo bonus, they’ll just have to get one the next round or make it up other ways.
Concerning the danger of players doing duplicate waves—the # of waves < # of players, and the game will accept additional ones, the exception that causes it being that players can run them at the same time—kind of just a way that a player can sneak a wave in if there’s not enough to go around. 
Gameplay

# Appendix: Data

## Organization and Distribution
### SharePoint/OneDrive app
Per-player data stores that gameplay functions intelligently gather as-needed for displaying and calculating collective statistics.
Could I create a config file that set’s a bunch of variables in the player’s PS session and then just check those when running functions? Would that save any computer vs. having to check the config file for every function call? I need a separate function for making sure those are set for each other function to use. 
For shared projects, I can have a “this has already been completed” function that reverts any changes you make during your project stage attempt, just in case someone else does it at the same time and just beats you to it. It could be as simple as creating some file to indicate that it’s been done, and then the project stage encounter function just checks for that before committing changes.

## Obfuscation and Data Integrity