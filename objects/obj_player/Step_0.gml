if (mouse_check_button(mb_right))
	shortest_path = astar_get_shortest_path({ x: x, y: y }, { x: mouse_x, y: mouse_y });
else
	shortest_path = [];

if (mouse_check_button_pressed(mb_left)) {
	var _position = { x: x, y: y };
	previous_grid_position = grid_get_position(_position);
	path = astar_get_shortest_steps(_position, { x: mouse_x, y: mouse_y });
	current_path_index = 0;
}

if (array_length(path) == 0)
	return;

var current_direction = path[current_path_index];

switch (current_direction) {
	case DIRECTION.LEFT:
	case DIRECTION.RIGHT:
		x += spd * (current_direction == DIRECTION.RIGHT ? 1 : -1);
		break;
	
	case DIRECTION.UP:
	case DIRECTION.DOWN:
		y += spd * (current_direction == DIRECTION.DOWN ? 1 : -1);
		break;
}

check_if_arrived(current_direction);