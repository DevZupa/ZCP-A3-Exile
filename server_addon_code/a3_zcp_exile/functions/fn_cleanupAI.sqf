uiSleep ZCP_AI_killAIAfterMissionCompletionTimer;
{
    private['_y'];
    _y = _x;
    {
        if( !isNull _x && alive _x) then
        {
             _x setDamage 1;
        };
    }count (units _y);
}forEach _this;