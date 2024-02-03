/**
 * Hint instance
 */
class Hint {

    ent = null;

    /**
     * Initialize a hint
     */
    constructor(text) {
        this.ent = Entities.CreateByClassname("env_instructor_hint");
        ppmod.keyval(this.ent, "hint_static", 1);
        ppmod.keyval(this.ent, "hint_caption", text);
        ppmod.keyval(this.ent, "hint_color", "255 255 255");

        SendToConsole("gameinstructor_enable 1");
    }

    /**
     * Set the target of the hint
     */
    function setTarget(target) {
        ppmod.keyval(this.ent, "hint_target", target);
        ppmod.keyval(this.ent, "hint_static", 0);
        ppmod.keyval(this.ent, "hint_nooffscreen", 1);
    }

    /**
     * Set the binding of the hint
     */
    function setBinding(binding) {
        ppmod.keyval(this.ent, "hint_binding", binding);
        ppmod.keyval(this.ent, "hint_icon_onscreen", "use_binding");    
    }

    /**
     * Create a trigger for the hint
     */
    function createTrigger(position, size) {
        local e = this.ent;

        local trigger = ppmod.trigger(position, size);
        ppmod.addscript(trigger, "OnStartTouch", function ():(e, show) {
            show(e);
        });
    }

    /**
     * Create a look trigger for the hint
     */
    function createLookTrigger(position, size, target) {
        local e = this.ent;

        local trigger = ppmod.trigger(position, size, "trigger_look");
        ppmod.keyval(trigger, "target", target);
        ppmod.keyval(trigger, "LookTime", 0.5);
        ppmod.keyval(trigger, "FieldOfView", "20");
        ppmod.addscript(trigger, "OnStartTouch", function ():(e, show) {
            show(e);
        });
    }

    /**
     * Trigger the hint
     */
    function show(e) {
        if (!e.IsValid())
            return;
        
        SendToConsole("gameinstructor_enable 1");

        // don't show stamina bar
        ::renderStamina = false;
        local stamina = ::contr.stamina._staminaText;
        if (stamina) {
            if (stamina.ent)
                stamina.ent.Destroy();
            ::contr.stamina._staminaText = null;
        }

        // show hint now
        ppmod.wait(function():(e) {
            ppmod.fire(e, "ShowHint");
        }, 0.1);

        // hide hint later
        ppmod.wait(function():(e) {
            ppmod.fire(e, "HideHint");
            SendToConsole("gameinstructor_enable 0");
            ::renderStamina = true;
            e.Destroy();
        }, 3);

    }

}