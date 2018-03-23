%  ISNMF algorithm - EM methodology with rank-1 NMF components as latent
%  variables
%
%  Ref: "Expectation-Maximization Algorithms for Itakura-Saito Nonnegative
%  Matrix Factorization", Interspeech 2018, Paul Magron and Tuomas Virtanen
% 
% Inputs :
%     V : nonnegative matrix F*T
%     Niter : number of iterations
%     Wini : initial dictionary F*K
%     Hini : initial activation matrix K*T
%     upW : update W (1, default) or not (0)
% 
% Outputs :
%     W : dictionary
%     H : activation matrix
%     cost : IS divergence over iterations
%     time : computation time over iterations

function [W, H, cost, time] = isnmf_EM(V, Niter, Wini, Hini, upW)

tinit=tic;

if nargin<5
    upW=1;
end

[F,T] = size(V);
K = size(Wini,2);

% Initialization
W= Wini; H = Hini;
v_k = zeros(F,T,K);
for k=1:K
    v_k(:,:,k) = W(:,k)*H(k,:)+eps;
end
v_x =sum(v_k,3);
    
% Time and cost
time = zeros(1,Niter+1);
cost = zeros(1,Niter+1);
cost(1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);

for iter=1:Niter
    
    % E step : posterior power
    pow_post = v_k.^2 .* V./(v_x.^2) + v_k - v_k.^2 ./ v_x;

    % M-step
        
    for k=1:K
        pk = pow_post(:,:,k);
        
        H(k,:) = ((W(:,k)+eps).^-1)'*pk/F;
        %v_k(:,:,k) = W(:,k)*H(k,:);
        %H(k,:) = H(k,:).*   ((W(:,k)'*(pk.*v_k(:,:,k).^(-2)))  ./  (W(:,k)'*(v_k(:,:,k).^(-1)) +eps));
        
        if upW
            W(:,k) = pk*((H(k,:)+eps).^-1)'/T;
        end
        v_k(:,:,k) = W(:,k)*H(k,:)+eps;
    end
    
        
    % L2 normalization
    sumW = sqrt(sum(W.^2));
    W = W ./repmat(sumW,[F 1]) ;
    H = repmat(sumW',[1 T]) .* H;
    
    v_x = sum(v_k,3)+eps;
    
    % Time and cost
    cost(iter+1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);
    time(iter+1) = toc(tinit);

end


end