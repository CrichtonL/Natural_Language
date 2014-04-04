dir_testing = './speechdata/Testing';
dir_output = './speechdata/Output';
mfcc_files = dir([dir_train,filesep,'*mfcc']);

load('gmms.mat');
speakers = cell(1,30);
speaker_data = cell(1,30);


dim_num = 14;



%collect data
for j=1:length(mfcc_files)
	file_name = [dir_testing,filesep,mfcc_files(j).name]
    lines = dlmread(file_name);
    data = lines(:,1:dim_num);
    speaker_data{j} = transp(data);
	speakers{j} = mfcc_files(j).name;
end

%collect correct result



function [speaker_id gmm] = calLogProb(data, gmm)
	T = size(data,2);
	L = 0;

	% bms = zeros(T,M);
	% pm_noms = zeros(T,M);
	% pms = zeros(T,M);

	% M-step
    for i=1:M

    	mean_vector = gmm.means(:,i);
    	mean_matrix = repmat(mean_vector,1,T);

 

    	cov_matrix = gmm.cov(:,:,i);
    	cov_diag = diag(cov_matrix);
    	cov_matrix = repmat(cov_diag,1,T);
    	

    	nom = sum(((data - mean_matrix).^2) ./ cov_matrix,1);
    	nom = exp(-0.5 * nom);
    	denom = ((2*pi)^7)*sqrt(prod(cov_diag));

    	% T x 1 matrix for bm
    	bm = nom / denom;
    	%weighted probability
    	pm_noms(i,:) = gmm.weights(i) * bm;
    end
    L = sum(log(sum(pm_noms)));
    % E-step
    pms = pm_noms ./ repmat(sum(pm_noms,1),M,1);
    total_pm = sum(pms,2);


    gmm.weights = transp(total_pm / T);
    mean_nom = data * transp(pms);
    gmm.means = mean_nom ./ repmat(transp(total_pm),14,1);
    cov_diag = data.^2 * transp(pms) ./ repmat(transp(total_pm),14,1) - gmm.means.^2;

    for i=1:M
    	gmm.cov(:,:,i) = diag(cov_diag(:,i));
    end

end