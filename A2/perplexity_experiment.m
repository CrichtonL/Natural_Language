delta = [0.01, 0.1, 0.2, 0.5, 1]
e_LM = load('LM_ENG.mat');
f_LM = load('LM_FREN.mat');
for i=1:length(delta)
	perplexity(e_LM.LM,'./Testing','e','smooth',delta(i))
	perplexity(f_LM.LM,'./Testing','f','smooth',delta(i))
end