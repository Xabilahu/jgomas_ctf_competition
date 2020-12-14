debug(3).

manager("Manager").

team("ALLIED").

type("CLASS_SOLDIER").

{ include("jgomas.asl") }

+!get_agent_to_aim
<-  ?debug(Mode); if (Mode<=2) { .println("Looking for agents to aim."); }
?fovObjects(FOVObjects);
.length(FOVObjects, Length);

?axis_bottom(UWU);
.println(UWU);

?debug(Mode); if (Mode<=1) { .println("El numero de objetos es:", Length); }

if(not ready){
    ?g_step(S);
    if(S==1){
        ?going_position(GX,GY,GZ);
        !distance(pos(GX, 0, GZ));
        ?distance(D);

        if(D < 1){
            -going_position(_,_,_);
            +waiting_position(40,GY,GZ);
            -g_step(_);
            +g_step(2);
        }

        +order(move,GX,GZ);
    }
    if(S==2){
        ?waiting_position(WX,WY,WZ);
        +order(move,WX,WZ);
    }
}

if(objectivePackTaken(on)){
    +order(help);
    -+my_health_threshold(0);
    -+my_ammo_threshold(0);

    if(not decided){
        .println("Deciding back");
        +decided;
        ?axis_bottom(AA);
        .println(AA);
        if(AA > 7 - AA){
            +back_decided_up;
            ?my_position(XX,YY,ZZ);
            -+g_step(1);
            -+going_position(XX,YY,ZZ-100);
            .my_team("ALLIED", E1);
            .concat("back_decided_up", Content1);
            .send_msg_with_conversation_id(E1, tell, Content1, "INT");
            .concat("decided", Content2);
            .send_msg_with_conversation_id(E1, tell, Content2, "INT");   
        }
    }else{
        if(back_decided_up){
            ?g_step(GS);
            if(GS == 1){
                ?going_position(GX,GY,GZ);
                !distance(pos(GX, 0, GZ));
                ?distance(D);

                if(D < 1){
                    -g_step(_);
                    +g_step(2);
                    ?my_position(XX,YY,ZZ);
                    -+going_position(XX-150,YY,ZZ);
                }else{
                    +order(move,GX,GZ);
                }

            }
            if(GS == 2){
                .println("---------------------------");
                ?going_position(GX,GY,GZ);
                !distance(pos(GX, 0, GZ));
                ?distance(D);

                if(D < 1){
                    -g_step(2);
                    +g_step(0);
                }else{
                    +order(move,GX,GZ);
                }
            }
        }
    }
    
}

if (Length > 0) {
    +bucle(0);
    
    -+aimed("false");
    
    while (not no_shoot("true") & bucle(X) & (X < Length)) {
        
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
                
            }  else {
                if (Team == 100) {
                    .nth(3, Object, Angle);
                    if (math.abs(Angle) < 0.1) {
                        +no_shoot("true");
                        .println("ALLIES in front, not aiming!");
                    } 
                }
            }
            
        }
        
        -+bucle(X+1);
        
    }

    if (no_shoot("true")) {
        -aimed_agent(_);
        -+aimed("false");
        -no_shoot("true");
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

 +!perform_look_action 
    <- 
        ?objective(OX,OY,OZ);
        !distance(pos(OX,OY,OZ));
        ?distance(D);

        if( D > 60){
            ?fovObjects(FOVObjects);
            .length(FOVObjects, Length);
            +ploop(0);

            while (ploop(X) & (X < Length)) {
                .nth(X, FOVObjects, Object);
                // Object structure
                // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
                .nth(1, Object, Team);

                if(Team == 200){
                    .nth(0,Object,Id);
                    !check_axis_bottom(Id);
                }


                -+ploop(X+1);
            }
            -ploop(_);
        }

.


+!check_axis_bottom(Id)
    <- 
        ?already_seen(AS);
        .length(AS, LengthAS);
        +found("false");

        if(LengthAS > 0){
            +cloop(0);
            while(cloop(C) & C < LengthAS & found("false")){
                .nth(C,AS,Current);
                if(Current == Id){
                    -found("false");
                    +found("true");
                }
                -+cloop(C+1);
            }
            if(found("false")){
                .concat(AS,[Id],NewT);
                -already_seen(_);
                +already_seen(NewT);
                -axis_bottom(A);
                +axis_bottom(A+1);
            }
            -found(_);
            -cloop(_);
        }else{
            .concat(AS,[Id], NewT);
            -already_seen(_);
            +already_seen(NewT);
            -+axis_bottom(1);
        }
.

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

+!init
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR init GOES HERE.")};
      ?my_position(X,Y,Z);
      +already_seen([]);
      +axis_bottom(0);
      +going_position(X,0,213);
      +g_step(1).  