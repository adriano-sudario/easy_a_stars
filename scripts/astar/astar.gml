function AstarNode(_position, _destination, _parent = undefined) constructor {
	gridPosition = grid_get_position(_position);
    position = _position;
    parent = _parent;
	
	static getDistanceValue = function(_from, _to)
	{
		_from = new Vector2(_from.x, _from.y);
		_to = new Vector2(_to.x, _to.y);
	    var _edge = _to.subtract(_from);
	    _edge.x = _edge.x > 0 ? _edge.x : _edge.x * -1;
	    _edge.y = _edge.y > 0 ? _edge.y : _edge.y * -1;

		var _neighborPath = 0;
		
		if (_edge.x > _edge.y)
			_neighborPath = round(_edge.x - _edge.y) * 10;
		else if (_edge.x < _edge.y)
			_neighborPath = round(_edge.y - _edge.x) * 10;
		
	    var _diagonalPaths = _edge.x > _edge.y ? round(_edge.y) * 14 : round(_edge.x) * 14;

	    return _diagonalPaths + _neighborPath;
	}
	
	g = parent != undefined
		? parent.g + getDistanceValue(gridPosition, parent.gridPosition)
		: 0;
	h = getDistanceValue(gridPosition, grid_get_position(_destination));
    f = g + h;
	
	static addAvaiableNeighborToArray = function(_neighbors, _current_neighbor_grid_position,
		_world_grid_size, _destination)
    {
		var _current_neighbor_position = grid_get_map_position(
                new Vector2(_current_neighbor_grid_position.x, _current_neighbor_grid_position.y));
        var _add_to_neighbors = true;
		
		var _is_on_same_parent_position = parent != undefined
			&& _current_neighbor_grid_position.x == parent.gridPosition.x
			&& _current_neighbor_grid_position.y == parent.gridPosition.y;
		var _is_on_same_position = _current_neighbor_grid_position.x == gridPosition.x
			&& _current_neighbor_grid_position.y == gridPosition.y;
		var _is_out_of_room = _current_neighbor_grid_position.x < 0
			|| _current_neighbor_grid_position.y < 0
			|| _current_neighbor_grid_position.x >= _world_grid_size.x
			|| _current_neighbor_grid_position.y >= _world_grid_size.y;
				
        if (_is_on_same_parent_position || _is_on_same_position || _is_out_of_room) {
            _add_to_neighbors = false;
		} else {
			var _current_neighbor_rectangle = {
				x: round(_current_neighbor_position.x),
				y: round(_current_neighbor_position.y),
				width: TILE_SIZE,
				height: TILE_SIZE,
			};
					
			if (collision_rectangle(
				_current_neighbor_rectangle.x, 
				_current_neighbor_rectangle.y,
				_current_neighbor_rectangle.x + _current_neighbor_rectangle.width,
				_current_neighbor_rectangle.y + _current_neighbor_rectangle.height,
				obj_obstacle, false, true))
				_add_to_neighbors = false;
        }

        if (_add_to_neighbors)
			array_push(_neighbors,
				new AstarNode(_current_neighbor_position, _destination, self));
	}
	
	static getNeighbors = function(_start, _destination)
    {
        var _neighbors = [];
		var _world_grid_size = grid_get_map_size();
        
		if (EXCLUDES_DIAGONAL_ASTAR_PATH) {
	        var _current_neighbor_grid_position = new Vector2(gridPosition.x - 1, gridPosition.y);
		
			for (var _x = 0; _x < 2; _x++;)
	        {
				addAvaiableNeighborToArray(
					_neighbors, _current_neighbor_grid_position, _world_grid_size, _destination);
	            _current_neighbor_grid_position.x += 2;
	        }
		
			_current_neighbor_grid_position = new Vector2(gridPosition.x, gridPosition.y - 1);
		
			for (var _y = 0; _y < 2; _y++;)
	        {
	            addAvaiableNeighborToArray(
					_neighbors, _current_neighbor_grid_position, _world_grid_size, _destination);
	            _current_neighbor_grid_position.y += 2;
	        }
		} else {
			var _current_neighbor_grid_position = new Vector2(gridPosition.x - 1, gridPosition.y - 1);
		
	        for (var _y = 0; _y < 3; _y++;)
	        {
	            for (var _x = 0; _x < 3; _x++;)
	            {
	                addAvaiableNeighborToArray(
						_neighbors, _current_neighbor_grid_position, _world_grid_size, _destination);

	                _current_neighbor_grid_position.x += 1;
	            }
				
	            _current_neighbor_grid_position.x -= 3;
	            _current_neighbor_grid_position.y += 1;
	        }
		}

        return _neighbors;
    }
}

function astar_get_path(_node, _path = undefined)
{
    if (_node.g == 0)
        return _path;

    if (_path == undefined)
        _path = [];

	array_insert(_path, 0, _node.gridPosition);

    return astar_get_path(_node.parent, _path);
}

function astar_add_first_neighbors(_node_list, _from_node, _start, _destination)
{
	var _current_neighbors = _from_node.getNeighbors(_start, _destination);
	
	for (var i = 0; i < array_length(_current_neighbors); i++;)
		array_push(_node_list, _current_neighbors[i]);
}

