# ZCP-A3-Exile

Install info @ [ZCP @ Exile forums](https://www.exilemod.com)



### BE filters

These are kicks based on what i encountered:

on the line of 'isPlayer' add
```
!="if (isPlayer _this) then {}"
```

on the line of 'units' add
```
!="if (count units group _this>1) then"
```
