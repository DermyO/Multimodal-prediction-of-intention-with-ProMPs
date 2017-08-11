function d = kl_div(p,q)
    dim= length(p.mu);
    val = log(det(q.sigma) / det(p.sigma));
    val = val - dim + trace(inv(q.sigma) * p.sigma) + (q.mu - p.mu)* inv(q.sigma)*(q.mu - p.mu)';
    d = 1/2*(val);
end