if (array_length(shortest_path) > 0) {
	draw_set_colour(c_white);
	for (var i = 0; i < array_length(shortest_path); i++) {
		var _x = shortest_path[i].x * TILE_SIZE;
		var _y = shortest_path[i].y * TILE_SIZE;
		draw_rectangle(_x, _y, _x + TILE_SIZE, _y + TILE_SIZE, false);
	}
}

draw_self();