/**
 * Input management class
 */
class Inputs {

    /** Normalized movement vector based on the players directional inputs (digital only) */
    movement = Vector(0, 0);
    /** Whether the player is currently holding down the crouching keybind */
    crouched = false;
    /** Whether the player is currently holding down the dashing keybind */
    dashing = false;
    /** Whether the player is currently holding down the using keybind */
    using = false;
    /** Whether the player has jumped this tick */
    jumped = false;
    /** Whether the player has shot a shuriken this tick */
    shuriken = false;

    /** Event function for when the player starts crouching */
    crouchStart = null;
    /** Event function for when the player stops crouching */
    crouchEnd = null;
    /** Event function for when the player starts dashing */
    dashStart = null;
    /** Event function for when the player stops dashing */
    dashEnd = null;
    /** Event function for when the player starts using (trigger engine use on return true) */
    useStart = null;
    /** Event function for when the player stops using */
    useEnd = null;
    /** Event function for when the player jumped */
    jumpStart = null;
    /** Event function for when the player shot a shuriken */
    shurikenStart = null;

    /** Internal state tracking for changes to the crouching keybind */
    _wasCrouched = false;
    /** Internal state tracking for changes to the dashing keybind */
    _wasDashing = false;
    /** Internal state tracking for changes to the using keybind */
    _wasUsing = false;

    /** Internal game_ui entity */
    _gameui = null;

    /**
     * Register directional keys to ppmod.input and bind special keybinds
     */
    constructor() {
        // create input firing entity
        this._gameui = Entities.CreateByClassname("game_ui");
        this._gameui.targetname = "p2ghostrunner-inputs";
        this._gameui.FieldOfView = -1;
        this._gameui.Activate("", 0.0, ::player, null);

        // bind directional keys
        foreach(_, global in ["forward", "moveleft", "back", "moveright"]) {
            getroottable()[global] <- false;
            ppmod.addscript(this._gameui, "pressed" + global, function():(global) {
                getroottable()[global] = true;
            });
            ppmod.addscript(this._gameui, "unpressed" + global, function():(global) {
                getroottable()[global] = false;
            });
        }

        // bind special keybinds
        SendToConsole("bind ctrl +break");
        SendToConsole("bind shift +alt1");
        SendToConsole("bind e +alt2");
        SendToConsole("bind q inv_next");
    }

    /**
     * Tick inputs
     */
    function tick() {
        // calculate movement vector
        //this.movement = Vector(::forward ? 1 : (::back ? -1 : 0), ::moveleft ? -1 : (::moveright ? 1 : 0));
        this.movement.x = ::forward.tointeger() - ::back.tointeger();
        this.movement.y = ::moveright.tointeger() - ::moveleft.tointeger();
        this.movement.Norm();

        // check for crouch state changes
        if (this.crouched != this._wasCrouched) {
            if (this.crouched) {
                if (this.crouchStart) this.crouchStart();
                SendToConsole("+duck");
            } else {
                if (this.crouchEnd) this.crouchEnd();
                SendToConsole("-duck");
            }

            this._wasCrouched = this.crouched;
        }

        // check for dash state changes
        if (this.dashing != this._wasDashing) {
            if (this.dashing) {
                if (this.dashStart) this.dashStart();
            } else {
                if (this.dashEnd) this.dashEnd();
            }

            this._wasDashing = this.dashing;
        }

        // check for use state changes
        if (this.using != this._wasUsing) {
            if (this.using) {
                local runEngineUse = true; // whether the engines original +use should be called
                if (this.useStart) runEngineUse = this.useStart();

                if (runEngineUse)
                    SendToConsole("+use");

            } else {
                if (this.useEnd) this.useEnd();

                SendToConsole("-use");
            }

            this._wasUsing = this.using;
        }

        // check for jump
        if (this.jumped && this.jumpStart) this.jumpStart();

        // check for shuriken
        if (this.shuriken && this.shurikenStart) this.shurikenStart();
    }

    /**
     * Late tick inputs
     */
    function tick_end() {
        this.jumped = false;
        this.shuriken = false;
    }

}