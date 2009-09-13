% NEESPLOTS  Plot the results of NEES analysis for slamtb.
%   NEESPLOTS is a script for evaluating average NEES performance of
%   slamtb. It displays the results of NEESANALYSIS.
%
%   Specify the types of landmarks in variable:  lmkTypes.
%   Specify the number of runs for each lmk in:  numRuns.
%   Specify the length of each run in         :  numFrames.
%   Specify the state dimension in:           :  dimX.
%   Specify the location of log files in      :  logsDir.
%
%   These values must match those in NEESANALYSIS. For the state dimension,
%   it must much that of the NEES computation within SLAMTBSLAVE file.
%
%   See also SLAMTBSLAVE, NEESANALYSIS.

% lmkTypes = {'hmgPnt','idpPnt','ahmPnt'};
lmkTypes = {'idpPnt','ahmPnt'};

numRuns   = 3;
numFrames = 50;

dimX      = 6;
logsDir   = '~/SLAM/logs/pose6d/';

yLim      = [ 50 20];

DOF       = dimX*numRuns;

df = 2;

switch DOF
    case 18
        Lnees = 8.231/numRuns;
        Hnees = 31.526/numRuns;
    case 30
        Lnees = 16.971/numRuns;
        Hnees = 46.979/numRuns;
    case 60
        Lnees = 40.482/numRuns;
        Hnees = 83.298/numRuns;
    case 150
        Lnees = 117.985/numRuns;
        Hnees = 185.800/numRuns;
    otherwise
        error('??? Chi square DOF not defined.')
end

for lt = 1:numel(lmkTypes)
    lmkType = lmkTypes{lt};
    neesData{lt}.data=zeros(numRuns,numFrames);
    neesData{lt}.mean=zeros(1,numFrames);

    for nRun = 1:numRuns
        logFileName = [logsDir lmkType '-' num2str(nRun,'%02d') '.log'];

        fid = fopen(logFileName,'r');
        fgetl(fid);
        data = fscanf(fid,'%d %f\n',[2 inf]);
        neesData{lt}.data(nRun,:) = data(2,:);
    end
    neesData{lt}.mean = mean(neesData{lt}.data);

    figure(50)
    ax(lt) = subplot(numel(lmkTypes),1,lt);
    plot(1:df:numFrames,neesData{lt}.data(:,1:df:numFrames)','linestyle','-','color',[.5 .5 .5])
    title(lmkType)
    hold on
    plot(neesData{lt}.mean,'linestyle','-','color','k','linewidth',2)
    plot([1 numFrames],Lnees*[1 1],'-r')
    plot([1 numFrames],Hnees*[1 1],'-r')
    ylim([0 yLim(lt)])
    hold off
    xlabel('Time (frames)')
    ylabel(['Avg. NEES, ' num2str(dimX) '-DOF, ' num2str(numRuns) ' runs'])
end




% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

