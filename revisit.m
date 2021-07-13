 
function [result] = revisit (F, option)


result = repmat(option,7,1);

%% classic + classic bor


opt.verbose = false;
opt.DisplayWin = false;

opt.families = { ...
    1 : option.size_families(1), ...
    option.size_families(1) + (1 : option.size_families(2)) ...
    };

[posterior, out] = VBA_groupBMC(F, opt);

bor = out.bor;

result(1).type = 'classic-corrected';
result(1).Ef = (1-bor) * out.families.Ef(2) + bor * .5;
result(1).xp = (1-bor) * out.families.ep(2) + bor * .5;
result(1).bor = bor;


%% classic sampled bor
[F0] = FE_null(out);
bor = 1/(1+exp(out.F(end)-F0));


result(2).type = 'classic-samp-bor';
result(2).Ef = (1-bor) * out.families.Ef(2) + bor * .5;
result(2).xp = (1-bor) * out.families.ep(2) + bor * .5;
result(2).bor = bor;



%% flat priors
opt.verbose = false;
opt.DisplayWin = false;

opt.families = { ...
    1 : option.size_families(1), ...
    option.size_families(1) + (1 : option.size_families(2)) ...
    };

n = sum(option.size_families);
opt.priors.a = ones(n,1) / n ;

[posterior, out] = VBA_groupBMC(F, opt);

result(3).type = 'flat-prior';
result(3).Ef = out.families.Ef(2);
result(3).xp = out.families.ep(2);
result(3).bor = out.bor;

%% flat priors corrected

bor = out.bor;

result(4).type = 'flat-prior-corrected';
result(4).Ef = (1-bor) * out.families.Ef(2) + bor * .5;
result(4).xp = (1-bor) * out.families.ep(2) + bor * .5;
result(4).bor = bor;



%% flat priors sampled bor corrected
[F0] = FE_null(out);
bor = 1/(1+exp(out.F(end)-F0));


result(5).type = 'flat-prior-samp-bor';
result(5).Ef = (1-bor) * out.families.Ef(2) + bor * .5;
result(5).xp = (1-bor) * out.families.ep(2) + bor * .5;
result(5).bor = bor;


%% 

% 
N = 2e6;
samples = VBA_random ('Dirichlet', posterior.a, N);
 
n1 = option.size_families(1);
n2 = option.size_families(2);

w1 = 1/n1;
w2 = 1/n2;

mf1 = w1 * sum (samples(1:n1,:));
mf2 = w2 * sum (samples(n1+(1:n2),:));

familyFreq(:,1) = mf1 ./ (mf1 + mf2); 
familyFreq(:,2) = mf2 ./ (mf1 + mf2);

Ef = compositional_mean (familyFreq);

Ef0 = [.5 .5];

xp(1) = mean (familyFreq(:,1) > Ef0(1));
xp(2) = mean (familyFreq(:,2) > Ef0(2));
xp = xp / sum(xp+eps);

result(6).type = 'revisited';
result(6).Ef = Ef(2);
result(6).xp = xp(2);
result(6).bor = out.bor;

%%
result(7).type = 'revisited-samp-bor';
result(7).Ef = (1-bor) * Ef(2) + bor * .5;
result(7).xp = (1-bor) * xp(2) + bor * .5;
result(7).bor = bor;

end
 