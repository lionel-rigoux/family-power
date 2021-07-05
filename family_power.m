function result = family_power ()
 
options = VBA_factorial_struct ( ...
    'size_families', {[3 5]}, ...
    'model_prob_winner', .5 : 1 : 2.5,   ...
    'model_prob_corr', .3,   ...
    'model_prob_noise', 0.5,   ...
    'freq_family_A', (1 : 7) / 8, ...
    'n_subject', 16 : 16 : 48, ...
    'n_simulation', 50 ...
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
  
F = generate_group (option);
 
opt.families = { ...
    1 : option.size_families(1), ...
    option.size_families(1) + (1 : option.size_families(2)) ...
    };
opt.verbose = false;
opt.DisplayWin = false;
 
[posterior, out] = VBA_groupBMC(F, opt);
 
result = [option; option];

result(1).type = 'classic';
result(1).Ef = out.families.Ef(1);
result(1).xp = out.families.ep(1);

 
[revisited_EF, revisited_xp] = revisit (F, option);
 
result(2).type = 'revisited';
result(2).Ef = revisited_EF(1);
result(2).xp = revisited_xp(1);

end

 

 

