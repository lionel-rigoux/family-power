 
function [Ef, xp, bor] = revisit (F, option)

opt.verbose = false;
opt.DisplayWin = false;

[posterior, out] = VBA_groupBMC(F, opt);

N = 2e6;
samples = VBA_random ('Dirichlet', posterior.a, N);
 
n1 = option.size_families(1);
n2 = option.size_families(2);

% correct for advantage of small family
w1 = 1;
w2 = 1;

%w1 = 1;
%w2 = 1;

mf1 = w1 * sum (samples(1:n1,:));
mf2 = w2 * sum (samples(n1+(1:n2),:));

familyFreq(:,1) = mf1 ./ (mf1 + mf2); 
familyFreq(:,2) = mf2 ./ (mf1 + mf2);

% correct for advantage of large family
%familyFreq = [(familyFreq(:,1)./familyFreq(:,2))/(n1/n2) (familyFreq(:,2)./familyFreq(:,1))/(n2/n1)];
%familyFreq = familyFreq./sum(familyFreq,2);


Ef = compositional_mean (familyFreq);
xp(1) = mean (familyFreq(:,1) > 0.5);
xp(2) = mean (familyFreq(:,2) > 0.5);
xp = xp / sum(xp+eps);

bor = out.bor;
end
 