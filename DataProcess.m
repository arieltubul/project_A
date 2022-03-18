function [features] = DataProcess(ayFilterd, azFilterd, fixedlocs,fixedPeaks, new_lable, t_acc)
global MinPeakD En_peaks En_features
%% max locs_y
ayFilterd_ = (ayFilterd - mean(ayFilterd));
azFilterd_ = (azFilterd - mean(azFilterd));
[max_pks_y, max_locs_y] = findpeaks(ayFilterd_);

if( En_peaks ==1 )
    figure;
    plot(t_acc, ayFilterd_ ,'b', t_acc(max_locs_y), max_pks_y, 'or');
    xlim([0 inf]);
    legend('ay');
    title('max peaks ay', 'FontSize', 15);
    ylabel('a_y [m/s^2]', 'FontSize', 12);
    xlabel('time[s]');
    grid on;
end
%% min locs_y
[min_pks_y, min_locs_y] = findpeaks( -(ayFilterd_) );
min_pks_y = -(min_pks_y);

if( En_peaks ==1 )
    figure;
    plot(t_acc, (ayFilterd_),'b', t_acc(min_locs_y), min_pks_y, 'or');
    xlim([0 inf]);
    legend('ay');
    title('min peaks ay', 'FontSize', 15);
    ylabel('a_y [m/s^2]', 'FontSize', 12);
    xlabel('time[s]');
    grid on;
end

%% min locs_z
[min_pks_z, min_locs_z] = findpeaks( -(azFilterd_) );
min_pks_z = -(min_pks_z);

if( En_peaks ==1 )
    figure;
    plot(t_acc, azFilterd_,'b', t_acc(min_locs_z), min_pks_z, 'or');
    xlim([0 inf]);
    legend('az');
    title('min peaks az', 'FontSize', 15);
    ylabel('a_z [m/s^2]', 'FontSize', 12);
    xlabel('time[s]');
    grid on;
end

%% first feature: Peak To Peak
L = length(fixedlocs);
Dist = (MinPeakD * 250);
max_ay=zeros(1,L); idy_max_ay=zeros(1,L);
min_ay=zeros(1,L); idy_min_ay=zeros(1,L);
min_az=zeros(1,L); idz_min_az=zeros(1,L);
% finding max_ay and its index
for idy = 1:length(fixedlocs)
    if new_lable(idy)==+1
        r = fixedlocs(idy);
        if idy == 1
            l = max(fixedlocs(idy) - Dist,1);
        else
            l = fixedlocs(idy) - Dist;
        end
    else
        r = fixedlocs(idy)+ Dist;
        l = fixedlocs(idy);
    end

    for id_locs = 1:length(max_locs_y) %run through indexes of max_locs
        if( max_locs_y(id_locs) >= l && max_locs_y(id_locs) <=r )
            max_ay(idy) = max_pks_y(id_locs);
            idy_max_ay(idy)= max_locs_y(id_locs);
        end
    end

% finding min_ay and its index
    if new_lable(idy)==+1
        l = fixedlocs(idy); %left
        if idy == length(fixedlocs)
            r = min(fixedlocs(idy) + Dist ,l); %right
        else
            r = fixedlocs(idy) + Dist;
        end
    else
        l = fixedlocs(idy) - Dist; %left
        r = fixedlocs(idy); %right
    end

    for id_locs = 1:length(min_locs_y) %run through indexes of min_locs
        if( min_locs_y(id_locs) >= l && min_locs_y(id_locs) <=r )
            min_ay(idy) = min_pks_y(id_locs);
            idy_min_ay(idy)=min_locs_y(id_locs);
        end
    end

    % finding min_az and it's index
    for id_locs = 1:length(min_locs_z) %run through indexes of min_locs
        if( min_locs_z(id_locs) >= l && min_locs_z(id_locs) <=r )
            min_az(idy) = min_pks_z(id_locs);
            idz_min_az(idy)=min_locs_z(id_locs);
        end
    end

end
max_az = fixedPeaks;
max_ay = max_ay'; min_ay = min_ay'; max_az = max_az'; min_az = min_az';
if(En_features == 1)
    figure;
    subplot(4,1,1); scatter(idy_max_ay,max_ay,'g');
    title('max ay');
    subplot(4,1,2); scatter(idy_min_ay,min_ay,'m');
    title('min ay');
    subplot(4,1,3); scatter(t_acc(fixedlocs),max_az,'g');
    title('max az');
    subplot(4,1,4); scatter(idz_min_az,min_az,'m');
    title('min az');
    hold off;
end
p2p_y = max_ay - min_ay;
p2p_z = max_az - min_az;
p2p_tot = p2p_y + p2p_z;

%% fixing id_y & id_z to existing values in t_acc
idy_max_ay_fixed = zeros(L,1);
idy_min_ay_fixed = zeros(L,1);
idz_min_az_fixed = zeros(L,1);

for i = 1:L
    y_max_prep=find(abs(t_acc-0.001*idy_max_ay(i)) <0.007); % find indexed with err less than 0.007
    y_min_prep=find(abs(t_acc-0.001*idy_min_ay(i)) <0.007);
    z_min_prep=find(abs(t_acc-0.001*idz_min_az(i)) <0.007);
    
    y_max_prep_vec = t_acc(y_max_prep); % create a vector with the values that satisfy the above condition
    y_min_prep_vec = t_acc(y_min_prep);
    z_min_prep_vec = t_acc(z_min_prep);
    
    idy_max_ay_fixed(i) = min(y_max_prep_vec*1000 - idy_max_ay(i)); % finding the value from this vector that is closest to the value specified.
    idy_min_ay_fixed(i) = min(y_min_prep_vec*1000 - idy_min_ay(i));
    idz_min_az_fixed(i) = min(z_min_prep_vec*1000 - idz_min_az(i));
    
    idy_max_ay_fixed(i) = 1000*round(0.001*(idy_max_ay_fixed(i) + idy_max_ay(i)), 3);
    idy_min_ay_fixed(i) = 1000*round(0.001*(idy_min_ay_fixed(i) + idy_min_ay(i)), 3);
    idz_min_az_fixed(i) = 1000*round(0.001*(idz_min_az_fixed(i) + idz_min_az(i)), 3);

end
%% second feature: standart deviation (std)
for i = 1:L
    if(idy_max_ay_fixed(i)==0 || idy_min_ay_fixed(i)==0 || idz_min_az_fixed(i)==0)
        stdy(i) = 0;
        stdz(i) = 0;
        continue;
    end
    min_id_y = min(idy_max_ay_fixed(i),idy_min_ay_fixed(i));
    max_id_y = max(idy_max_ay_fixed(i),idy_min_ay_fixed(i));
    min_id_z = min(fixedlocs(i),idz_min_az_fixed(i));
    max_id_z = max(fixedlocs(i),idz_min_az_fixed(i));
    stdy(i) = std(ayFilterd_(min_id_y:max_id_y));
    stdz(i) = std(azFilterd_(min_id_z:max_id_z));
end
std_tot = stdy' + stdz';

features = [p2p_tot, std_tot];
end

