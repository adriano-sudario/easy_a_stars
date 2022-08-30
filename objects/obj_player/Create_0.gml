previous_grid_position = { x: floor(x / TILE_SIZE), y: floor(y / TILE_SIZE) };
spd = 4;
path = [];
shortest_path = [];
current_path_index = 0;
has_changed_axis = false;

function get_direction_axis(_direction) {
	if (_direction == DIRECTION.LEFT || _direction == DIRECTION.RIGHT)
		return DIRECTION_AXIS.HORIZONTAL;
	else
		return DIRECTION_AXIS.VERTICAL;
}

function go_to_next_path(_grid_destination, _current_direction) {
	if (_current_direction == DIRECTION.LEFT || _current_direction == DIRECTION.RIGHT)
		x = _grid_destination.x * TILE_SIZE;
	else
		y = _grid_destination.y * TILE_SIZE;
	
	var _previous_axis = get_direction_axis(_current_direction);
	previous_grid_position = grid_get_position({ x: x, y: y });
	current_path_index++;
	
	if (current_path_index >= array_length(path)) {
		has_changed_axis = false;
		path = [];
	} else if (!has_changed_axis) {
		has_changed_axis = _previous_axis != get_direction_axis(path[current_path_index]);
	}
}

function get_grid_destination(_current_direction) {
	switch (_current_direction) {
		case DIRECTION.LEFT:
			return { x: previous_grid_position.x - 1, y: previous_grid_position.y };
	
		case DIRECTION.RIGHT:
			return { x: previous_grid_position.x + 1, y: previous_grid_position.y };
	
		case DIRECTION.UP:
			return { x: previous_grid_position.x, y: previous_grid_position.y - 1 };
	
		case DIRECTION.DOWN:
			return { x: previous_grid_position.x, y: previous_grid_position.y + 1 };
	}
}

function check_if_arrived(_current_direction) {
	var _grid_destination = get_grid_destination(_current_direction);
	
	switch (_current_direction) {
		case DIRECTION.LEFT:
			if (x <= _grid_destination.x * TILE_SIZE)
				go_to_next_path(_grid_destination, _current_direction);
			break;
	
		case DIRECTION.RIGHT:
			if (x >= _grid_destination.x * TILE_SIZE)
				go_to_next_path(_grid_destination, _current_direction);
			break;
	
		case DIRECTION.UP:
			if (y <= _grid_destination.y * TILE_SIZE)
				go_to_next_path(_grid_destination, _current_direction);
			break;
	
		case DIRECTION.DOWN:
			if (y >= _grid_destination.y * TILE_SIZE)
				go_to_next_path(_grid_destination, _current_direction);
			break;
	}
}