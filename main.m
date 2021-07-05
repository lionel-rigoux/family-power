clear all

result = family_power ();
t = struct2table(result);

%%
figure
g(1,1) = gramm ( ...
    'x', t.freq_family_B, ...
    'y', t.Ef, ...
    'color', t.n_subject, ...
    'lightness', t.type );
g(1,1).stat_summary('type','sem','geom','line')
g(1,1).geom_abline()
g(1,1).facet_grid(t.model_prob_winner, [])

g(1,2) = gramm ( ...
    'x', t.freq_family_B, ...
    'y', t.xp, ...
    'color', t.n_subject, ...
    'lightness', t.type );
g(1,2).stat_summary('type','sem','geom','line')
g(1,2).geom_vline('xintercept',0.5)
g(1,2).geom_hline('yintercept',0.5)
g(1,2).facet_grid(t.model_prob_winner, [])


g.draw
%%
figure
clear g
g(1) = gramm ( ...
    'x', t.freq_family_B, ...
    'y', (t.freq_family_B<.5) .* (t.xp<=.05) + (t.freq_family_B>.5) .* (t.xp>=.95), ...
    'color', t.type, ...
    'linestyle', t.type );
g(1).stat_summary('type','sem','geom','line')
g(1).geom_vline('xintercept',0.5)
g(1).geom_hline('yintercept',0.5)
g(1).facet_grid(t.model_prob_winner, t.n_subject)


g.draw