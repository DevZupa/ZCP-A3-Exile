private["_nil","_markers"];
// Delete the marker in the array
_markers = _this select 0;
{
	deleteMarker format['%1',_x];
}count _markers;
