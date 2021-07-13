function [F0m] = FE_null(out)

L = out.L;

% derives the free energy of the 'null' (H0: equal frequencies)
[K,n] = size(L);

NN = 5e4;
fK = .5 * [
    VBA_random('Dirichlet',out.options.priors.a(1:3)',NN);
    VBA_random('Dirichlet',out.options.priors.a(4:8)',NN) ];


for j = 1 : NN
    
    
    F0m(j) = 0;
    for i=1:n
        g = VBA_softmax(L(:,i) + log(fK(:,j)));
        for k=1:K
            F0m(j) = F0m(j) + g(k).*(L(k,i)-log(g(k)+eps)+log(fK(k,j)+eps));
        end
    end
    
    
end

F0m = mean(F0m);


%
% F0m2 = 0;
% for i=1:n
%     tmp = L(:,i) - max(L(:,i));
%     g = exp(tmp)./sum(exp(tmp));
%     for k=1:K
%         F0m2 = F0m2 + g(k).*(L(k,i)-log(g(k)+eps)+log(1/K));
%     end
% end