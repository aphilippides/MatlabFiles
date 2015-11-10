function MetaRBFSVM

C=[0.1 1 5 10 50 100 150 200 500 1000 1e4 1e5];
Gamma=[0.01 0.1 0.5 1 2 2.5:2.5:10 25:25:100 150:50:500 1000 5000 10000];

RbfSVMnt(0,'RBFSVMSc0_NE4.mat',Gamma,C,'NERndDataSet',1)

RbfSVMnt(0,'RBFSVMSc0_LHNot4.mat',Gamma,C,'LHRndDataSet',0)
RbfSVMnt(1,'RBFSVMSc1_LHNot4.mat',Gamma,C,'LHRndDataSet',0)
RbfSVMnt(2,'RBFSVMSc2_LHNot4.mat',Gamma,C,'LHRndDataSet',0)
RbfSVMnt(3,'RBFSVMSc3_LHNot4.mat',Gamma,C,'LHRndDataSet',0)
RbfSVMnt(4,'RBFSVMSc4_LHNot4.mat',Gamma,C,'LHRndDataSet',0)
RbfSVMnt(5,'RBFSVMSc5_LHNot4.mat',Gamma,C,'LHRndDataSet',0)
RbfSVMnt(6,'RBFSVMSc6_LHNot4.mat',Gamma,C,'LHRndDataSet',0)
RbfSVMnt(7,'RBFSVMSc7_LHNot4.mat',Gamma,C,'LHRndDataSet',0)

RbfSVMnt(0,'RBFSVMSc0_LH4.mat',Gamma,C,'LowHighRndDataSet',0)
RbfSVMnt(1,'RBFSVMSc1_LH4.mat',Gamma,C,'LowHighRndDataSet',0)
RbfSVMnt(2,'RBFSVMSc2_LH4.mat',Gamma,C,'LowHighRndDataSet',0)
RbfSVMnt(3,'RBFSVMSc3_LH4.mat',Gamma,C,'LowHighRndDataSet',0)
RbfSVMnt(4,'RBFSVMSc4_LH4.mat',Gamma,C,'LowHighRndDataSet',0)
RbfSVMnt(5,'RBFSVMSc5_LH4.mat',Gamma,C,'LowHighRndDataSet',0)
RbfSVMnt(6,'RBFSVMSc6_LH4.mat',Gamma,C,'LowHighRndDataSet',0)
RbfSVMnt(7,'RBFSVMSc7_LH4.mat',Gamma,C,'LowHighRndDataSet',0)

RbfSVMnt(1,'RBFSVMSc1_NE4.mat',Gamma,C,'NERndDataSet',1)
RbfSVMnt(2,'RBFSVMSc2_NE4.mat',Gamma,C,'NERndDataSet',1)
RbfSVMnt(3,'RBFSVMSc3_NE4.mat',Gamma,C,'NERndDataSet',1)
RbfSVMnt(4,'RBFSVMSc4_NE4.mat',Gamma,C,'NERndDataSet',1)
RbfSVMnt(5,'RBFSVMSc5_NE4.mat',Gamma,C,'NERndDataSet',1)
RbfSVMnt(6,'RBFSVMSc6_NE4.mat',Gamma,C,'NERndDataSet',1)
RbfSVMnt(7,'RBFSVMSc7_NE4.mat',Gamma,C,'NERndDataSet',1)
