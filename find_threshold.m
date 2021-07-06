function [ROC] = find_threshold (t)

ROC = table();
t.type = string(t.type);
type = unique(t.type);
n_subject = unique(t.n_subject);
model_prob_winner = unique(t.model_prob_winner);

for iS = 1 : numel (n_subject)
    for iP = 1 : numel (model_prob_winner)
        for iT = 1 : numel (type)
            subT = t(t.type == type{iT} & t.n_subject == n_subject(iS) & t.model_prob_winner == model_prob_winner(iP),:);
            [fpr,tpr,thr,auc] = perfcurve(subT.freq_family_B>.5,subT.xp, true);
            
            n = numel(thr);
            tmp = table( ...
                string(repmat(type{iT},n,1)), repmat(n_subject(iS),n,1), repmat(model_prob_winner(iP),n,1),thr,fpr,tpr,ones(n,1)*auc, ...
                'VariableNames', {'type','n_subject','model_prob_winner','threshold','fpr','tpr','auc'});
            ROC = [ROC;tmp ];
            
        end
    end
end


end


