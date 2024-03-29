/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // entry portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -90, 0);
            e.SetOrigin(Vector(0, -765, 128));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 90, 0);
            e.SetOrigin(Vector(-384, -320, 128));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

        // remove vphys clipbrush
        /*
        NOTE: reimplement in another mode
        ppmod.get(Vector(688, -396, 210), 1, "func_clip_vphysics").Destroy();
        */
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}