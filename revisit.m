 
function [Ef, xp] = revisit (F, option)

opt.verbose = false;
opt.DisplayWin = false;

[posterior, out] = VBA_groupBMC(F, opt);

N = 2e6;
samples = VBA_random ('Dirichlet', posterior.a, N);
 
n1 = option.size_families(1);
n2 = option.size_families(2);

w1 = 1;
w2 = 1;

mf1 = w1 * sum (samples(1:n1,:));
mf2 = w2 * sum (samples(n1+(1:n2),:));

familyFreq(:,1) = mf1 ./ (mf1 + mf2); 
familyFreq(:,2) = mf2 ./ (mf1 + mf2);


Ef = compositional_mean (familyFreq);
xp = mean (familyFreq >= 0.5);
xp = xp / sum(xp);
end
 