function line_final=moveline(line_init,surge,heave,pitch)

%Given a line defined by 2 points and the instantaneous surge,
% heave and pitch, returns the position of the line after the motion

% line_init  = [x1_init y1_init; x2_init y2_init]
% line_final = [x1_final y1_final; x2_final y2_final]

% Translation matrix
trans = [surge heave; surge heave];

% Rotation matrix
rot = [0 -pitch; pitch 0];
 
% Final position
line_final = line_init + line_init*rot + trans;

return