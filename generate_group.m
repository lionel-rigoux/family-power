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
    %modIdx = offset + (1 : option.size_families(famIdx));
    
    nModel = sum (option.size_families);

    logpp = option.model_prob_noise * randn (1, nModel);
    logpp(modIdx) = logpp(modIdx) + option.model_prob_winner;
    

    F(:,iS) = logpp;
end
end