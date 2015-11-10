function [AlphaY, SVs, Bias, Parameters, Ns]=RbfSVCnt(Samples, Labels,Gamma, C, Epsilon,Verbo, CacheSize)
% Function same as RbfSVC but allows fro specifying verosity
% USAGES: 
% [AlphaY, SVs, Bias, Parameters, Ns]=RbfSVC(Samples, Labels)
% [AlphaY, SVs, Bias, Parameters, Ns]=RbfSVC(Samples, Labels,Gamma)
% [AlphaY, SVs, Bias, Parameters, Ns]=RbfSVC(Samples, Labels,Gamma,...
%                                        C, Epsilon, CacheSize)
%
% DESCRIPTION: 
% Construct a non-linear SVM classifier with a radial based kernel, or Guassian kernel, 
%  from the training Samples and Labels
%
% INPUTS:
% Samples: all the training patterns. (a row of column vectors)
% Lables: the corresponding class labels for the training patterns in Samples.
%         (a row vector) (labels are like 1, 2, 3, ..., M )
% Gamma: parameters of the radial based kernel, which has the form
%       of (exp(-Gamma*|X(:,i)-X(:,j)|^2)). (default 1)
% C: Cost of the constrain violation  (default 1)
% Epsilon: tolerance of termination criterion (default 0.001)
% CacheSize: as the buffer to hold the <X(:,i),X(:,j)> (in MB) (default 35)
%
% OUTPUTS:
% AlphaY: Alpha * Y, where Alpha is the non-zero Lagrange Coefficients
%                    Y is the corresponding labels. 
%     in multi-class case:
%        [AlphaY_Class1, AlphaY_Class2, ..., AlphaY_ClassM]
%        +----Ns(1)----+----Ns(2)-----+----+---Ns(M)------+
% SVs : support vectors. That is, the patterns corresponding the non-zero
%       Alphas.
%     in multi-class case:
%        [SVs_Class1, SVs_Class2, ..., SVs_ClassM]
%        +--Ns(1)---+---Ns(2)---+----+---Ns(M)---+
% Bias : the bias in the decision function, which is AlphaY*Kernel(SVs',x)-Bias.
%     in multi-class case:
%        [Bias_Class1, Bias_Class2, ..., Bias_ClassM]
% Parameters: the paramters required by the training algorithm. 
%             (a 10-element row vector)
%            +-----------------------------------------------------------------
%            |Kernel Type| Degree | Gamma | Coefficient | C |Cache size|epsilon| 
%            +-----------------------------------------------------------------
%				 -------------------------------------------+
%            | SVM Type |	nu (nu-svm) | loss tolerance |				
%				 -------------------------------------------+
%            where Kernel Type:
%                   0 --- Linear
%                   1 --- Polynomial: (Gamma*<X(:,i),X(:,j)>+Coefficient)^Degree
%                   2 --- RBF: (exp(-Gamma*|X(:,i)-X(:,j)|^2))
%                   3 --- Sigmoid: tanh(Gamma*<X(:,i),X(:,j)>+Coefficient)
%                  Gamma: If the input value is zero, Gamma will be set defautly as
%                         1/(max_pattern_dimension) in the function. If the input
%                         value is non-zero, Gamma will remain unchanged in the 
%                         function.
%                  C: Cost of the constrain violation (for C-SVC & C-SVR)
%                  Cache Size: as the buffer to hold the <X(:,i),X(:,j)> (in MB)
%                  epsilon: tolerance of termination criterion
%                  SVM Type: 
%                   0 --- c-SVM classifier
%                   1 --- nu-SVM classifier
%                   2 --- 1-SVM 
%                   3 --- c-SVM regressioner
%                  nu: the nu used in nu-SVM classifer (for 1-SVM and nu-SVM)
%						 loss tolerance: the epsilon in epsilon-insensitive loss function	
% Ns: number of SVs for each class (a row vector). This parameter is valid only
%     for the multi-class case, and is 0 for the 2-class case.
%

if (nargin < 2) & (nargin > 7)
   disp(' Incorrect number of input variables.\n');
   help LinearSVM;
else
   if (nargin <=6)
      CacheSize = 200; % set cache size as 35MB
   end
   if (nargin <=5)
      Verbo = 2; % set Verbose style to 0
   end
   if (nargin <=4)
      Epsilon = 0.001; 
   end
   if (nargin <=3)
      C = 1; 
   end
   if (nargin <=2)
      Gamma = 1; 
   end
   Parameters = [2 1 Gamma 1 C CacheSize Epsilon 0 0.5 0.3];
   [AlphaY, SVs, Bias, Parameters, Ns] = osuSVMTrain(Samples, Labels, Parameters,Verbo);
end
