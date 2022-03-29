%% extraction and post processing of time-series from the simulation

% data.mat file contains a timeserie X
% the timeseries can be upsampled to provide a total of Ns samples

close all
clear all
load('data.mat') ; 

sampling = true ;                        % the simulation data can be 
Ns = 500 ;                               % exported raw or sampled
T = X.Time ;                             % time vector
finalT = T(size(T,1)-1) ;                % duration of simulation
step = finalT/Ns ;                       % time step
simOut = X.Data ;                        % output from simulation

%% upsampling/downsampling 

sampledData = zeros(Ns+1,size(simOut,2)) ;   % up/downsampled simulation data
sampledTime = (T(1):step:finalT)' ;          % up/downsampled simulation time
for idVar=1:size(simOut,2)
    for dt=1:Ns+1
        t = sampledTime(dt) ;
        i = locateTime(t,T) ;
        sampledData(dt,idVar) = (simOut(i+1,idVar)-simOut(i,idVar))/(T(i+1)-T(i))...
                           * (t-T(i)) + simOut(i,idVar) ; 
    end
end

if sampling == true
    toFile = sampledData ;
    T = sampledTime ;
else 
    toFile = simOut ;
end
%% adding additive white gaussian noise

% first method : awgn function
snr = 100 ;   % signal to noise ratio (percent)
for idVar=1:size(sampledData,2)
   sampledData(:,idVar) = awgn(sampledData(:,idVar),snr) ; 
end

% second method : normal distribution with given standard deviation
sd = 0;   % Standard Deviation Of Random Noise Vector
for idVar=1:size(sampledData,2)
   sampledData(:,idVar) = sampledData(:,idVar) +  sd*randn(size(sampledTime,1),1); 
end



%% post processing to .json file

output = fopen("output.json",'wt');      % output file

txt = "{";
for i=1:size(T,1)
    txt = txt + '"'+ sprintf('%0.5f',T(i))+ '"' + ":{" ;
    for j=1:size(toFile,2)-1
        txt = txt +'"'  + "v"+sprintf('%d',j)  +'"'  + ":" + '"' ...
              + sprintf('%0.5f',toFile(i,j)) + '"' + ','  ;
    end
    txt = txt +'"'  + "v"+sprintf('%d',size(toFile,2))  +'"'  + ":" + '"'...
          + sprintf('%0.5f',toFile(i,size(toFile,2))) + '"'  ;
    txt = txt + "}";
    if i ~= size(T,1)
        txt=txt + ",";
    end
end
txt = txt+"}";
fprintf(output, txt);

%% plot the time series for control

f = figure ;
plot(sampledTime, sampledData);
xlabel('time (s)');
ylabel('simulation output');
title('post processed timeseries');


%% definition of local functions

function i = locateTime(t,T)
    % locates the indice i in T such that
    % T(i) < t < T(i+1)
    i = 1 ;
    while T(i)<t
        i=i+1 ;
    end
    if i~=1
        i = i-1 ;
    end
end