clear;

dir_testing = './speechdata/Testing';
dir_output = './speechdata/Output';
mfcc_files = dir([dir_testing,filesep,'*mfcc']);


load('gmms.mat');

speaker = cell(1,30);
speaker_data = cell(1,30);


dim_num = 14;
M = 8;
%collect data
for i=1:length(mfcc_files)
	file_name = [dir_testing,filesep,mfcc_files(i).name]
    lines = dlmread(file_name);
    data = lines(:,1:dim_num);
    speaker_data{i} = transp(data);
	speakers{i} = mfcc_files(i).name;
end

for j=1:length(speakers)

	S = size(gmms,2);
	data = speaker_data{j};
	unknown_name = speakers{j}
	T = size(data,2);
	likelihood = zeros(1,30);

	for gmm_i=1:S
		gmm = gmms{gmm_i};
		pm_noms = zeros(M,T);
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
	    likelihood(gmm_i) = L;
	end
	file_name = [dir_output,filesep,unknown_name];
    file_name = regexprep(file_name,'mfcc','lik');
    print_name = regexp(unknown_name, 'unkn_[0-9]+', 'match')

    fileID = fopen(file_name,'w')

	for k=1:5
		[max_lh,gmm_index] = max(likelihood);
		gmm_name = gmms{gmm_index}.name;
		likelihood(gmm_index) = -Inf;
		fprintf(fileID,'No.%d: speaker: %s, likelihood: %f\n',k,gmm_name, max_lh);
   	end

   	fclose(fileID);
end
