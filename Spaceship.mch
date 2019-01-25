/* Spaceship
* Author: Vihanga Bandara - 2015072
* Creation date: 12/15/2018
*/
MACHINE
    Spaceship
SEES
    Space
    
DEFINITIONS
    SET_PREF_MAXINT == 200;
    SET_PREF_MININT == 0;
    
SETS
    GAME_STATES = {Game_Won, Game_Lost, Game_Not_Over};
    ANSWERS = {DOCKED,NOT_DOCKED};
    STATUS = {SUCCESSFULLY_MOVED, SPACESHIP_COLLIDED, INVALID_MOVE_DOWN_OUT_OF_REGION, INVALID_MOVE_UP_OUT_OF_REGION, INVALID_MOVE_FORWARD_OUT_OF_REGION, INVALID_MOVE_BACKWARD_OUT_OF_REGION,INSUFFICIENT_POWER, WARP_DRIVE_SUCCESS,WARP_DRIVE_OUT_OF_REGION, WARP_DRIVE_INSUFFICIENT_POWER,WARP_DRIVE_FAILED_IMMINENT_ASTEROID_COLLISION}
    
VARIABLES
    spaceship_power,
    spaceship_position,
    asteroid_collision,
    space_route
    
INVARIANT
    space_route : seq1(GRID) &
    spaceship_position : GRID &
    spaceship_position /: ASTEROIDS &
    spaceship_power : NAT &
    asteroid_collision : NAT
    
INITIALISATION
    space_route, spaceship_power, spaceship_position,asteroid_collision := [starting_point], 170, starting_point, 0 
    
