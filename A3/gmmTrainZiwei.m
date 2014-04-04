function gmms = gmmTrainZiwei()
%function gmms = gmmTrain( dir_train, max_iter, epsilon, M )
% gmmTain
%
%  inputs:  dir_train  : a string pointing to the high-level
%                        directory containing each speaker directory
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
%
%  output:  gmms       : a 1xN cell array. The i^th element is a structure
%                        with this structure:
%                            gmm.name    : string - the name of the speaker
%                            gmm.weights : 1xM vector of GMM weights
%                            gmm.means   : DxM matrix of means (each column 
%                                          is a vector
%                            gmm.cov     : DxDxM matrix of covariances. 
%                                          (:,:,i) is for i^th mixture

dir_train = './speechdata/Training/';
DD = dir(dir_train);
total = struct();
gmms = cell(1,30);
for iFile=1:3%length(DD)
    if ~(length(DD(iFile).name) == 5)
        continue;
    end
    DDD = dir([dir_train,DD(iFile).name,filesep,'*mfcc']);
    data = [];
    for jFile=1:length(DDD)
        lines = dlmread([dir_train,DD(iFile).name,filesep,DDD(jFile).name], ' ');
        lines = lines(:,1:14);
        data = vertcat(data,lines);
    end
    total.(DD(iFile).name) = data;
end
names = fieldnames(total);
for i=1:1%length(names)
    gmms{i} = trainEM(names(i),total.(char(names(i))),1,100,8);
end
end

function gmm = trainEM(name, input, max_iter, epsilon, M)
gmm = struct();
gmm.name = name;
gmm.weights = ones(1,M)/M;
gmm.means = zeros(14, M);
gmm.cov = zeros(14, 14, M);
for i=1:M
    randIndex = ceil(rand * size(input,1));
    gmm.means(:,i) = input(i,:);
    gmm.cov(:,:,i) = eye(14);    
end

i = 1;
prev_L = -Inf;
improvement = Inf;
while (i <= max_iter && improvement >= epsilon)
    [L gmm] = calcLogProb(input, gmm);
    improvement = L - prev_L;
    prev_L = L;
    i = i + 1;
end
end

function [logProb gmm] = calcLogProb(input, gmm)
    onem = ones(size(input));
    M = length(gmm.weights);
    logbm = cell(1,M);
    wmbm = cell(1,M);
    pm = cell(1,M);
    wmbm_total = 0;
    for i=1:M
        mean = gmm.means(:,i);
        cov = ones(1,14)*gmm.cov(:,:,i);
        num = exp(-0.5* sum(((input - onem*diag(mean)).^2)./(onem*diag(cov)),2));
        denom = ((2*pi)^7)*sqrt(prod(cov));
        logbm{i} = num./denom;
        %logbm{i} = -0.5*sum(((input - onem*diag(mean)).^2)./(onem*diag(cov)),2) - 7*log(2*pi) - 0.5*log(prod(cov));

        wmbm{i} = gmm.weights(i)*logbm{i};
        wmbm_total = wmbm_total + wmbm{i};
    end
    for i=1:M
        pm{i} = wmbm{i}./wmbm_total;
        pmsum = sum(pm{i});
        gmm.weights(i) = pmsum/size(input,1);
        gmm.means(:,i) = sum(diag(pm{i})*input)/pmsum;
        gmm.cov(:,:,i) = diag(sum(diag(pm{i})*(input.^2))/pmsum - gmm.means(:,i).^2');
    end
    weights = gmm.weights;
    sum(weights);
    means = gmm.means;
    gmm.cov(:,:,1);
    gmm.cov(:,:,3);
    logProb = log(sum(wmbm_total))
end







