/**
 * Clamp vector to max length
 */
::clamp_len <- function(vector, max) {
    local v = Vector(vector.x, vector.y, vector.z);
    if (v.Length() > max) {
        v.Norm();
        v *= max;
    }
    return v;
}

/**
 * Check for collisions at a given velocity
 */
::check <- function (velocity) {
    local squareVelocity = Vector((velocity.x > 0 ? 1 : (velocity.x < 0 ? -1 : 0)), (velocity.y > 0 ? 1 : (velocity.y < 0 ? -1 : 0)), 0);
    local origin =::contr.physics.origin + squareVelocity * 8;
    local newOrigin = origin + (velocity / 60.0);
    local result = ppmod.ray(origin + Vector(0, 0, 8), newOrigin + Vector(0, 0, 8));
    if (result.fraction < 1)
        return true;
    result = ppmod.ray(origin + Vector(0, 0, 36), newOrigin + Vector(0, 0, 36));
    if (result.fraction < 1)
        return true;
    result = ppmod.ray(origin + Vector(0, 0, 72), newOrigin + Vector(0, 0, 72));
    if (result.fraction < 1)
        return true;
    return false;
}

/**
 * Check for collisions with a wall
 */
::wall <- function () {
    local origin = ::contr.physics.origin + Vector(0, 0, 16);
    local forward = ::contr.physics.forward2d * 8;
    local left = ::contr.physics.left2d * 32;

    // check right wall
    local r1 = ppmod.ray(origin - forward, origin - forward + left);
    local r2 = ppmod.ray(origin + forward, origin + forward + left);
    if (r1.fraction < 1 && r2.fraction < 1) {
        local delta = r2.point - r1.point;
        delta.Norm();
        return {
            point = r1.point,
            up = delta,
            side = 1,
            ground = ppmod.ray(r1.point, r1.point - Vector(0, 0, 50)).fraction < 1
        };
    }

    // check left wall
    r1 = ppmod.ray(origin - forward, origin - forward - left);
    r2 = ppmod.ray(origin + forward, origin + forward - left);
    if (r1.fraction < 1 && r2.fraction < 1) {
        local delta = r2.point - r1.point;
        delta.Norm();
        return {
            point = r1.point,
            up = delta,
            side = -1,
            ground = ppmod.ray(r1.point, r1.point - Vector(0, 0, 50)).fraction < 1
        };
    }

    return null;
}

/**
 * Change the player speed values
 */
::set_speed <- function (speed) {
    SendToConsole("cl_forwardspeed " + speed);
    SendToConsole("cl_sidespeed " + speed);
    SendToConsole("cl_backspeed " + speed);
    //::pplayer.gravity(speed / 175);
}