OPERATIONS
    
    /***************************************************************************
    SPACESHIP MOVEMENTS
    ***************************************************************************/  
    
    /****** Move Up - Normal Movement ******/
    message <-- MoveUp = 
    PRE (spaceship_position /= starbase_point) & (spaceship_position : GRID)
    THEN
        IF(spaceship_power <5)
        THEN  
            message  := INSUFFICIENT_POWER             
        ELSE IF ((prj1(NAT1,NAT1)(spaceship_position)|-> succ(prj2(NAT1,NAT1)(spaceship_position))) /: GRID)
            THEN message  := INVALID_MOVE_UP_OUT_OF_REGION
            ELSE IF((prj1(NAT1,NAT1)(spaceship_position)|-> succ(prj2(NAT1,NAT1)(spaceship_position))) : ASTEROIDS)
                THEN 
                    asteroid_collision := succ(asteroid_collision)  ||
                    message  := SPACESHIP_COLLIDED  ||
                    IF (spaceship_power>=15)
                    THEN
                        spaceship_power := spaceship_power - (asteroid_collision_reduction_power + normal_movement_reduction_power)
                    ELSE
                        spaceship_power := spaceship_power - normal_movement_reduction_power
                    END                         
                ELSE 
                    spaceship_position := (prj1(NAT1,NAT1)(spaceship_position)|-> succ(prj2(NAT1,NAT1)(spaceship_position))) ||
                    spaceship_power := spaceship_power - normal_movement_reduction_power ||
                    space_route := space_route <- (prj1(NAT1,NAT1)(spaceship_position)|-> succ(prj2(NAT1,NAT1)(spaceship_position))) ||
                    message  := SUCCESSFULLY_MOVED                  
                END
            END
        END
    END;   
    
    /****** Move Down - Normal Movement ******/
    message <-- MoveDown = 
    PRE (spaceship_position /= starbase_point) & (spaceship_position : GRID)
    THEN
        IF(spaceship_power <5)
        THEN  
            message  := INSUFFICIENT_POWER             
        ELSE IF ((prj1(NAT1,NAT1)(spaceship_position)|-> pred(prj2(NAT1,NAT1)(spaceship_position))) /: GRID)
            THEN message  := INVALID_MOVE_DOWN_OUT_OF_REGION           
            ELSE IF((prj1(NAT1,NAT1)(spaceship_position)|-> pred(prj2(NAT1,NAT1)(spaceship_position))) : ASTEROIDS)
                THEN 
                    asteroid_collision := succ(asteroid_collision) ||
                    message  := SPACESHIP_COLLIDED  ||
                    IF (spaceship_power>=15)
                    THEN
                        spaceship_power := spaceship_power - (asteroid_collision_reduction_power + normal_movement_reduction_power)
                    ELSE
                        spaceship_power := spaceship_power - normal_movement_reduction_power
                    END                   
                ELSE  
                    spaceship_position := (prj1(NAT1,NAT1)(spaceship_position)|->  pred(prj2(NAT1,NAT1)(spaceship_position)) ) ||
                    spaceship_power := spaceship_power - normal_movement_reduction_power ||
                    space_route := space_route <- (prj1(NAT1,NAT1)(spaceship_position)|-> pred(prj2(NAT1,NAT1)(spaceship_position)) ) ||
                    message  := SUCCESSFULLY_MOVED                  
                END
            END
        END
    END;   
    
    /****** Move Forward - Normal Movement ******/
    message <-- MoveForward = 
    PRE (spaceship_position /= starbase_point) & (spaceship_position : GRID)
    THEN
        IF(spaceship_power <5)
        THEN  
            message  := INSUFFICIENT_POWER             
        ELSE IF ((succ(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)) /: GRID)
            THEN message  := INVALID_MOVE_FORWARD_OUT_OF_REGION           
            ELSE IF((succ(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)) : ASTEROIDS)
                THEN 
                    asteroid_collision := succ(asteroid_collision)  ||
                    message  := SPACESHIP_COLLIDED  ||
                    IF (spaceship_power>=15)
                    THEN
                        spaceship_power := spaceship_power - (asteroid_collision_reduction_power + normal_movement_reduction_power)
                    ELSE
                        spaceship_power := spaceship_power - normal_movement_reduction_power
                    END                           
                ELSE  
                    spaceship_position := (succ(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)) ||
                    spaceship_power := spaceship_power - normal_movement_reduction_power ||
                    space_route := space_route <- (succ(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)) ||
                    message  := SUCCESSFULLY_MOVED                  
                END
            END
        END
    END;   
    
    /***** Move Backward - Normal Movement *****/
    message <-- MoveBackward = 
    PRE (spaceship_position /= starbase_point) & (spaceship_position : GRID)
    THEN
        IF(spaceship_power <5)
        THEN  
            message  := INSUFFICIENT_POWER             
        ELSE IF ((pred(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)) /: GRID)
            THEN message  := INVALID_MOVE_BACKWARD_OUT_OF_REGION
            ELSE IF((pred(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)): ASTEROIDS)
                THEN
                    asteroid_collision := succ(asteroid_collision) ||
                    message  := SPACESHIP_COLLIDED  ||
                    IF (spaceship_power>=15)
                    THEN
                        spaceship_power := spaceship_power - (asteroid_collision_reduction_power + normal_movement_reduction_power)
                    ELSE
                        spaceship_power := spaceship_power - normal_movement_reduction_power
                    END       
                ELSE
                    spaceship_position := (pred(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)) ||
                    spaceship_power := spaceship_power - normal_movement_reduction_power ||
                    space_route := space_route <- (pred(prj1(NAT1,NAT1)(spaceship_position)) |-> prj2(NAT1,NAT1)(spaceship_position)) ||
                    message  := SUCCESSFULLY_MOVED                  
                END
            END
        END
    END;   
    
    /****** Warp Drive Spaceship Movement ******/
    message <-- EngageWarpDrive(XY_points) = 
    PRE (spaceship_position /= starbase_point) & (spaceship_position : GRID) & (XY_points : NAT1 * NAT1) & (XY_points /= spaceship_position)
    THEN
        IF(spaceship_power < 20)
        THEN
            message  := WARP_DRIVE_INSUFFICIENT_POWER 
        ELSE IF(XY_points /: GRID)
            THEN
                message  := WARP_DRIVE_OUT_OF_REGION
            ELSE IF(XY_points : ASTEROIDS)
                THEN               
                    message  := WARP_DRIVE_FAILED_IMMINENT_ASTEROID_COLLISION
                ELSE IF((XY_points : GRID) &(spaceship_power >= 20))
                    THEN
                        spaceship_position := XY_points ||
                        spaceship_power := spaceship_power - warp_drive_movement_reduction_power ||
                        space_route := space_route <- XY_points ||
                        message  := WARP_DRIVE_SUCCESS 
                    END
                END 
            END
        END
    END;
    
    /***************************************************************************
    INQUIRY OPERATIONS
    ***************************************************************************/  
    
    /****** Spaceship's Mission Status ******/
    
    current_location_message, current_power_message, asteroid_collision_message <-- MissionStatus = 
    BEGIN
        current_location_message := spaceship_position ||
        asteroid_collision_message := asteroid_collision ||
        current_power_message := spaceship_power
    END;
    
    /****** Spaceship's Mission Status ******/  
    
    starship_route_message <-- MissionRoute =
    BEGIN
        starship_route_message := space_route
    END;
    
    /****** Spaceship is docked at Star base ******/  
    
    docked <-- DockedAtStarbase =
    BEGIN
        IF(spaceship_position = starbase_point)
        THEN
            docked := DOCKED
        ELSE
            docked := NOT_DOCKED
        END
    END;
    
    /****** Spaceship Game Status ******/  
    
    game_status_message <-- GameStatus =
    BEGIN
        IF(spaceship_position = starbase_point)
        THEN
            game_status_message := Game_Won
        ELSE IF ((spaceship_position /= starbase_point) & (spaceship_power < 5))
            THEN
                game_status_message := Game_Lost
            ELSE
                game_status_message := Game_Not_Over
            END
        END
    END
END
