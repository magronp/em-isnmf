%  ISNMF algorithm - EM methodology with sources as latent variables
%
%  Ref: "Expectation-Maximization Algorithms for Itakura-Saito Nonnegative
%  Matrix Factorization", Interspeech 2018, Paul Magron and Tuomas Virtanen
% 
% Inputs :
%     V : nonnegative matrix F*T
%     Niter : number of iterations
%     Wini : initial dictionary (cell with J matrices of size F*K_j)
%     Hini : initial activations (cell with J matrices of size K_j*T)
%     upW : update W (1, default) or not (0)
%     gamma : MUR exponent (default=0.5)
%     NiterMstep : number of iterations for the MUR at the Mstep (default=1)
% 
% Outputs :
%     W : dictionary
%     H : activations
%     cost : IS divergence over iterations
%     time : computation time over iterations

function [W, H, cost, time] = isnmf_EM_MUR(V, Niter, Wini, Hini, upW, gamma, NiterMstep)

tinit=tic;

if nargin<7
    NiterMstep=1;
end

if nargin<6
    gamma=1;
end

if nargin<5
    upW=1;
end

[F,T] = size(V);
J = length(Wini);

% Initialization
W = Wini; H = Hini;
v_j = zeros(F,T,J);
for j=1:J
    v_j(:,:,j) = W{j}*H{j};
end
v_x = sum(v_j,3)+eps;
    
% Time and cost
time = zeros(1,Niter+1);
cost = zeros(1,Niter+1);
cost(1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);

for iter=1:Niter
    
    % E step : posterior power
    pow_post = v_j.^2 .* V./(v_x.^2) + v_j - v_j.^2 ./ v_x;
    
    % M-step : MUR
    for j=1:J

        pj = pow_post(:,:,j);
        vj = v_j(:,:,j)+eps;

        for itM =1:NiterMstep
            % Update W
            if upW
                W{j} = W{j}.*   (((pj.*vj.^(-2))*H{j}')  ./  ((vj.^(-1))*H{j}'+eps)).^gamma;
                vj = W{j} * H{j}+eps;
            end

            % Update H
            H{j} = H{j}.*   ((W{j}'*(pj.*vj.^(-2)))  ./  (W{j}'*(vj.^(-1)) +eps)).^gamma;
            v_j(:,:,j) = W{j} * H{j};

            % Norm-2 normalization
            sumW = sqrt(sum(W{j}.^2));
            W{j} = W{j} ./repmat(sumW,[F 1]) ;
            H{j} = repmat(sumW',[1 T]) .* H{j};

        end
    end
    v_x = sum(v_j,3)+eps;
    
    % Time and cost
    cost(iter+1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);
    time(iter+1) = toc(tinit);

end


end