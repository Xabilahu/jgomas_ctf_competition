#########################################################
################ Final Work: JGOMAS #####################
#########################################################

AUTHORS:
    - Daniel Cañadillas
    - Erlantz Calvo
    - Unai Carbajo
    - Xabier Lahuerta
    - Erik Angulo
    - Oihane Roca

Spent time: around 17 hours each

Github Link: https://www.github.com/kaecius/jgomas_ctf_competition

################ PRE-IMPLEMENTATION #####################

The first thing that was implemented before the subteams were created was to make the the 
soliders don't shoot each other if another of the same team is in the direction of the bullet.

#########################################################
###################### ALLLIED ##########################
#########################################################

TASK 1 and TASK 3
    - Implement a winning ALLIED team for the default AXIS team
    - Implement a winning ALLIED team for any AXIS team

#################### STRATEGY ###########################
We divided the team in 2 subteams,  one formed by 4 agents and the other one is formed
by 3 agents. Once the match starts, the subteam of 4 soldiers move towards the upper entrance
of the main structure; in order to move to that exact location, the subteam need to move upwards,
and when this subteam is align with the entrade of the structure, it has to move straight to
that position. At the same time, the other subteam, the one formed by 3 soldiers, hide behind
the small building near the spawn until they recieve an order from the upper subteam.

Once the upper subteams arrive to the desired location, they send a message to the bottom
team, giving the order to move to the objetive.

If the timing is correct, the top team would go down to the flag, working as a bait, leaving the
lower part clean for the lower team to rush for the flag.

Once the flag is taken, the rest of the team would go to the flag carrier's position, covering him from enemy fire (from the
back) until he reaches the base.


################# IMPLEMENTATION ########################

Created agents: "jasonAgent_ALLIED_MEDIC_M1.asl"
                "jasonAgent_ALLIED_upside_soldier.asl"


#########################################################
######################## AXIS ###########################
#########################################################

TASK 2 and TASK 4
    - Implement a winning AXIS team for the default ALLIED team
    - Implement a winning AXIS team for any ALLIED team


#################### STRATEGY ###########################
We divided the team in 2 subteams,  one formed by 4 agents, 2 medics and 2 fieldops, and the other one is formed
by 3 soldier agents. Once the match starts, the subteam of 4 soldiers move to the base. At the same time, the
other subteam, the one formed by 3 soldiers, go to the ALLIED base. When both of the subteams get to the
desired location, they will start patrolling.

Each type of troop communicate between them and when they see an enemy they will tell their parterns to go
with him in order to try to kill them. 

When a partner calls for medic packs or calls for ammo, the both agents (medics when call for medic packs
and fieldops when the call is for ammo) will go to the one that has call in order to give it help.


################# IMPLEMENTATION ########################

Created agents: "jasonAgent_AXIS.asl"
                "jasonAgent_AXIS_FIELDOPS.asl"
                "jasonAgent_AXIS_MEDIC.asl"


Bibliography

Sun Tzu - The Art of War
