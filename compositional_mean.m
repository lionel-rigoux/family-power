function y = compositional_mean(x)

y = exp(mean(log(x)));
y = y / sum(y);
 
end
