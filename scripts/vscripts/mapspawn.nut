if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player");

::playerController <- null;

ppmod.onauto(function() {

    // set a bunch of cvars while in development
    SendToConsole("sv_cheats 1");
    SendToConsole("developer 1");
    SendToConsole("ent_remove weapon_portalgun");
    SendToConsole("ent_remove viewmodel");
    SendToConsole("crosshair 0");
    SendToConsole("sv_alternateticks 0");

    // initialize player controller with ppmod.player
    ppmod.player(player).then(function (pplayer) {

        ::playerController = PlayerController();
        ::playerController.init(pplayer, pplayer.ent);
        ppmod.interval(function () {
            ::playerController.tick();
        });

    });
});
