clear all

result = family_power ();
t = struct2table(result);

%%
figure
g(1,1) = gramm ( ...
    'x', t.freq_family_A, ...
    'y', t.Ef, ...
    'color', t.n_subject, ...
    'lightness', t.type );
g(1,1).stat_summary('type','sem','geom','line')
g(1,1).geom_abline()
g(1,1).facet_grid(t.model_prob_winner, [])



g(1,2) = gramm ( ...
    'x', t.freq_family_A, ...
    'y', t.xp, ...
    'color', t.n_subject, ...
    'lightness', t.type );
g(1,2).stat_summary('type','sem','geom','line')
g(1,2).geom_vline('xintercept',0.5)
g(1,2).geom_hline('yintercept',0.5)
g(1,2).facet_grid(t.model_prob_winner, [])


g.draw