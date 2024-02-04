/**
 * Map specific controller
 */
class MapController {

    grapple = null;

    /**
     * Initialize specific map
     */
    constructor() {
        // remove existing hints
        SendToConsole("ent_remove_all env_instructor_hint");
    }

    /**
     * Late initialization once the player is loaded
     */
    function player_init() {
        this.grapple = GrapplePoint(Vector(-1004.156, 2558.428, 56), 450, Vector(0, 0, 15));

        // prepare hints
        local inst = this;
        ppmod.wait(function():(inst) {
            local dashHint = Hint("Hold to enable sensory boost. Let go to dash");
            dashHint.setBinding("alt1");
            dashHint.createTrigger(Vector(92, 1942, -251), Vector(128, 128, 128));

            local grappleHint = Hint("Look at the grapplepoint and tap grapple");
            grappleHint.setBinding("alt2");
            grappleHint.createLookTrigger(Vector(-1004.156, 2558.428, 56), Vector(450, 100, 200), inst.grapple.sphere.GetName());

            local wallrunHint = Hint("Jump towards the wall to wallrun");
            wallrunHint.setBinding("jump");
            wallrunHint.createTrigger(Vector(-1341, 2861, -128), Vector(150, 75, 10));
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {
        if (this.grapple) this.grapple.tick();
    }

}