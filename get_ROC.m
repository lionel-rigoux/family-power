function [ROC] = get_ROC (t)

ROC = table();
t.type = string(t.type);
type = unique(t.type);
n_subject = unique(t.n_subject);
model_prob_winner = setdiff(unique(t.model_prob_winner),0);

for iS = 1 : numel (n_subject)
    for iP = 1 : numel (model_prob_winner)
        for iT = 1 : numel (type)
            subT = t(t.type == type{iT} & t.n_subject == n_subject(iS) & (t.model_prob_winner == model_prob_winner(iP) | t.model_prob_winner == .5),:); %& t.model_prob_winner == model_prob_winner(iP)
try
    
            score = [];
            label = [];
            
            % f2 > f1
            s = subT.xp(subT.freq_family_B>.5 & subT.model_prob_winner > 0);
            score = [score; s];
            label = [label; ones(size(s))];
            % f1 > f2
            s = subT.xp(subT.freq_family_B<.5 & subT.model_prob_winner > 0);
            score = [score; 1-s];
            label = [label; ones(size(s))];
            % f1 == f2
            s = subT.xp(subT.freq_family_B==.5 & subT.model_prob_winner > 0);
            score = [score; s; 1-s];
            label = [label; zeros(2*numel(s),1)];
            % chance
            s = subT.xp(subT.model_prob_winner == 0);
            score = [score; s; 1-s];
            label = [label; zeros(2*numel(s),1)];
                
%             score = subT.xp;
%             score(subT.freq_family_B<.5) = 1 - score(subT.freq_family_B<.5);
%             score(subT.freq_family_B==.5) = max(score(subT.freq_family_B==.5), 1 - score(subT.freq_family_B==.5));
%             score(subT.model_prob_winner==0) = max(score(subT.model_prob_winner==0), 1 - score(subT.model_prob_winner==0));
%             
%             label = subT.freq_family_B ~= .5 & subT.model_prob_winner > 0;
%             
            [fpr,tpr,thr,auc] = perfcurve(label, score, true);
            
            n = numel(thr);
            tmp = table( ...
                string(repmat(type{iT},n,1)), repmat(n_subject(iS),n,1), repmat(model_prob_winner(iP),n,1),thr,fpr,tpr,ones(n,1)*auc, ...
                'VariableNames', {'type','n_subject','model_prob_winner','threshold','fpr','tpr','auc'});
            ROC = [ROC;tmp ];
end
            
        end
    end
end


end


