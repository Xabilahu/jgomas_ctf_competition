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

Spent time: ----

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

Created agents: "jasonAgent_ALLIED_XXXXX.asl"
                "jasonAgent_ALLIED_XXXXX.asl"


#########################################################
######################## AXIS ###########################
#########################################################


Bibliography

Sun Tzu - The Art of War
