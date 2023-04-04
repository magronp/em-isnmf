%  ISNMF algorithm with multiplicative update rules
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
%     gamma : MUR exponent (default=0.5)
% 
% Outputs :
%     W : dictionary
%     H : activation matrix
%     cost : IS divergence over iterations
%     time : computation time over iterations

function [W, H, cost, time] = isnmf_ML_MUR(V, Niter, Wini, Hini, upW, gamma)

tinit=tic;

if nargin<6
    gamma=1;
end

if nargin<5
    upW=1;
end

[F,T] = size(V);

% Initialization
W= Wini; H = Hini;
v_x = W*H+eps;

% Time and cost
time = zeros(1,Niter+1);
cost = zeros(1,Niter+1);
cost(1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);

% algorithm
for iter=1:Niter
    
    % Update W
    if upW
        W = W.*  (((V.*v_x.^(-2))*H')  ./  ((v_x.^(-1))*H'+eps)).^gamma;
        v_x=W*H+eps;
    end
    
    % Update H
    H = H.*  ((W'*(V.*v_x.^(-2)))  ./  (W'*(v_x.^(-1)) +eps)).^gamma;
    v_x=W*H+eps;
    
    % L2 normalization
    sumW = sqrt(sum(W.^2));
    W = W ./repmat(sumW,[F 1]) ;
    H = repmat(sumW',[1 T]) .* H;
    
    % Time and cost
    cost(iter+1) = sum(V(:)./v_x(:) - log(V(:)./v_x(:))-1);
    time(iter+1) = toc(tinit);
end

end
