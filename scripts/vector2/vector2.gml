function Vector2(_x, _y) constructor {
	x = _x;
	y = _y;
	
	static sum = function(_vec2) {
		x += _vec2.x;
        y += _vec2.y;
		return self;
	}
	
	static subtract = function(_vec2) {
		x -= _vec2.x;
        y -= _vec2.y;
		return self;
	}
	
	static multiply = function(_vec2) {
		x *= _vec2.x;
        y *= _vec2.y;
		return self;
	}
	
	static divide = function(_vec2) {
		x /= _vec2.x;
        y /= _vec2.y;
		return self;
	}
	
	static ceiling = function() {
		x = ceil(x);
		y = ceil(y);
		return self;
	}
	
	static floor = function() {
		x = floor(x);
		y = floor(y);
		return self;
	}
	
	static length = function() {
		return sqrt((x * x) + (y * y));
	}
	
	static lengthSquared = function() {
		return (x * x) + (y * y);
	}
	
	static normalize = function() {
		var _val = 1.0 / sqrt((x * x) + (y * y));
        x *= _val;
        y *= _val;
		return self;
	}
	
	static round = function() {
		x = round(x);
		y = round(y);
		return self;
	}
	
	static isSameAs = function(_vec2)
    {
        return x == _vec2.x && y == _vec2.y;
    }
	
	static toString = function() {
		return "{ x: " + string(x) + ", y: " + string(y) + " }";
	}
}