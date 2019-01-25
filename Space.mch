/* Space
* Author: Vihanga Bandara
* Creation date: 12/20/2018
*/
MACHINE
    Space
    
CONSTANTS
    GRID,
    ASTEROIDS,
    grid_width,
    grid_height,
    starting_point,
    starbase_point, 
    asteroid_collision_reduction_power, 
    normal_movement_reduction_power, 
    warp_drive_movement_reduction_power
    
PROPERTIES 
    grid_width <: NAT1 &    
    grid_width = 1..12 &
    grid_height <: NAT1 &
    grid_height = 1..7 &
    GRID = grid_width*grid_height &
    ASTEROIDS <: GRID &
    ASTEROIDS = {(3 |-> 2), (3|-> 5), (5 |-> 4), (7 |-> 1),(7 |-> 5),(7 |-> 7),(6 |-> 7),(8 |-> 3),(10 |-> 6),(11|-> 2),(12 |-> 5)} &
    starting_point = (1|->1) &
    starting_point : GRID & 
    starting_point /: ASTEROIDS &
    starbase_point = (6|->4) &
    starbase_point : GRID & 
    starbase_point /: ASTEROIDS &
    asteroid_collision_reduction_power : NAT1 &
    asteroid_collision_reduction_power = 10 &
    normal_movement_reduction_power : NAT1 &
    normal_movement_reduction_power = 5 & 
    warp_drive_movement_reduction_power : NAT1 &
    warp_drive_movement_reduction_power = 20
    
END
