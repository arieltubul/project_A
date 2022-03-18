function [fixedPeaks,fixedLocs] = fixLocs(t_acc,pks,locs,MinPeakD)
helpLoc = ones(1,length(locs));
for k=1:length(locs)
    helpLoc(k) = locs(k);
end
last = t_acc(locs(1));
for k=2:length(locs)
   if((t_acc(helpLoc(k))-last) < MinPeakD)
        helpLoc(k)=-1;
   else
        last = t_acc(helpLoc(k));
   end
end
c=0;
%counting the fixed values 
for k=1:length(helpLoc)
    if(helpLoc(k) > 0)
        c = c+1;
    end
end
fixedLocs = ones(1,c);
fixedPeaks = ones(1,c);
l=1;
%creating fixed locations array
for k=1:length(helpLoc)
    if(helpLoc(k) > 0)
        fixedLocs(l) = locs(k);
        fixedPeaks(l) = pks(k);
        l = l+1;
    end
end




