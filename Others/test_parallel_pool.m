clear all;
close all;
clc

nworkers = 12;


for i = 1:10
    fprintf('At the %dth iteration \n',i);
    mycluster = parcluster; %%% create cluster
    set(mycluster,'NumWorkers',nworkers) ;

    % parpool(mycluster,nworkers,AttachedFiles = "taskStartup.m");
    parpool(mycluster,nworkers);
    delete(gcp);
    

end