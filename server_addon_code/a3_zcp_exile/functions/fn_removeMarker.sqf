private["_nil","_ZCP_RM_markers"];
// Delete the marker in the array
_ZCP_RM_markers = _this select 0;
{
	deleteMarker format['%1',_x];
}count _ZCP_RM_markers;
