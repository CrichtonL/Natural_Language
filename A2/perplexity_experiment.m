delta = [0.0]
e_LM = load('LM_ENG.mat');
f_LM = load('LM_FREN.mat');
for i=1:length(delta)
	perplexity(e_LM.LM,'./Testing','e','',delta(i))
	perplexity(f_LM.LM,'./Testing','f','',delta(i))
end