debug(3).

manager("Manager").

team("ALLIED").

type("CLASS_SOLDIER").

{ include("jgomas.asl") }

+!get_agent_to_aim
<-  ?debug(Mode); if (Mode<=2) { .println("Looking for agents to aim."); }
?fovObjects(FOVObjects);
.length(FOVObjects, Length);

?debug(Mode); if (Mode<=1) { .println("El numero de objetos es:", Length); }

//X+175,Y,Z-88-R*2
?g_step(S);
if(not attack & S==1){
    ?going_position(GX,GY,GZ);
    !distance(pos(GX, 0, GZ));
    ?distance(D);

    if(D < 1){
        -going_position(_,_,_);
        +waiting_position(GX+175,GY,GZ);
        -g_step(_);
        +g_step(2);
    }

    +order(move,GX,GZ);
}

if(not attack & S==2){
    ?waiting_position(WX,WY,WZ);
    !distance(pos(WX, 0, WZ));
    ?distance(D);
    if(D < 20 & not sent){
        .my_team("ALLIED",E1);
        .concat("ready", Content);
        .send_msg_with_conversation_id(E1,tell,Content,"INT");
        +sent;
    } 
    
    +order(move,WX,WZ);
}



if (Length > 0) {
    +bucle(0);
    
    -+aimed("false");
    
    while (aimed("false") & bucle(X) & (X < Length)) {
        
        //.println("En el bucle, y X vale:", X);
        
        .nth(X, FOVObjects, Object);
        // Object structure
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        .nth(2, Object, Type);
        
        ?debug(Mode); if (Mode<=2) { .println("Objeto Analizado: ", Object); }
        
        if (Type > 1000) {
            ?debug(Mode); if (Mode<=2) { .println("I found some object."); }
        } else {
            // Object may be an enemy
            .nth(1, Object, Team);
            ?my_formattedTeam(MyTeam);
            
            if (Team == 200) {  // Only if I'm ALLIED
				
                ?debug(Mode); if (Mode<=2) { .println("Aiming an enemy. . .", MyTeam, " ", .number(MyTeam) , " ", Team, " ", .number(Team)); }
                +aimed_agent(Object);
                -+aimed("true");
                
            }
            
        }
        
        -+bucle(X+1);
        
    }
    
    
}

-bucle(_).


+look_response(FOVObjects)[source(M)]
    <-  //-waiting_look_response;
        .length(FOVObjects, Length);
        if (Length > 0) {
            ?debug(Mode); if (Mode<=1) { .println("HAY ", Length, " OBJETOS A MI ALREDEDOR:\n", FOVObjects); }
        };    
        -look_response(_)[source(M)];
        -+fovObjects(FOVObjects);
        //.//;
        !look.

+!perform_aim_action
    <-  // Aimed agents have the following format:
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        ?aimed_agent(AimedAgent);
        ?debug(Mode); if (Mode<=1) { .println("AimedAgent ", AimedAgent); }
        .nth(1, AimedAgent, AimedAgentTeam);
        ?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam);             }
        ?my_formattedTeam(MyTeam);


        if (AimedAgentTeam == 200) {
    
                .nth(6, AimedAgent, NewDestination);
                ?debug(Mode); if (Mode<=1) { .println("NUEVO DESTINO DEBERIA SER: ", NewDestination); }
          
            }
 .

 +!perform_look_action .

 +!perform_no_ammo_action .

 +!perform_injury_action .

 +!setup_priorities
    <-  +task_priority("TASK_NONE",0);
        +task_priority("TASK_GIVE_MEDICPAKS", 2000);
        +task_priority("TASK_GIVE_AMMOPAKS", 0);
        +task_priority("TASK_GIVE_BACKUP", 0);
        +task_priority("TASK_GET_OBJECTIVE",1000);
        +task_priority("TASK_ATTACK", 1000);
        +task_priority("TASK_RUN_AWAY", 1500);
        +task_priority("TASK_GOTO_POSITION", 750);
        +task_priority("TASK_PATROLLING", 500);
        +task_priority("TASK_WALKING_PATH", 1750). 

+!update_targets
	<-	?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR UPDATE_TARGETS GOES HERE.") }.

+!performThresholdAction
       <-
       
       ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_TRESHOLD_ACTION GOES HERE.") }
       
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);
       
       if (Ar <= At) { 
          ?my_position(X, Y, Z);
          
         .my_team("fieldops_ALLIED", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",X, ", ", Y, ", ", Z, ", ", Ar, ")", Content1);
         .send_msg_with_conversation_id(E1, tell, Content1, "CFA");
       
       
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= Ht) { 
          ?my_position(X, Y, Z);
          
         .my_team("medic_ALLIED", E2);
         //.println("Mi equipo medico: ", E2 );
         .concat("cfm(",X, ", ", Y, ", ", Z, ", ", Hr, ")", Content2);
         .send_msg_with_conversation_id(E2, tell, Content2, "CFM");

       }
       .

 
+cfm_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_agree GOES HERE.")};
      -cfm_agree.  

+cfa_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_agree GOES HERE.")};
      -cfa_agree.  

+cfm_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_refuse GOES HERE.")};
      -cfm_refuse.  

+cfa_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_refuse GOES HERE.")};
      -cfa_refuse.  

/*+!init
   <-
    +initial_task(task(1000,"TASK_GET_OBJECTIVE","Manager",pos(224,0,224),""));
    -tasks(_);
    +tasks([]);
    .random(R);
    .my_name(MyName);
    ?my_position(X,Y,Z);
    +destination(X+175,Y,Z-88-R*2);
    !add_task(task("TASK_GOTO_POSITION",MyName,pos(X+175,Y,Z-88-R*2),""));
	!add_task(task("TASK_ATTACK",MyName,pos(X,Y,Z-88-R*2),"")).*/

+!init
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR init GOES HERE.")};
    ?my_position(X,Y,Z);
    .random(R);
    +going_position(X,Y,Z-88-R*2);
    +g_step(1) .