function astar_add_neighbors(_node_list, _checked_nodes, _from_node, _start, _destination)
{
	var _current_neighbors = _from_node.getNeighbors(_start, _destination);
	
    for (var i = array_length(_current_neighbors) - 1; i >= 0; i--;) {
		var _node_on_open = undefined;
		for (var n = 0; n < array_length(_node_list); n++;)
			if (_node_list[n].gridPosition.isSameAs(_current_neighbors[i].gridPosition)) {
				_node_on_open = _node_list[n];
				break;
			}
		
		if (_node_on_open == undefined)
			continue;

        if (_node_on_open.f <= _current_neighbors[i].f)
			array_delete(_current_neighbors, i, 1);
        else if (_node_on_open.f > _current_neighbors[i].f)
			for (var n = 0; n < array_length(_node_list); n++;)
				if (_node_list[n] == _node_on_open) {
					array_delete(_node_list, n, 1);
					break;
				}
    }

    for (var i = array_length(_current_neighbors) - 1; i >= 0; i--;) {
		var _node_checked = undefined;
		for (var n = 0; n < array_length(_checked_nodes); n++;)
			if (_checked_nodes[n].gridPosition.isSameAs(_current_neighbors[i].gridPosition)) {
				_node_checked = _checked_nodes[n];
				break;
			}

        if (_node_checked != undefined)
            array_delete(_current_neighbors, i, 1);
    }

    if (array_length(_current_neighbors) != 0)
		for (var i = 0; i < array_length(_current_neighbors); i++;)
			array_push(_node_list, _current_neighbors[i]);
}

function astar_get_shortest_path(_start, _destination,
	_current_node = undefined, _nodes_to_check = undefined, _checked_nodes = undefined)
{
	_start = new Vector2(_start.x, _start.y);
	_destination = new Vector2(_destination.x, _destination.y);
				
    if (_current_node == undefined)
        _current_node = new AstarNode(_start, _destination);
    else if (_current_node.h == 0)
        return astar_get_path(_current_node);
    else if (_current_node != undefined && _nodes_to_check != undefined)
		for (var i = 0; i < array_length(_nodes_to_check); i++;)
			if (_nodes_to_check[i] == _current_node) {
				array_delete(_nodes_to_check, i, 1);
				break;
			}

    if (_checked_nodes == undefined)
        _checked_nodes = [];

	array_push(_checked_nodes, _current_node);

    if (_nodes_to_check == undefined) {
        _nodes_to_check = [];
		astar_add_first_neighbors(_nodes_to_check, _current_node, _start, _destination);
    } else {
		astar_add_neighbors(_nodes_to_check, _checked_nodes, _current_node, _start, _destination);
    }
	
	array_sort(_nodes_to_check, function(_node1, _node2)
	{
	    return _node1.h - _node2.h;
	});
	
	array_sort(_nodes_to_check, function(_node1, _node2)
	{
	    return _node1.f - _node2.f;
	});
	
	if (array_length(_nodes_to_check) == 0)
		return [];

    return astar_get_shortest_path(
		_start, _destination, _nodes_to_check[0], _nodes_to_check, _checked_nodes);
}

function astar_get_horizontal_step(_previous_step, _step) {
	var _horizontal_difference = _step.x - _previous_step.x;
	
	if (_horizontal_difference < 0)
		return DIRECTION.LEFT;
	else if (_horizontal_difference > 0)
		return DIRECTION.RIGHT;
	
	return undefined;
}

function astar_get_vertical_step(_previous_step, _step) {
	var _vertical_difference = _step.y - _previous_step.y;
	
	if (_vertical_difference < 0)
		return DIRECTION.UP;
	else if (_vertical_difference > 0)
		return DIRECTION.DOWN;
	
	return undefined;
}

function astar_get_shortest_steps(_start, _destination)
{
    var _shortest_path = astar_get_shortest_path(_start, _destination);
	var _shortest_steps = [];
	
	for (var i = 0; i < array_length(_shortest_path); i++;) {
		var _current_path = _shortest_path[i];
		var _previous_path = i == 0 ? grid_get_position(_start) : _shortest_path[i - 1];
		var _horizontal_step = astar_get_horizontal_step(_previous_path, _current_path);
		var _vertical_step = astar_get_vertical_step(_previous_path, _current_path);
		
		if (EXCLUDES_DIAGONAL_ASTAR_PATH) {
			if (_horizontal_step != undefined)
				array_push(_shortest_steps, _horizontal_step);
			else
				array_push(_shortest_steps, _vertical_step);
		} else {
			if (_horizontal_step != undefined && _vertical_step == undefined) {
				array_push(_shortest_steps, _horizontal_step);
			} else if (_horizontal_step == undefined && _vertical_step != undefined) {
				array_push(_shortest_steps, _vertical_step);
			} else if (_horizontal_step != undefined && _vertical_step != undefined) {
				var _previous_path_position = grid_get_map_position(
					new Vector2(_previous_path.x, _previous_path.y));
				var _x1 = round(_previous_path_position.x);
			
				if (_horizontal_step == DIRECTION.LEFT)
					_x1 = _x1 - TILE_SIZE;
				else
					_x1 = _x1 + TILE_SIZE;
			
				var _y1 = round(_previous_path_position.y);
				var _x2 = _x1 + TILE_SIZE;
				var _y2 = _y1 + TILE_SIZE;
				var _horizontal_step_rectangle = { x1: _x1, y1: _y1, x2: _x2, y2: _y2, };
					
				if (collision_rectangle(_horizontal_step_rectangle.x1, _horizontal_step_rectangle.y1,
					_horizontal_step_rectangle.x2, _horizontal_step_rectangle.y2,
					obj_obstacle, false, true)) {
					array_push(_shortest_steps, _vertical_step);
					array_push(_shortest_steps, _horizontal_step);
				} else {
					array_push(_shortest_steps, _horizontal_step);
					array_push(_shortest_steps, _vertical_step);
				}
			}
		}
	}
	
	return _shortest_steps;
}