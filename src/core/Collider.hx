package core;

import echo.Body;

class Collider{
    var onCollide:Body -> Void;
    public var type:CollisionType;
    public var isActive:Bool = true;

    public function new(type:CollisionType, onCollide:Body->Void){
        this.onCollide = onCollide;
        this.type = type;
    }

    public function collideWith(collidingBody:Body){
        if(isActive){
            onCollide(collidingBody);
        }
    }
}

enum CollisionType{
    UNDEFINED;
    VEHICLE;
    ROCK;
    SUN;
    PROJECTILE;
    TARGET;
    FINISH;
    STOPPER;
}