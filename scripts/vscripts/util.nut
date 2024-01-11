::pplayer <- null;
::player <- null;
::contr <- null;
::eyes <- null;

/**
 * Get the normalized x,y player forward vector
 */
::forwardVec <- function() {
    local vec = ::eyes.GetForwardVector() * Vector(1, 1, 0);
    vec.Norm();
    return vec;
}

/**
  * Get the noramlized x,y player left vector
  */
::leftVec <- function() {
    local vec = ::eyes.GetLeftVector() * Vector(1, 1, 0);
    vec.Norm();
    return vec;
}

/**
 * Get the normalized movement vector based on the players controls
 */
function movementVec() {
    local vec = ::contr.isCrouched ? Vector(0, 0) : Vector(::forward ? 1 : (::back ? -1 : 0), ::moveleft ? -1 : (::moveright ? 1 : 0));
    vec.Norm();
    return vec;
}

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
    local origin = ::player.GetOrigin() + squareVelocity * 8;
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
 * Change the player speed values
 */
::set_speed <- function (speed) {
    SendToConsole("cl_forwardspeed " + speed);
    SendToConsole("cl_sidespeed " + speed);
    SendToConsole("cl_backspeed " + speed);
    ::pplayer.gravity(speed / 175);
}
