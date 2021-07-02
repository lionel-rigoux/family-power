function result = family_power ()
 
options = VBA_factorial_struct ( ...
    'size_families', {[3 5]}, ...
    'model_prob_winner', 0.8,   ...
    'model_prob_noise', 0.03,   ...
    'freq_family_A', (0 : 6) / 6, ...
    'n_subject', 12 : 12 : 24, ...
    'n_simulation', 30 ...
    );
 
result = [];
for i = 1 : numel (options)
    option = options (i)
    parfor j = 1 : options(i).n_simulation
        result = [result; run_simulation(option)];
    end
end

 
end
 
function result = run_simulation (option)
 
result = option;
 
F = generate_group (option);
 
opt.families = { ...
    1 : option.size_families(1), ...
    option.size_families(1) + (1 : option.size_families(2)) ...
    };
opt.verbose = false;
opt.DisplayWin = false;
 
[posterior, out] = VBA_groupBMC(F, opt);
 
result.classic_EF = out.families.Ef';
result.classic_xp = out.families.ep;
 
[result.revisited_EF, result.revisited_xp] = revisit (F, option);
 
end
 
function [Ef, xp] = revisit (F, option)

opt.verbose = false;
opt.DisplayWin = false;
  
[posterior, out] = VBA_groupBMC(F, opt);

N = 5e6;
samples = VBA_random ('Dirichlet', posterior.a, N);
 
n1 = option.size_families(1);
n2 = option.size_families(2);
% todo: change weight for dependent evidences
% idea: check for corr of the samples (simplicial correlation)
w1 = 1 ;
w2 = 1 ;
mf1 = w1 * sum (samples(1:n1,:));
mf2 = w2 * sum (samples(n1+(1:n2),:));
mf = mf1 + mf2;
familyFreq = VBA_softmax([log(mf1/mf);log(mf2/mf)])';

Ef = compositional_mean(familyFreq);
xp = mean(familyFreq > 0.5);
end
 
 
function F = generate_group (option)
 
nA = option.n_subject * option.freq_family_A;
 
for iS = 1 : option.n_subject
    if iS <= nA
        famIdx = 1;
        offset = 0;
    else
        famIdx = 2;
        offset = option.size_families(1);
    end
    
    modIdx = offset + randi (option.size_families(famIdx));
    
    nModel = sum (option.size_families);
    probLoser = (1 - option.model_prob_winner) / (nModel-1);
    pp = probLoser * ones (1, nModel);
    pp(modIdx) = option.model_prob_winner;
    
    logpp = log(pp);
    logpp = logpp + option.model_prob_noise * norm (logpp) * randn (1, nModel);
    
    F(:,iS) = logpp;
end
end
 
function y = compositional_mean(x)

y = exp(mean(log(x)));
y = y / sum(y);
 
end
