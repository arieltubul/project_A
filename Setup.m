function [acc, t_acc, orient, t_orient] = Setup(m)
global period_real_time realtime_data log_file

if (realtime_data == 1)
pause(period_real_time);

%% retrieving the data - acclearation, orientation and position 
[acc, t_acc] = accellog(m);
[orient, t_orient] = orientlog(m);
end

% logged data (not real-time)
if (realtime_data == 0)
    m = load(log_file);
    A = m.Acceleration;
    acc = [A.X,A.Y, A.Z];
    T_A = datevec(A.Timestamp);
    T_A = 3600*T_A(:,4)+60*T_A(:,5)+T_A(:,6);
    t_acc = T_A - T_A(1,1); % consistent with start measure time of acc
    O = m.Orientation;
    orient = [O.X,O.Y,O.Z];
    T_O = datevec(O.Timestamp);
    T_O = 3600*T_O(:,4)+60*T_O(:,5)+T_O(:,6);
    t_orient = T_O - T_A(1,1); % consistent with start measure time of acc
end


% for Location. We'll handle this later
%{ 
% [pos, tl] = poslog(m); 
%}


end

