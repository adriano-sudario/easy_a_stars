function grid_get_position(_map_position)
{
    var _grid_x = floor(_map_position.x / TILE_SIZE);
    var _grid_y = floor(_map_position.y / TILE_SIZE);
    return new Vector2(_grid_x, _grid_y);
}

function grid_get_map_size()
{
    return grid_get_position(new Vector2(SCREEN_WIDTH, SCREEN_HEIGHT));
}

function grid_get_map_position(_grid_position)
{
    return new Vector2(_grid_position.x * TILE_SIZE, _grid_position.y * TILE_SIZE);
}