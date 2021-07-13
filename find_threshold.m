function thr = find_threshold (ROC)

thr = table();

ROC.type = string(ROC.type);
type = unique(ROC.type);
n_subject = unique(ROC.n_subject);
model_prob_winner = setdiff(unique(ROC.model_prob_winner),0);

for iS = 1 : numel (n_subject)
    for iT = 1 : numel (type)
        for iP = 1 : numel (model_prob_winner)
            
            
            subROC = ROC(ROC.type == type{iT} & ROC.n_subject == n_subject(iS) & ROC.model_prob_winner == model_prob_winner(iP),:);
            
            
            idLast = find(subROC.fpr<.05,1,'last');
            ids = idLast + (0:1);
                 
            tpr = interp1(subROC.fpr(ids),subROC.tpr(ids),.05);
            xp0 = interp1(subROC.fpr(ids),subROC.threshold(ids),.05);
            
            
            tmp = table( ...
                string(type{iT}), n_subject(iS), model_prob_winner(iP),tpr,xp0, ...
                'VariableNames', {'type','n_subject','model_prob_winner','beta','xp0'});
            thr = [thr;tmp ];
        end
    end
end