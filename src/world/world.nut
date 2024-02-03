IncludeScript("world/freeze");
IncludeScript("world/grapplepoint");
IncludeScript("world/hint");
IncludeScript("world/skip");

/**
 * Main world controller class
 */
::WorldController <- function () {

    local inst = {

        controller = null, // specific map controller
        freeze = Freeze(), // freeze time
        collidableTicks = 0, // ticks since last collision group update

        // methods
        init = null,
        tick = null

    };

    /**
     * Initialize the world controller
     */
    inst.init = function ():(inst) {
        // include map specific code
        switch (GetMapName()) {
            case "sp_a2_triple_laser":
                IncludeScript("world/maps/sp_a2_triple_laser");
                break;
            case "sp_a1_intro1":
                IncludeScript("world/maps/sp_a1_intro1");
                break;
            case "sp_a1_intro3":
                IncludeScript("world/maps/sp_a1_intro3");
                break;
            case "sp_a1_intro4":
                IncludeScript("world/maps/sp_a1_intro4");
                break;
            case "sp_a1_intro5":
                IncludeScript("world/maps/sp_a1_intro5");
                break;
            case "sp_a1_intro6":
                IncludeScript("world/maps/sp_a1_intro6");
                break;
            case "sp_a1_intro7":
                IncludeScript("world/maps/sp_a1_intro7");
                break;
            case "sp_a1_wakeup":
                IncludeScript("world/maps/sp_a1_wakeup");
                break;
            case "sp_a2_intro":
                IncludeScript("world/maps/sp_a2_intro");
                break;
            default:
                IncludeScript("world/maps/default");
                break;
        }

        // initialize map specific controller
        inst.controller = MapController();
    }

    /**
     * Tick the world controller
     */
    inst.tick = function ():(inst) {
        // tick map specific controller
        if (inst.controller)
            inst.controller.tick();

        // tick collision group updater
        if (inst.collidableTicks++ >= 60) {
            inst.collidableTicks = 0;
            local collidables = [
                "prop_weighted_cube",
                "prop_physics",
                "npc_security_camera",
                "npc_portal_floor_turret"
            ];
            
            for (local i = 0; i < 4; i++) {
                local ent = null;
                while (ent = ppmod.get(collidables[i], ent))
                    ent.collisionGroup = 2;
            }
        }

    }

    return inst;
}