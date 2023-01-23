#include "../input.lp".

%#const horizon=1.
time(1..horizon).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(X',Y'),(X+X',Y+Y')) :- position((X,Y)), direction((X',Y')), position((X+X',Y+Y')).

{ move(R,D ) : direction(D) } 1 :- isRobot(R), time(T).

% - move/3 ----------------------------------------------------------------------
position(R,C ) :- move(R,D ), prev(position(R,C'  )),     nextto(C',D,C).
                :- move(R,D ), prev(position(R,C  )), not nextto(C ,D,_).

% - inertia ---------------------------------------------------------------------
position(R,C ) :- prev(position(R,C )), not move(R,_ ), isRobot(R), time(T).

% - edge collision --------------------------------------------------------------
moveto(C',C ) :- nextto(C',D,C),prev (position(R,C' )), move(R,D ).
 :- moveto(C',C ), moveto(C,C' ), C < C'.

% - vertex collision ------------------------------------------------------------
 :- { position(R,C ) : isRobot(R) }  > 1, position(C), time(T).

% - auxiliaries -----------------------------------------------------------------
 :- { position(R,C ) } != 1, isRobot(R), time(T).    % REDUNDANT but PERFORMANT?
