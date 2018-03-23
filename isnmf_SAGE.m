%  ISNMF algorithm - SAGE methodology with rank-1 NMF components as latent
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

function [W, H, cost, time] = isnmf_SAGE(V, Niter, Wini, Hini, upW)

tinit=tic;

if nargin<5
    upW=1;
end

[F,T] = size(V);
K = size(Wini,2);

% Initialization
W = Wini; H = Hini;
v_x = W*H+eps;

% Time and cost
time = zeros(1,Niter+1);
cost = zeros(1,Niter+1);
cost(1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);

for iter=1:Niter
    
    for k=1:K
        
        % Power of component C_k %
        PowC_k = W(:,k) * H(k,:)+eps;

        % Power of residual
        PowR_k = v_x - PowC_k;

        % Wiener gain
        G_k = PowC_k ./ v_x;

        % Posterior power of component C_k %
        V_k = G_k .* (G_k .* V + PowR_k);
        
        % Update column k of W        
        if upW
            W(:,k) = V_k*((H(k,:)+eps).^-1)'/T;
        end
        
        % Update row k of H
        H(k,:) = ((W(:,k)+eps).^-1)'*V_k/F;


        % Norm normalization
        scale = sqrt(sum(W(:,k).^2));
        W(:,k) = W(:,k)/scale;
        H(k,:) = H(k,:)*scale;

        % Update data approximate
        v_x = PowR_k + W(:,k) * H(k,:)+eps;

    end
    
    % Time and cost
    cost(iter+1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);
    time(iter+1) = toc(tinit);

end


end
